local custom_fn = vim.custom_fn

local function bind(mode, outer_opts)
    outer_opts = outer_opts or { noremap = true }
    return function(keymap, cmd, opts)
        opts = vim.tbl_extend('force', outer_opts, opts or {})
        vim.keymap.set(mode, keymap, cmd, opts)
    end
end

local nnoremap = bind('n')
local vnoremap = bind('v')
local inoremap = bind('i')
-- local tnoremap = bind('t')
-- local nmap = bind('n', { noremap = false })


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


--[[ *ESC KEYMAPS* ]]--

-- ctrl+c always == <esc>
vim.keymap.set({'n','i','v','o'}, '<C-c>', '<esc>', { desc = '<esc>', remap = true })
vim.keymap.set({'n','i','v','o'}, '<C-C>', '<esc>', { desc = '<esc>', remap = true })

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
vim.keymap.set({'n','v','x'}, '<leader>c', [["_c]], { desc = 'Change - text to blackhole' })
vim.keymap.set({'n','v','x'}, '<leader>d', [["_d]], { desc = 'Delete - text to blackhole' })
nnoremap('<leader>C', [["_C]], { desc = 'Change (rest of line) - text to blackhole' })
nnoremap('<leader>D', [["_D]], { desc = 'Delete (rest of line) - text to blackhole' })

-- newlines without entering insert mode
nnoremap('<leader>o', 'o<esc>', { desc = 'Create newline (below) & stay in Normal Mode' })
nnoremap('<leader>O', 'O<esc>', { desc = 'Create newline (above) & stay in Normal Mode' })

local esc_key = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
-- add print debugging for word under cursor
local function get_paste_str(cword)
    local filetype = vim.bo.filetype
    local paste_str
    if filetype == 'lua' then
        paste_str = "print('"..cword..": '..vim.inspect("..cword.."))"
    elseif filetype == 'python' then
        cword = custom_fn.string_replace(cword, [[']], [["]])
        paste_str = "print(f'{"..cword.." = }')"
    elseif filetype == 'rust' then
        paste_str = "dbg!(&"..cword..");"
    end
    return paste_str
end
-- add print debugging for word under cursor
local function paste_print_debug_normal()
    local cword = vim.fn.expand('<cword>')
    local paste_str = get_paste_str(cword)
    if paste_str == nil then
        return
    end
    vim.api.nvim_feedkeys('o'..paste_str..esc_key, 'n', false)
end
nnoremap('<leader>pd', paste_print_debug_normal, { desc = 'Paste Print Debug of word under cursor' })

local function paste_print_debug_visual()
    local selection = custom_fn.get_visual_selection_text()[1]
    local paste_str = get_paste_str(selection)
    if paste_str == nil then
        return
    end
    vim.api.nvim_feedkeys(esc_key..'o'..paste_str..esc_key, 'n', false)
end
vnoremap('<leader>pd', paste_print_debug_visual, { desc = 'Paste Print Debug of visual selection' })

nnoremap('<leader>po', [[o<C-r>"<esc>]], { desc = 'Paste on newline with correct indentation' })
nnoremap('<leader>pO', [[O<C-r>"<esc>]], { desc = 'Paste on line above with correct indentation' })

-- from the vim wiki: https://vim.fandom.com/wiki/Search_and_replace_the_word_under_the_cursor
-- search & replace word under cursor (similar to LSP rename but without LSP)
nnoremap('<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]], { desc = 'Search & Replace word under cursor in current buffer' })
local left_key = vim.api.nvim_replace_termcodes('<left>', true, false, true)
local function vmode_search_and_replace()
    local selection = custom_fn.get_visual_selection_text()[1]
    local cmd = esc_key..':%s/'..selection..'/'..selection..'/g'..left_key:rep(2)
    vim.api.nvim_feedkeys(cmd, 'n', false)
end
vnoremap('<leader>r', vmode_search_and_replace, { desc = 'Search & Replace visual selection in current buffer' })

local function change_nvim_dir_to_current_file()
    local current_file_dir = custom_fn.get_buf_cwd()
    vim.api.nvim_set_current_dir(current_file_dir)
end
nnoremap('<leader>z', change_nvim_dir_to_current_file, { desc = 'Change nvim cwd to current buffer directory' })


--[[ *ALT KEYMAPS* ]]--

inoremap('<M-o>', '<esc>o<esc>a', { desc = 'Add line below, return to insert mode' })
inoremap('<M-O>', '<esc>O<esc>a', { desc = 'Add line above, return to insert mode' })


--[[ *MISC KEYMAPS* ]]--

nnoremap('<bs>', '<C-^>', { desc = 'Switch to last buffer' })

-- yank whole line without trailing newline character
nnoremap('yY', '^y$', { desc = 'Yank line without newline char' })

-- duplicate a line
nnoremap('yp', 'yyp', { desc = 'duplicate line' })
-- duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', 'yygccp', { desc = 'duplicate line & comment out first line', remap = true })

-- select recently pasted, yanked, or changed text
nnoremap('gy', "`[v`]", { desc = 'Select recently pasted, yanked, or changed text' })

local function insert_timestamp()
    local timestamp_str = ('%s UTC -- '):format(os.date('!%Y-%m-%d %H:%M:%S'))
    vim.api.nvim_put({timestamp_str}, 'c', true, true)
end
vim.keymap.set({'n','i','v','x'}, '<F5>', insert_timestamp, { desc = 'Insert Timestamp', nowait = true })

-- if motion is `10j`, vim.v.count == 10
-- these allow `j` & `k` to work with wordwrapped lines while not messing up motions
local function make_jk_map_func(key)
    vim.validate('key', key, 'string')
    local g_key = 'g'..key
    local g_key_cmd_single = vim.api.nvim_parse_cmd('normal! '..g_key, {})
    g_key_cmd_single.addr    = nil
    g_key_cmd_single.nargs   = nil
    g_key_cmd_single.nextcmd = nil
    local key_cmd_multiple = vim.deepcopy(g_key_cmd_single)
    
    local map_jk = function()
        local count = vim.v.count
        if count == 0 then
            vim.api.nvim_cmd(g_key_cmd_single --[[@as vim.api.keyset.cmd]], { output = false })
        else
            key_cmd_multiple.args[1] = tostring(count)..key
            vim.api.nvim_cmd(key_cmd_multiple --[[@as vim.api.keyset.cmd]], { output = false })
        end
    end
    return map_jk
end
nnoremap('j', make_jk_map_func('j'), { nowait = true })
nnoremap('k', make_jk_map_func('k'), { nowait = true })

-- shift-h & shift-l go to beginning & end of line, wordwrap safe
nnoremap('H', 'g^', { nowait = true })
nnoremap('L', 'g$', { nowait = true })

-- delete character without putting text into register
nnoremap('x', [["_x]], { nowait = true })
nnoremap('X', [["_X]], { nowait = true })

local function make_change_blankline_key_func(blackhole_key, key)
    local map_key = function()
        if custom_fn.current_line_empty() then
            vim.api.nvim_feedkeys(blackhole_key, 'n', false)
        else
            vim.api.nvim_feedkeys(key, 'n', false)
        end
    end
    return map_key
end

local cc_blackhole_key = vim.api.nvim_replace_termcodes([["_cc]], true, false, true)
local dd_blackhole_key = vim.api.nvim_replace_termcodes([["_dd]], true, false, true)
-- auto indent on empty line with `a` or `A`
nnoremap('a',  make_change_blankline_key_func(cc_blackhole_key, 'a'),  { nowait = true })
nnoremap('A',  make_change_blankline_key_func(cc_blackhole_key, 'A'),  { nowait = true })
-- delete line to black hole register if it's blank
nnoremap('dd', make_change_blankline_key_func(dd_blackhole_key, 'dd'), { nowait = true })

-- automatically add semicolon or comma at the end of the line in insert mode
inoremap(';;', '<esc>A;')
inoremap(',,', '<esc>A,')

-- block insert in visual line mode
local caret_ctrl_v_key = vim.api.nvim_replace_termcodes('^<c-v>', true, false, true)
local function visual_line_mode_block_insert()
    if vim.fn.mode() == 'V' then
        vim.api.nvim_feedkeys(caret_ctrl_v_key, 'n', false)
    end
    vim.api.nvim_feedkeys('I', 'n', false)
end
vnoremap('I', visual_line_mode_block_insert, { desc = 'Block Insert (from Visual Line Mode)' })
