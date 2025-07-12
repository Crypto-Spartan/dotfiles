---@diagnostic disable: undefined-field

-- local function IntToHex(color_table)
--     for k,v in pairs(color_table) do
--         color_table[k] = ('%#x'):format(v)
--     end
--     return color_table
-- end


local uv = vim.uv
local CF = {}

-- colors ----------------------------------------------------------------------
local function clamp(color_val)
    vim.validate('color_val', color_val, 'number')
    return math.min(math.max(color_val, 0), 255)
end

CF.lighten_darken_color = function(color, pct)
    vim.validate('color', color, 'number')
    vim.validate('pct', pct, 'number')

    local r = CF.round_to_int(math.floor(color / 0x10000) * pct)
    local g = CF.round_to_int((math.floor(color / 0x100) % 0x100) * pct)
    local b = CF.round_to_int((color % 0x100) * pct)
    return clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b)
end

-- filesystem ------------------------------------------------------------------
CF.format_bytes = function(bytes)
    vim.validate('bytes', bytes, 'number')

    if bytes < 1024 then
        return string.format('%dB', bytes)
    elseif bytes < 1048576 then
        return string.format('%.2fKiB', bytes / 1024)
    elseif bytes < 1073741824 then
        return string.format('%.2fMiB', bytes / 1048576)
    else
        return string.format('%.2fGiB', bytes / 1073741824)
    end
end

CF.get_filesize = function(filepath)
    vim.validate('filepath', filepath, 'string', true)
    if filepath == nil or filepath == '' then
        filepath = vim.fn.getreg('%')
    end
    return vim.fn.getfsize(filepath)
end

CF.get_filesize_str = function(filepath)
    return CF.format_bytes(CF.get_filesize(filepath))
end

CF.trim_oil_path = function(path)
    if vim.startswith(path, 'oil://') then
        path = path:sub(7)
    end
    return path
end

CF.get_parent_dir = function(path)
    vim.validate('path', path, 'string')
    return vim.fn.fnamemodify(path, ':p:h')
end

CF.get_nvim_cwd = function()
    return CF.get_parent_dir(CF.trim_oil_path(vim.fn.getcwd()))
end,

CF.get_buf_cwd = function()
    return CF.get_parent_dir(CF.trim_oil_path(vim.api.nvim_buf_get_name(0)))
end

-- numbers ---------------------------------------------------------------------
CF.round_to_int = function(n)
    return math.floor(n + 0.5)
end

-- strings ---------------------------------------------------------------------
CF.string_contains = function(str, sub)
    return str:find(sub, 1, true) ~= nil
end

CF.string_startswith = function(str, start)
    return str:sub(1, #start) == start
end

CF.string_endswith = function(str, ending)
    return ending == '' or str:sub(-#ending) == ending
end

CF.string_replace = function(str, old, new)
    vim.validate('str', str, 'string')
    vim.validate('old', old, 'string')
    vim.validate('new', new, 'string')
    
    local s = str
    local search_start_idx = 1

    while true do
        local start_idx, end_idx = s:find(old, search_start_idx, true)
        if (not start_idx) then
            break
        end

        local postfix = s:sub(end_idx + 1)
        s = s:sub(1, (start_idx - 1)) .. new .. postfix

        search_start_idx = -1 * postfix:len()
    end

    return s
end

CF.string_insert = function(str, pos, text)
    return str:sub(1, pos - 1) .. text .. str:sub(pos)
end

CF.string_join = function(str_list, sep)
    vim.validate('str_list', str_list, 'table')
    vim.validate('sep', sep, 'string')

    local str = ''
    if #str_list > 0 then
        str = table.remove(str_list, 1)
        for _, s in ipairs(str_list) do
            str = ('%s%s%s'):format(str, sep, s)
        end
    end
    return str
end

-- string interpolation
-- usage: CF.string_interp('Hello {x}', { x = 'world' })
CF.string_interp = function(str, vars)
    vim.validate('str', str, 'string')
    vim.validate('vars', vars, 'table')

    return string.gsub(str, '({([^}]+)})',
        function(whole, i)
            return vars[i] or whole
        end
    )
end

CF.format_num = function(n)
    local _, _, minus, int_str, fraction = tostring(n):find('([-]?)(%d+)([.]?%d*)')

    -- reverse the int-string and append a comma to all blocks of 3 digits
    int_str = int_str:reverse():gsub('(%d%d%d)', '%1,')

    -- reverse the int-string back
    -- remove an optional comma
    -- put the optional minus and fractional part back
    return minus .. int_str:reverse():gsub('^,', '') .. fraction
end

-- util/misc -------------------------------------------------------------------
CF.get_visual_selection_text() = function()
    local _, srow, scol = unpack(vim.fn.getpos('v'))
    local _, erow, ecol = unpack(vim.fn.getpos('.'))
    local mode = vim.fn.mode()

    -- visual line mode
    if mode == 'V' then
        if srow > erow then
            return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
        else
            return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
        end
    end

    -- regular visual mode
    if mode == 'v' then
        if srow < erow or (srow == erow and scol <= ecol) then
            return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
        else
            return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
        end
    end

    -- visual block mode
    if mode == '\22' then
        local lines = {}
        if srow > erow then
            srow, erow = erow, srow
        end
        if scol > ecol then
            scol, ecol = ecol, scol
        end
        for i = srow, erow do
            local i_minus_1 = i - 1
            local scol_minus_1 = scol - 1
            lines:insert(
                vim.api.nvim_buf_get_text(0, i_minus_1, math.min(scol_minus_1, ecol), i_minus_1, math.max(scol_minus_1, ecol), {})[1]
            )
        end
        return lines
    end
end

CF.current_line_empty = function()
    local current_line = vim.api.nvim_get_current_line()
    -- %g represents all printable characters except whitespace (not in Lua 5.1, but LuaJit added it)
    return #current_line == 0 or current_line:match('%g') == nil
end

-- testing ---------------------------------------------------------------------
CF.format_time_ns = function(time_ns)
    vim.validate('time_ns', time_ns, 'number')

    if time_ns >= 1e12 then
        local secs_str = CF.format_num(('%.3f'):format(time_ns / 1e9))
        return ('%s secs'):format(secs_str)
    elseif time_ns >= 1e9 then
        return ('%.3f secs'):format(time_ns / 1e9)
    elseif time_ns >= 1e6 then
        return ('%.3f ms'):format(time_ns / 1e6)
    elseif time_ns >= 1e3 then
        return ('%.3f μs'):format(time_ns / 1e3)
    else
        return ('%d ns'):format(time_ns)
    end
end

CF.benchmark = function(n_iters, func, ...)
    vim.validate('n_iters', n_iters, 'number')
    vim.validate('func', func, 'function')

    -- warmup, do 10% of bench iters
    for _ = 1, math.max(math.floor(n_iters / 10 + 0.5), 1) do
        func(...)
    end

    local before = uv.hrtime()
    for _ = 1, n_iters do
        func(...)
    end
    local after = uv.hrtime()
    local elapsed_ns = after - before

    local result_str = 'Benchmark results:\n  - %s function calls\n  - %s elapsed\n  - avg execution time'
    vim.print(result_str:format(
        CF.format_num(n_iters),
        CF.format_time_ns(elapsed_ns),
        CF.format_time_ns(elapsed_ns / n_iters)
    ))
end

vim.custom_fn = CF
