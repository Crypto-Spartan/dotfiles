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
        vim.bo.fileformat = 'unix'
    end
})

-- autoreload files when modified externally
vim.o.autoread = true
local autoreload_files_augroup = vim.api.nvim_create_augroup('AutoreloadFiles', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained', 'FocusLost' }, {
    group = autoreload_files_augroup,
    desc = 'autoreload files when modified externally',
    command = "if mode() != 'c' | checktime | endif",
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
    pattern = { '*.scm' },
    desc = 'Reload TS Queries after saving a *.scm file',
    callback = function()
        require('nvim-treesitter.query').invalidate_query_cache()
        local ts_context = require('treesitter-context')
        ts_context.disable()
        ts_context.enable()
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

-- replace `h` with `tabh h` in command mode
vim.cmd[[ cabbrev h tab h ]]
