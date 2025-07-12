vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- enable 24-bit color
vim.opt.termguicolors = true

-- linenumbers
vim.opt.number = true
vim.opt.relativenumber = true

-- schedule the setting after `UiEnter` because it can increase startup time
vim.defer_fn(function()
    vim.opt.clipboard = 'unnamedplus'
end, 1000)
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- sets how neovim will display certain whitespace characters in the editor
--  see `:help 'list'` and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.jumpoptions = 'stack,view'

-- decrease update time
vim.opt.updatetime = 1000
-- show which line cursor is on
vim.opt.cursorline = true
-- minimum num of screen lines to keep above & below cursor
vim.opt.scrolloff = 10

-- ask to save files if taking an operation that would fail due to unsaved changes in the buffer
vim.opt.confirm = true

-- vim.g.have_nerd_font = string.find(vim.v.servername, 'localhost:') ~= nil
vim.g.have_nerd_font = true

if vim.fn.executable('rg') == 1 then
    vim.opt.grepprg = 'rg -u --hidden --glob "!.git" --vimgrep --no-heading --smart-case'
    vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.filetype.add({
    filename = {
        ['.bashrc_zellij']        = 'sh',
        ['.gitattributes_global'] = '.gitattributes',
        ['.gitconfig_global']     = '.gitconfig',
    }
})
