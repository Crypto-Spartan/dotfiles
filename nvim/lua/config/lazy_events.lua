vim.g.lazyfileopen_triggered = false
vim.g.lazytelescopepreview = false

-- must be loaded before require('lazy').setup() since this plugin has to execute some logic before other plugin specs are loaded
vim.g.lazy_events_config = {
    simple = {
        LazyFile = { 'BufReadPost', 'BufNewFile' },
    },
    custom = {
        StartWithDir = {
            event = 'VimEnter',
            once = true,
            cond = function()
                local arg = vim.fn.argv(0)
                ---@cast arg string
                if arg == '' then
                    return false
                end

                local stats = vim.uv.fs_stat(arg)
                return (stats and stats.type == 'directory') or false
            end
        },
        LazyFileOpen = {
            event = 'FileType',
            cond = function(event)
                if vim.g.lazyfileopen_triggered or vim.fn.buflisted(event.buf) == 0 then
                    return false
                end

                -- local ft = vim.bo[event.buf].filetype
                local filetype = event.match
                if filetype == 'oil' or filetype == 'notify' or vim.startswith(filetype, 'Telescope') then
                    return false
                end
                filetype = nil
                event.group = nil
                event.match = nil

                local f_stat = vim.uv.fs_stat(event.file)
                if f_stat == nil or f_stat.type ~= 'file' then
                    return false
                end
                f_stat = nil

                if vim.uv.fs_access(event.file, '') then
                    vim.g.lazyfileopen_triggered = true
                    vim.schedule(function()
                        vim.api.nvim_del_autocmd(event.id)
                        vim.g.lazyfileopen_triggered = nil
                    end)
                    return true
                else
                    return false
                end
            end
        },
        LazyTelescopePreview = {
            event = 'FileType',
            cond = function(event)
                -- if vim.g.lazyfileopen_triggered or vim.fn.buflisted(event.buf) == 0 then
                if vim.g.lazytelescopepreview then
                    return false
                end

                local filetype = event.match
                if vim.startswith(filetype, 'Telescope') then
                    vim.g.lazytelescopepreview = true
                    vim.schedule(function()
                        vim.api.nvim_del_autocmd(event.id)
                        vim.g.lazytelescopepreview = nil
                    end)
                    return true
                else
                    return false
                end
            end
        },
        LazyFileInsert = {
            event = { 'InsertEnter', 'InsertChange' },
            cond = function(event)
                event.group = nil
                event.file = nil
                event.match = nil

                local buf_id = event.buf
                if vim.fn.buflisted(buf_id) == 0 then
                    return false
                end

                local ft = vim.bo[buf_id].filetype
                if ft == 'TelescopePrompt' or ft == 'DressingInput' then
                    return false
                elseif ft == 'oil' then
                    vim.api.nvim_exec_autocmds('User', {
                        pattern = 'UserLazyOilInsert',
                        modeline = false,
                    })
                    return false
                end
                buf_id = nil
                event.buf = nil

                vim.schedule(function()
                    vim.api.nvim_del_autocmd(event.id)
                end)
                return true
            end
        },
        LazyOilInsert = {
            event = 'User',
            pattern = 'UserLazyOilInsert',
            once = true,
            cond = function()
                return true
            end
        },
        LazyOilPreview = {
            event = 'User',
            pattern = 'UserLazyOilPreview',
            once = true,
            cond = function()
                return true
            end,
        },
    },
}
