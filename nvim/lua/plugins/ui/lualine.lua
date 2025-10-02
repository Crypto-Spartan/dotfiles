local function get_buf_count()
    -- local listed_bufs = vim.fn.getbufinfo({'buflisted'})
    -- local loaded_bufs = vim.fn.getbufinfo( 'bufloaded' )

    local listed_bufs = vim.api.nvim_list_bufs()
    local buf_count = 0
    local oil_count = 0

    -- vim.notify(vim.inspect(listed_bufs))
    for i = 1, #listed_bufs do
        local buf = listed_bufs[i]
        local buf_name = vim.api.nvim_buf_get_name(buf)
        -- vim.notify('buf_name: ' .. buf_name)
        -- vim.notify('is loaded: ' .. tostring(vim.api.nvim_buf_is_loaded(v)))

        -- if (buf_name == nil or #buf_name == 0) then
        --     if vim.api.nvim_buf_is_loaded(buf) then
        --         vim.cmd('bd ' .. buf)  -- buffer delete? need to check this
        --     end
        -- elseif string.sub(buf_name, 1, 4) == 'oil:' then
        --     -- print(buf_name)
        --     oil_count = oil_count + 1
        -- else
        --     buf_count = buf_count + 1
        -- end

        if buf_name ~= nil and buf_name:len() > 0 then
            if vim.startswith(buf_name, 'oil:') then
                oil_count = oil_count + 1
            else
                buf_count = buf_count + 1
            end
        end
    end

    -- result = 'Buffers: ' .. buf_count
    local result
    if buf_count == 0 and oil_count > 0 then
        result = 'Oil Buffers: ' .. oil_count
    elseif buf_count > 0 and oil_count == 0 then
        result = 'Buffers: ' .. buf_count
    elseif buf_count > 0 and oil_count > 0 then
        result = ('Oil Buffers: %d | Buffers: %d'):format(oil_count, buf_count)
    end

    -- print(result)
    return result
    -- print(count)
    -- return count

    -- print(#listed_bufs)
    -- return #listed_bufs
    -- print(dump(loaded_bufs))

    -- local hash = {}
    -- local result = {}
    --
    -- for _,v in ipairs(listed_bufs) do
    --     if (not hash[v]) then
    --         result[#result+1] = v
    --         hash[v] = true
    --     end
    -- end
    --
    -- for _,v in ipairs(loaded_bufs) do
    --     if (not hash[v]) then
    --         result[#result+1] = v
    --         hash[v] = true
    --     end
    -- end
    --
    -- return len(result)
end

local filename = {
    'filename',
    path = 3
}
local fileformat = {
    'fileformat',
    padding = { left = 1, right = 2 }
}

local custom_fn = vim.custom_fn

local function memory_usage()
    local memory_bytes = vim.uv.resident_set_memory()
    return 'RAM Usage: ' .. custom_fn.format_bytes(memory_bytes)
end

local function filesize()
    local size = math.max(vim.fn.line2byte(vim.fn.line('$') + 1) - 1, 0)
    return custom_fn.format_bytes(size)
end

local function cursor_location()
    local total_lines = vim.fn.line('$')
    if total_lines <= 0 then
        return ''
    end

    local line_str = 'Line: %s'
    local line_num = vim.fn.line('.')
    if total_lines == 1 then
        line_str = line_str:format('Top')
    elseif total_lines == line_num then
        line_str = line_str:format('Bot')
    else
        local line_pct = math.floor(line_num / total_lines * 100)
        line_str = line_str:format(
            ('%d/%d (%d%%%%)'):format(line_num, total_lines, line_pct)
        )
    end

    local line_len = vim.fn.charcol('$')
    if line_len <= 0 then
        return line_str
    end

    local col_num = vim.fn.charcol('.')
    local col_pct = math.floor(col_num / line_len * 100)
    local col_str = ('Col: %d/%d (%d%%%%)'):format(col_num, line_len, col_pct)

    local ret_str = ('%s | %s'):format(line_str, col_str)
    return ret_str
end

local function cursor_line()
    local total_lines = vim.fn.line('$')
    if total_lines <= 0 then
        return ''
    end

    local line_str = 'Line: %s (%d%%%%)'
    local line_num = vim.fn.line('.')
    if total_lines == 1 then
        return line_str:format('Top', 0)
    elseif total_lines == line_num then
        return line_str:format('Bot', 100)
    else
        return line_str:format(
            ('%d/%d'):format(line_num, total_lines),
            math.floor(line_num / total_lines * 100)
        )
    end
end

local function cursor_col()
    local line_len = vim.fn.charcol('$')
    if line_len <= 0 then
        return ''
    end

    local col_num = vim.fn.charcol('.')
    local col_pct = math.floor(col_num / line_len * 100)
    return ('Col: %d/%d (%d%%%%)'):format(col_num, line_len, col_pct)
end

local function progress()
    local cur = vim.fn.line('.')
    -- print('cur: '..vim.inspect(cur))
    local total = vim.fn.line('$')
    -- print('total: '..vim.inspect(total))
    if cur == 1 then
        return 'Top'
    elseif cur == total then
        return 'Bot'
    else
        return ('%2d%%%%'):format(math.floor(cur / total * 100))
    end
end

local function location()
    local line = vim.fn.line('.')
    local col = vim.fn.charcol('.')
    return ('%3d:%-2d %d %d'):format(line, col, vim.fn.line('$'), vim.fn.charcol('$'))
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
        options = {
            -- section_separators = { left = '', right = '' },
            -- component_separators = { left = '', right = '' },
            component_separators = '',
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics', 'lsp_status' },
            lualine_c = { filename },
            -- lualine_x = { get_buf_count, memory_usage },
            lualine_x = { memory_usage },
            lualine_y = { 'encoding', fileformat, 'filetype', filesize },
            lualine_z = { cursor_line, cursor_col }
        },
        extensions = { 'aerial', 'fzf' , 'lazy', 'man', 'mason', 'trouble' }
    }
}
