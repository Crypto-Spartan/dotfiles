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

    trim_oil_path = function(path)
        if vim.startswith(path, 'oil://') then
            path = string.sub(path, 7)
        end
        return path
    end,

    get_nvim_cwd = function()
        return vim.fn.getcwd()
    end,

    get_buf_cwd = function()
        return vim.fn.expand('%:p:h')
    end,
}
