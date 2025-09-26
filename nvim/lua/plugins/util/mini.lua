local _full_filesize_str = ''
-- local _completed_get_filesize = false
local filesize_cache = {}

local function choose_filsesize_truncated(trunc_width, full_str, filesize_str)
    local truncated = MiniStatusLine.is_truncated(trunc_width)
    if truncated then
        return filesize_str
    else
        return full_str
    end
end

local function get_time_secs()
    return vim.custom_fn.round_to_int(vim.uv.now() / 1000)
end

local function get_filesize(filepath)
    vim.validate('filepath', filepath, 'string', true)
    if filepath == nil or filepath == '' then
        filepath = vim.fn.getreg('%')
    end
    return vim.fn.getfsize(filepath)
end
local function get_filesize_str(filepath)
    return vim.custom_fn.format_bytes(get_filesize(filepath))
end

local function get_filesize_coop(filepath)
    vim.validate('filepath', filepath, 'string', true)
    if filepath == nil or filepath == '' then
        filepath = vim.fn.getreg('%')
    end
    local coop_uv = package.loaded['coop.uv']
    local fs_stat_err, stat_res = coop_uv.fs_stat(filepath)
    if fs_stat_err then
        return 0
    else
        return stat_res.size
    end
end
local function get_filesize_str_coop()
    return vim.custom_fn.format_bytes(get_filesize_coop(filepath))
end
local function get_dir_info(dirpath)
    vim.validate('dirpath', dirpath, 'string')
    local coop_uv = package.loaded['coop.uv']

    local scandir_err, dir_handle = coop_uv.fs_scandir(dirpath)
    -- assert(not scandir_err, scandir_err)
    -- local dir_handle = uv.fs_scandir(dirpath)
    if scandir_err or not dir_handle then
        -- vim.print('dir_handle: '..vim.inspect(dir_handle))
        -- vim.notify('no dir_handle', vim.log.levels.ERROR)
        -- error('Error opening directory: '..dirpath)
        -- vim.print(dir_handle)
        return 0, 0, 0
    end

    local total_bytes = 0
    local total_filecount = 0
    local total_dircount = 0

    while true do
        local entry_name, entry_type = vim.uv.fs_scandir_next(dir_handle --[[@as uv.uv_fs_t]])
        if not entry_name or not entry_type then
            break
        end

        if entry_name ~= '.' and entry_name ~= '..' then
            local entry_path = vim.fs.joinpath(dirpath, entry_name)
            if entry_type == 'file' then
                total_filecount = total_filecount + 1
                total_bytes = total_bytes + vim.fn.getfsize(entry_path)
            elseif entry_type == 'directory' then
                local bytes, filecount, dircount = get_dir_info(entry_path)
                total_bytes = total_bytes + bytes
                total_filecount = total_filecount + filecount
                total_dircount = total_dircount + dircount + 1
            elseif entry_type == 'link' then
                -- do nothing
            else
                -- should be unreachable
                -- vim.notify(
                --     ('unable to get filesize for %s (filetype `%s`)'):format(entry_path, entry_type),
                --     vim.log.levels.WARN
                -- )
            end
        end
    end

    return total_bytes, total_filecount, total_dircount
