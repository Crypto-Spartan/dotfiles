local function bind(mode, outer_opts)
    outer_opts = outer_opts or { noremap = true }
    return function(keymap, cmd, opts)
        opts = vim.tbl_extend('force', outer_opts, opts or {})
        vim.keymap.set(mode, keymap, cmd, opts)
    end
end

local nnoremap = bind('n')
-- local xnoremap = bind('x')
-- local inoremap = bind('i')
-- local vnoremap = bind('v')
-- local tnoremap = bind('t')
-- local nmap = bind('n', { noremap = false })


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


--[[ *ESC KEYMAPS* ]]--

-- ctrl+c always == <esc>
vim.keymap.set({'n','i','v','x','o'}, '<C-c>', '<esc>', { desc = '<esc>', remap = true })
vim.keymap.set({'n','i','v','x','o'}, '<C-C>', '<esc>', { desc = '<esc>', remap = true })

-- highlight on search, but clear on pressing <esc> or <C-c> in normal mode
nnoremap('<esc>', vim.cmd.nohlsearch, { desc = 'Remove highlghts from searching' })


--[[ *CTRL KEYMAPS* ]]--

nnoremap('<C-s>', vim.cmd.write, { desc = 'Save the file' })

-- page jumping
-- nnoremap('<C-d>', '<C-d>zz', { desc = 'Jump half-page down, center window on cursor vertically' })
-- nnoremap('<C-u>', '<C-u>zz', { desc = 'Jump half-page up, center window on cursor vertically' })

-- keybinds to make window navigation easier
-- use CTRL+<hjkl> to switch between windows
-- see `:h wincmd` for a list of all window commands
nnoremap('<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
nnoremap('<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
nnoremap('<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
nnoremap('<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })


--[[ *LEADER KEYMAPS* ]]--

-- paste/delete without putting removed text into register
-- xnoremap('<leader>p', [["_dP]], { desc = 'Paste - no cut to clipboard' })
-- xnoremap('<leader>P', [["_dp]], { desc = 'Paste (end of line) - no cut to clipboard' })
vim.keymap.set({'n','v','x'}, '<leader>c', [["_c]], { desc = 'Change - no cut to clipboard' })
vim.keymap.set({'n','v','x'}, '<leader>d', [["_d]], { desc = 'Delete - no cut to clipboard' })

-- newlines without entering insert mode
nnoremap('<leader>o', 'o<esc>', { desc = 'Create newline (below) & stay in Normal Mode' })
nnoremap('<leader>O', 'O<esc>', { desc = 'Create newline (above) & stay in Normal Mode' })

-- From the Vim wiki: https://bit.ly/4eLAARp
-- Search and replace word under the cursor
nnoremap('<Leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]], { desc = 'Search and replace word under cursor in current buffer'})

local function change_nvim_dir_to_current_file()
    local current_file_dir = vim.custom_fn.get_buf_cwd()
    vim.api.nvim_set_current_dir(current_file_dir)
end
nnoremap('<leader>z', change_nvim_dir_to_current_file, { desc = 'Change nvim cwd to current buffer directory' })


--[[ *MISC KEYMAPS* ]]--

-- insert timestamp
vim.keymap.set({'n','i','x'}, '<F5>', function() vim.api.nvim_paste(os.date('%Y-%m-%d %H:%M:%S'), false, -1) end, { desc = 'Insert Timestamp' })

nnoremap('<bs>', '<C-^>', { desc = 'Switch to last buffer' })

-- shift-q will make an operation use the black hole register
nnoremap('Q', '"_')

-- yank whole line without trailing newline character
nnoremap('yY', '^y$', { desc = 'Yank line without newline char' })

-- duplicate a line
nnoremap('yp', 'yyp', { desc = 'duplicate line' })
-- duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', 'yygccp', { desc = 'duplicate line & comment out first line', remap = true })

-- Select recently pasted, yanked, or changed text
nnoremap('gy', "`[v`]", { desc = 'Select recently pasted, yanked, or changed text' })

-- if motion is `10j`, vim.v.count == 10
-- these allow `j` & `k` to work with wordwrapped lines while not messing up motions
nnoremap('j', function() if vim.v.count == 0 then return 'gj' else return 'j' end end, { expr = true, silent = true })
nnoremap('k', function() if vim.v.count == 0 then return 'gk' else return 'k' end end, { expr = true, silent = true })

-- shift-h & shift-l go to beginning & end of line, wordwrap safe
nnoremap('H', 'g^', { silent = true })
nnoremap('L', 'g$', { silent = true })

-- delete character without putting text into register
nnoremap('x', [["_x]], { silent = true })
nnoremap('X', [["_X]], { silent = true })

local function InsertModeWithIndent(key)
    local current_line = vim.api.nvim_get_current_line()
    -- %g represents all printable characters except whitespace (not in Lua 5.1, but LuaJIT added it)
    if string.len(current_line) == 0 or string.match(current_line, '%g') == nil then
        return [["_cc]]
    else
        return key
    end
end
-- Auto indent on empty line with 'a' or 'A'
nnoremap('a', function() return InsertModeWithIndent('a') end, { expr = true })
nnoremap('A', function() return InsertModeWithIndent('A') end, { expr = true })
