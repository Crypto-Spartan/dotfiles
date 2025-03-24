local function trim_oil_path(path)
    if vim.startswith(path, 'oil://') then
        path = path:sub(7)
    end
    return path
end

vim.custom_fn = {
    string_contains = function(str, sub)
        return str:find(sub, 1, true) ~= nil
    end,

    string_startswith = function(str, start)
        return str:sub(1, #start) == start
    end,

    string_endswith = function(str, ending)
        return ending == '' or str:sub(-#ending) == ending
    end,

    string_replace = function(str, old, new)
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
    end,

    string_insert = function(str, pos, text)
        return str:sub(1, pos - 1) .. text .. str:sub(pos)
    end,

    get_nvim_cwd = function()
        return vim.uv.fs_realpath(trim_oil_path(vim.fn.getcwd()))
    end,

    get_buf_cwd = function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if vim.endswith(buf_name, '/') then
            buf_name = buf_name:sub(1, -2)
        end
        return vim.uv.fs_realpath(trim_oil_path(buf_name))
    end,

    benchmark = function(unit, decPlaces, n, f, ...)
        local units = {
            ['seconds'] = 1,
            ['milliseconds'] = 1000,
            ['microseconds'] = 1000000,
            ['nanoseconds'] = 1000000000
        }

        local elapsed = 0
        local multiplier = units[unit]
        for i = 1, n do
            -- local now = os.clock()
            local before = vim.uv.clock_gettime('realtime')
            f(...)
            local after = vim.uv.clock_gettime('realtime')
            elapsed = (after.sec - before.sec) + ((after.nsec - before.nsec) / 1000000000)
            -- elapsed = elapsed + (os.clock() - now)
        end
        vim.print(string.format('Benchmark results:\n  - %d function calls\n  - %.'.. decPlaces ..'f %s elapsed\n  - %.'.. decPlaces ..'f %s avg execution time.', n, elapsed * multiplier, unit, (elapsed / n) * multiplier, unit))
    end,
}
