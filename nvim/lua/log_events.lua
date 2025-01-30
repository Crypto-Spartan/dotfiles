local all_events = {
    'BufAdd',
    'BufDelete',
    'BufEnter',
    'BufFilePre',
    'BufFilePost',
    'BufHidden',
    'BufLeave',
    -- 'BufModifiedSet',
    'BufNew',
    'BufNewFile',
    'BufRead',
    'BufReadPre',
    'BufReadPost',
    'BufUnload',
    'BufWinEnter',
    'BufWinLeave',
    'BufWipeout',
    -- 'BufWrite',
    -- 'BufWritePre',
    'BufWritePost',
    -- 'CmdlineChanged',
    -- 'CmdlineEnter',
    -- 'CmdlineLeave',
    'CmdwinEnter',
    'CmdwinLeave',
    'ColorschemePre',
    'Colorscheme',
    -- 'CursorHold',
    -- 'CursorHoldI',
    -- 'CursorMoved',
    -- 'CursorMovedC',
    -- 'CursorMovedI',
    'DirChangedPre',
    'DirChanged',
    'ExitPre',
    'FileAppendPre',
    'FileAppendPost',
    'FileChangedShell',
    'FileChangedShellPost',
    'FileReadPre',
    'FileReadPost',
    'FileType',
    'FileWritePre',
    'FileWritePost',
    'FilterReadPre',
    'FilterReadPost',
    'FilterWritePre',
    'FilterWritePost',
    -- 'FocusGained',
    -- 'FocusLost',
    'UIEnter',
    'UILeave',
    -- 'InsertChange',
    -- 'InsertCharPre',
    -- 'InsertEnter',
    -- 'InsertLeavePre',
    -- 'InsertLeave',
    'MenuPopup',
    -- 'ModeChanged',
    -- 'OptionSet',
    'QuickFixCmdPre',
    'QuickFixCmdPost',
    'QuitPre',
    -- 'SafeState',
    'SessionLoadPost',
    'SessionWritePost',
    'ShellCmdPost',
    'Signal',
    'ShellFilterPost',
    -- 'SourcePre',
    -- 'SourcePost',
    'StdinReadPre',
    'StdinReadPost',
    'SwapExists',
    -- 'Syntax',
    'TabEnter',
    'TabLeave',
    'TabNew',
    'TabNewEntered',
    'TabClosed',
    'TermOpen',
    'TermEnter',
    'TermLeave',
    'TermClose',
    -- 'TermRequest',
    'TermResponse',
    -- 'TextChanged',
    -- 'TextChangedI',
    -- 'TextChangedP',
    -- 'TextChangedT',
    -- 'TextYankPost',
    'User',
    'VimEnter',
    'VimLeave',
    'VimLeavePre',
    'VimResized',
    'VimResume',
    'VimSuspend',
    'WinNew',
    'WinClosed',
    'WinEnter',
    'WinLeave',
    -- 'WinScrolled',
    -- 'WinResized',
}

local function log_to_sock(str)
    -- nc listen command is `nc -lkU /tmp/log.sock`
    vim.fn.system('printf "' .. str .. '\n"' .. ' | nc -NU /tmp/log.sock')
end

local lines = string.rep(string.rep('=', 200) .. '\n', 3)

log_to_sock('\n\n')
log_to_sock(lines)
log_to_sock('\n\n')

local user_events_ignore = {
    -- 'LazyLoad',
    'LazyRender',
    'LazyLog',
    'LazyPluginLog',
    -- 'LazyPluginClean',
    -- 'LazyPluginFetch',
    -- 'LazyPluginStatus',
    -- 'LazyPluginCheckout',
    'GitSignsUpdate',
}

local function event_table_to_string(event, buf, buf_is_listed, match, filetype, buf_name)
    if filetype == nil or filetype:len() == 0 then
        filetype = 'none'
    end

    local result = 'buf: ' .. buf .. '\tis_listed: ' .. tostring(buf_is_listed) .. ' \tfiletype: ' .. filetype .. '\tevent: ' .. event
    if match:len() > 0 and event ~= match then
        if event:len() < 9 then
            result = result .. '\t\t'
        else
            result = result .. '\t'
        end
        result = result .. 'match: ' .. match
    end

    if buf_name:len() > 0 then
        result = result .. '\t\tbuf_name: ' .. buf_name
    end

    return result
end


local plugin_filetypes = {
    'cmp_menu',
    'wk',
    'oil',
    'notify',
    'snacks_terminal',
    'diff',
    'TelescopePrompt',
    'TelescopeResults',
    'flash_prompt',
    'undotree',
    'lazy',
    'lazy_backdrop',
}


-- local oil_loaded = false
vim.api.nvim_create_autocmd(all_events, {
    group = vim.api.nvim_create_augroup('event_logging', { clear = true }),
    desc = 'Log all events that can trigger an autocmd',
    callback = function(event_table)
        local now = vim.uv.clock_gettime('realtime')
        local event

        if event_table.event == 'User' then
            -- if event_table.file == 'LazyLoad' then
            --     if oil_loaded then
            --         return
            --     elseif event_table.data == 'oil.nvim' then
            --         oil_loaded = true
            --     end
            if vim.startswith(event_table.file, 'Telescope') then
                return
            else
                for _, v in pairs(user_events_ignore) do
                    if v == event_table.file then
                        return
                    end
                end
            end

            event = event_table.match
        else
            event = event_table.event
        end

        event_table.id = nil
        event_table.group = nil

        local buf_id = event_table.buf
        local buf_is_listed = vim.fn.buflisted(buf_id) == 1
        local ft = vim.bo[buf_id].filetype

        if ft == 'notify' or ft == 'wk' then
            return
        end

        -- if vim.startswith(ft, 'Telescope') then
        if true then
            local buf_name = vim.api.nvim_buf_get_name(buf_id)
            local e = event_table_to_string(event, buf_id, buf_is_listed, event_table.match, ft, buf_name)

            local millis = string.sub(now.nsec, 1, 3)
            local ts_str = os.date('!%F %T', now.sec) .. '.' .. millis .. 'Z'
            log_to_sock(ts_str .. ' - ' .. e)

            -- for _, v in pairs(plugin_filetypes) do
            --     if v == ft then
            --         return
            --     end
            -- end

            log_to_sock(vim.inspect(event_table))
        end

    end,
})
