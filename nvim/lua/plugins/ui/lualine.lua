local function get_buf_count()
    -- local listed_bufs = vim.fn.getbufinfo({'buflisted'})
    -- local loaded_bufs = vim.fn.getbufinfo( 'bufloaded' )

    local listed_bufs = vim.api.nvim_list_bufs()
    local buf_count = 0
    local oil_count = 0

    -- vim.notify(dump(listed_bufs))
    for i = 1, #listed_bufs do
        local buf = listed_bufs[i]
        local buf_name = vim.api.nvim_buf_get_name(buf)
        -- vim.notify('buf_name: ' .. buf_name)
        -- vim.notify('is loaded: ' .. tostring(vim.api.nvim_buf_is_loaded(v)))

        if (buf_name == nil or #buf_name == 0) then
            if vim.api.nvim_buf_is_loaded(buf) then
                vim.cmd('bd ' .. buf)
            end
        elseif string.sub(buf_name, 1, 4) == 'oil:' then
            -- print(buf_name)
            oil_count = oil_count + 1
        else
            buf_count = buf_count + 1
        end
    end

    -- result = 'Buffers: ' .. buf_count
    local result = ''
    if buf_count == 0 and oil_count > 0 then
        result = 'Oil Buffers: ' .. oil_count
    elseif buf_count > 0 and oil_count == 0 then
        result = 'Buffers: ' .. buf_count
    elseif buf_count > 0 and oil_count > 0 then
        result = 'Oil Buffers: ' .. oil_count .. ' | Buffers: ' .. buf_count
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

return {}
--     'nvim-lualine/lualine.nvim',
--     event = 'VeryLazy',
--     opts = {
--         icons_enabled = false,
--         sections = {
--             lualine_c = { 'filename', 'filesize' },
--             lualine_x = { 'encoding', 'filetype' },
--             lualine_y = { get_buf_count },
--             lualine_z = { 'progress', 'location'},
--         },
--     }
-- }
