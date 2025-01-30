vim.g.lazyfileopen_triggered = false

-- local function log_to_sock(str)
--     -- nc listen command is `nc -lkU /tmp/log.sock`
--     vim.fn.system('printf "' .. str .. '\n"' .. ' | nc -NU /tmp/log.sock')
-- end
-- local lines = string.rep(string.rep('=', 200) .. '\n', 3)
--
-- log_to_sock('\n\n')
-- log_to_sock(lines)
-- log_to_sock('\n\n')
--
-- local function event_table_to_string(event, buf, buf_is_listed, match, filetype, buf_name)
--     if filetype == nil or filetype:len() == 0 then
--         filetype = 'none'
--     end
--
--     local result = 'buf: ' .. buf .. '\tis_listed: ' .. tostring(buf_is_listed) .. ' \tfiletype: ' .. filetype .. '\tevent: ' .. event
--     if match:len() > 0 and event ~= match then
--         if event:len() < 9 then
--             result = result .. '\t\t'
--         else
--             result = result .. '\t'
--         end
--         result = result .. 'match: ' .. match
--     end
--
--     if buf_name:len() > 0 then
--         result = result .. '\t\tbuf_name: ' .. buf_name
--     end
--
--     return result
-- end
--
-- local user_events_ignore = {
--     -- 'LazyLoad',
--     'LazyRender',
--     'LazyLog',
--     'LazyPluginLog',
--     -- 'LazyPluginClean',
--     -- 'LazyPluginFetch',
--     -- 'LazyPluginStatus',
--     -- 'LazyPluginCheckout',
--     'GitSignsUpdate',
-- }
--
-- local plugin_filetypes = {
--     'cmp_menu',
--     'wk',
--     'oil',
--     'notify',
--     'snacks_terminal',
--     'diff',
--     'TelescopePrompt',
--     'TelescopeResults',
--     'flash_prompt',
--     'undotree',
--     'lazy',
--     'lazy_backdrop',
-- }

-- must be loaded before require('lazy').setup() since this plugin has to execute some logice before other plugin specs are loaded
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
                if vim.g.lazyfileopen_triggered then
                    return false
                end
                event.group = nil

                if vim.fn.buflisted(event.buf) == 0 then
                    return false
                end

                -- local ft = vim.bo[event.buf].filetype
                local filetype = event.match
                if filetype == 'oil' or filetype == 'notify' or vim.startswith(filetype, 'Telescope') then
                    return false
                end
                filetype = nil
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
