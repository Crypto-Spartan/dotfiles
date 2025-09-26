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
    local result = ''
    if buf_count == 0 and oil_count > 0 then
        result = 'Oil Buffers: ' .. oil_count
    elseif buf_count > 0 and oil_count == 0 then
        result = 'Buffers: ' .. buf_count
    elseif buf_count > 0 and oil_count > 0 then
        result = ('Oil Buffers: %d | Buffers: %d'):format(oil_count, buf_count)
    else
        result = nil
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
-- get_buf_count()

local filename = {
    'filename',
    path = 3
}
local fileformat = {
    'fileformat',
    padding = { left = 1, right = 2 }
}
local function cursor_location()
    -- local status, cursor_pos = pcall(vim.api.nvim_win_get_cursor, 0)
    -- vim.notify('status: '..status)
    -- vim.notify('cursor_pos: '..vim.inspect(cursor_pos))
    -- if not status then
    --     return 'test'
    -- end
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- print('cursor_pos: '..vim.inspect(cursor_pos))
    local line, col = cursor_pos[1], cursor_pos[2] + 1
    -- print('line: '..line)
    -- print('col: '..col)
    local total_lines = vim.api.nvim_buf_line_count(0)
    -- print('total_lines: '..total_lines)
    local line_text = vim.api.nvim_buf_get_lines(0, line-1, line, false)
    local line_len = line_text[1]:len()
    -- print('line_text: '..line_text)
    local line_pct = (line / total_lines) * 100
    local col_pct = (col / line_len) * 100
    local location_str = ('Line: %d/%d (%2d%%) | Col: %d/%d (%2d%%)'):format(line, total_lines, line_pct, col, line_len, col_pct)
    -- print('location_str: '..location_str)
    return location_str
end

return {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    -- config = function()
    --     local str = cursor_location()
    --     print(str)
    --     vim.notify(str)
    -- end,
    opts = {
        sections = {
            lualine_a = { 'mode', 'filesize' },
            lualine_b = { 'branch', 'diff', 'diagnostics', 'lsp_status' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', fileformat, 'filetype' },
            -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { get_buf_count },
            -- lualine_z = { cursor_location },
            lualine_z = { 'progress', 'location' },
        },
        -- inactive_sections = {
        --     lualine_a = {},
        --     lualine_b = {},
        --     lualine_c = { 'filename' },
        --     lualine_x = { cursor_location },
        --     lualine_y = {},
        --     lualine_z = {},
        -- }
    }
}
--     'nvim-lualine/lualine.nvim',
--     event = 'VeryLazy',
--     opts = {
--         icons_enabled = false,
--         sections = {
--             lualine_c = { 'filename', 'filesize' },
--             lualine_x = { 'encoding', 'filetype' },
--             lualine_y = { get_buf_count },
--             lualine_z = { 'progress', 'location' },
--         },
--     }
-- }
