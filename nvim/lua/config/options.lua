local opt = vim.opt

opt.tabstop       = 4     -- number of spaces for a tab
opt.softtabstop   = 4     -- number of spaces for a tab when editing
opt.shiftwidth    = 4     -- number of spaces for autoindent
opt.autoindent    = true  -- copy indent from current line when starting a new line
opt.smartindent   = true  -- smart autoindenting when starting a new line
opt.breakindent   = true  -- every wrapped line will continue visually indented
opt.expandtab     = true  -- use spaces instead of tabs
opt.termguicolors = true  -- enable 24-bit color
opt.showtabline   = 2     -- show tabline always

-- linenumbers
opt.number = true
opt.relativenumber = true

-- schedule the setting after `UIEnter` because it can increase startup time
vim.defer_fn(function()
    opt.clipboard = 'unnamedplus'
end, 1000)
-- vim.g.clipboard = {
--     name = 'OSC 52',
--     copy = {
--         ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--         ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--     },
--     paste = {
--         ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--         ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--     }
-- }
opt.undofile    = true     -- enable persistent undo
opt.hlsearch    = true     -- highlight search matches
opt.incsearch   = true     -- show search matches live, as it's typed
opt.inccommand  = 'split'  -- preview substitutions live, as it's typed

-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase  = true

-- sets how neovim will display certain whitespace characters in the editor
-- see `:help 'list'` and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.jumpoptions = 'stack,view'

opt.updatetime = 1000  -- decrease update time
opt.cursorline = true  -- show which line cursor is on
opt.scrolloff  = 10    -- minimum num of screen lines to keep above & below cursor
opt.confirm    = true  -- prompted to save/cancel if you quit without saving

-- vim.g.have_nerd_font = string.find(vim.v.servername, 'localhost:') ~= nil
vim.g.have_nerd_font = true

if vim.fn.executable('rg') == 1 then
    opt.grepprg = 'rg --color=never --no-ignore --hidden --vimgrep --no-heading --smart-case --glob=!.git/ --glob=!.venv/ --glob=!node_modules'
    opt.grepformat = '%f:%l:%c:%m'
end

vim.filetype.add({
    filename = {
        ['.aliases']              = 'sh',
        ['.bashrc_zellij']        = 'sh',
        ['.exports']              = 'sh',
        ['.gitattributes_global'] = '.gitattributes',
        ['.gitconfig_global']     = '.gitconfig',
    }
})
