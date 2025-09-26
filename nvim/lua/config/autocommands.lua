-- highlight when yanking text
-- see `:h vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    desc = 'Highlight when yanking (copying) text',
    callback = function()
        vim.highlight.on_yank({
            timeout=400,
            priority=300
        })
    end
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePre' }, {
    group = vim.api.nvim_create_augroup('SetFileformat', { clear = true }),
    desc = 'Always set fileformat to unix',
    callback = function()
        if vim.bo.modifiable then
            vim.bo.fileformat = 'unix'
        end
    end
})

local parsed_formatoptions = vim.api.nvim_parse_cmd('set formatoptions-=cro', {})
local parsed_formatoptions_local = vim.api.nvim_parse_cmd('setlocal formatoptions-=cro', {})
parsed_formatoptions.addr, parsed_formatoptions.nargs, parsed_formatoptions.nextcmd = nil, nil, nil
parsed_formatoptions_local.addr, parsed_formatoptions_local.nargs, parsed_formatoptions_local.nextcmd = nil, nil, nil
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('SetFormatOptions', { clear = true }),
    desc = 'Always set Format Options explicitly',
    callback = function()
        vim.api.nvim_cmd(parsed_formatoptions --[[@as vim.api.keyset.cmd]], {})
        vim.api.nvim_cmd(parsed_formatoptions_local --[[@as vim.api.keyset.cmd]], {})
    end
})

-- autoreload files when modified externally
vim.opt.autoread = true
local parsed_checktime = vim.api.nvim_parse_cmd('checktime', {})
parsed_checktime.addr, parsed_checktime.nargs, parsed_checktime.nextcmd = nil, nil, nil
local autoreload_files_augroup = vim.api.nvim_create_augroup('AutoreloadFiles', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained', 'FocusLost' }, {
    group = autoreload_files_augroup,
    desc = 'autoreload files when modified externally',
    callback = function(event)
        if event.file == '' then
            return
        end
        event = nil

        local mode_obj = vim.api.nvim_get_mode()
        if mode_obj.blocking or mode_obj.mode == 'c' then
            return
        end

        vim.api.nvim_cmd(parsed_checktime --[[@as vim.api.keyset.cmd]], {})
        -- local status, err = pcall(vim.api.nvim_cmd, parsed_checktime, {})
    end,
})
-- create notification if a buffer has been updated
vim.api.nvim_create_autocmd('FileChangedShellPost', {
    group = autoreload_files_augroup,
    desc = 'create notification if a buffer has been updated',
    callback = function()
        vim.notify('File changed; buffer updated', nil, { title = 'FileChangedShellPost' })
    end
})

-- reload treesitter queries after saving query file
vim.api.nvim_create_autocmd('BufWrite', {
    group = vim.api.nvim_create_augroup('TSReset', { clear = true }),
    pattern = '*.scm',
    desc = 'Reload TS Queries after saving a *.scm file',
    callback = function()
        require('nvim-treesitter.query').invalidate_query_cache()
        local ts_context = require('treesitter-context')
        ts_context.disable()
        ts_context.enable()
    end
})

-- reload plugin on save
vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('LuaReloadModule', { clear = true }),
    pattern = '*.lua',
    desc = 'Reload module after saving *.lua file',
    callback = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, 3, false)
        -- vim.print(lines)
        for _, line in ipairs(lines) do
            if line and line:match('^local%s+M%s*=%s*{}') then
                local filepath = vim.fn.expand('%:p')
                local module_name = vim.fn.fnamemodify(filepath, ':.:r')
                package.loaded[module_name] = nil
                pcall(require, module_name)

                vim.notify('Module reloaded: '..module_name, nil, {
                    title = 'Notification',
                    timeout = 300,
                    render = 'compact',
                })
                return
            end
        end
    end
})

-- add line numbers when in neovim help docs
-- see `:help nvim_create_autocmd()`
vim.api.nvim_create_autocmd('FileType', {
    desc = 'Add line numbers in neovim docs/help files',
    group = vim.api.nvim_create_augroup('DocsLineNums', { clear = true }),
    pattern = { 'help' },
    callback = function()
        vim.opt.number = true
        vim.opt.relativenumber = true
    end
})

-- replace `h` with `tab h` in command mode
vim.cmd.cabbrev('h tab h')
vim.cmd.cabbrev('help tab h')