end
-- local filesize_notify_throttle = vim.custom_fn.throttle(5000, function(d)
--     vim.notify(vim.inspect(d))
-- end
local function get_filesize_oil(trunc_width, timeout)
    local oil = package.loaded.oil
    local oil_entry = oil.get_cursor_entry()
    if oil_entry == nil or next(oil_entry) == nil or oil_entry.name == nil then
        -- _completed_get_filesize = true
        return ''
    end

    -- local status, path = pcall(vim.fs.abspath, vim.fs.joinpath(oil_dir, oil_entry.name))
    -- if not status then
    --     _completed_get_filesize = true
    -- end
    local oil_dir = oil.get_current_dir(0)
    local path = vim.fs.abspath(vim.fs.joinpath(oil_dir, oil_entry.name))
    local cache_entry = filesize_cache[path]

    if cache_entry ~= nil then
        return choose_filesize_truncated(trunc_width, cache_entry.full_str, cache_entry.filesize_str)
    else
        filesize_cache[path] = { pending = true }
        local coop = package.loaded.coop

        local filesize_str, full_str = '', oil_entry.name
        if oil_entry.type == 'directory' then 
            local bytes, filecount, dircount = coop.spawn(get_dir_info, path):await()
            local non_empty_strs = {}
            if dircount ~= nil and dircount > 0 then
                table.insert(non_empty_strs, dircount..' dirs')
            end
            if filecount ~= nil and filecount > 0 then
                table.insert(non_empty_strs, filecount..' files')
                filesize_str = vim.custom_fn.format_bytes(bytes)
                table.insert(non_empty_strs, filesize_str)
            end

            local str_joined
            if non_empty_strs:len() > 0 then
                str_joined = vim.custom_fn.string_join(non_empty_strs, ', ')
            else
                str_joined = 'empty'
            end

            full_str = full_str..'/: '..str_joined
        else
            if oil_entry.type == 'file' then
                filesize_str = coop.spawn(get_filesize_str_coop, path):await()
            elseif oil_entry.type == 'link' then
                local oil_meta = oil_entry.meta
                local ltype = oil_meta.link_stat.type
                if ltype == 'file' then
                    filesize_str = coop.spawn(get_filesize_str_coop, oil_meta.link):await()
                    full_str = full_str..' (link)'
                else
                    filesize_str = 'link'
                    if ltype == 'directory' then
                        full_str = full_str..'/'
                    end
                end
            else
                vim.notify(
                    ('unable to get filesize for %s (filetype `%s`)'):format(path, oil_entry.type),
                    vim.log.levels.WARN
                )
                return ''
            end

            full_str = full_str..': '..filesize_str
        end

        filesize_cache[path] = {
            pending = false,
            full_str = full_str,
            filesize_str = filesize_str,
            timestamp = get_time_secs() + timeout
        }
        return choose_filesize_truncated(trunc_width, full_str, filesize_str)
        -- return ''
    end
end
local last_sec = 0
local function get_mini_filesize_str_coop(trunc_width)
    local now = get_time_secs()

    for path, data in pairs(filesize_cache) do
        if not data.pending and now > data.timestamp then
            filesize_cache[path] = nil
        end
    end

    local buf_name = vim.api.nvim_buf_get_name(0)
    local timeout = 15
    -- local buf_info = vim.fn.getbufinfo(0)
    -- if buf_info:len() > 0 then
    --     buf_info = buf_info[1]
    --     if buf_info.name ~= buf_name then
    --         timeout = 30
    --     end
    -- end

    local coop = package.loaded.coop
    if buf_name:sub(1, 4) == 'oil:' then
        return coop.spawn(get_filesize_oil, trunc_width, timeout):await(250, 50)
    elseif buf_name:len() > 0 and buf_name:sub(-1) ~= '/' then
        local cache_entry = filesize_cache[buf_name]
        if cache_entry ~= nil then
            if not cache_entry.pending then
                return cache_entry.filesize_str
            end
        else
            filesize_cache[buf_name] = { pending = true }
            local get_filesize_deferred = function()
                local filesize_str = coop.spawn(get_filesize_str_coop, buf_name):await(500, 50)
                if filesize_str ~= nil and filesize_str:len() > 0 then
                    filesize_cache[buf_name] = {
                        pending = false,
                        filesize_str = filesize_str,
                        timestamp = get_time_secs() + timeout
                    }
                end
            end
            vim.defer_fn(get_filesize_deferred, 10)
        end
    end
end

-- local filesize_notify_throttle = vim.custom_fn.throttle(5000, function(d)
--     vim.notify(vim.inspect(d))
-- end)

local function get_mini_statusline_opts(use_icons)
    -- need to fill in
end


return {
    'echasnovski/mini.nvim',
    version = false,
    event = 'VimEnter',
    config = function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.cursorword').setup()
        -- require('mini.diff').setup()
        -- require('mini.hipatterns').setup()
        if not vim.g.have_nerd_font then
            require('mini.icons').setup({
                style = 'ascii',
            })
        end

        require('mini.move').setup({
            mappings = {
                -- visual mode, alt+shift+<hl>
                left = '<M-S-h>',
                right = '<M-S-l>',
                -- normal mode, alt+shift+<hl>
                line_left = '<M-S-h>',
                line_right = '<M-S-l>',
            }
        })
        -- require('mini.statusline').setup({
        --     use_icons = vim.g.have_nerd_font
        -- })

        require('mini.trailspace').setup()
    end
}
