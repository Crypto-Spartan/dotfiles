local wk_icons = function()
    if vim.g.have_nerd_font then
        return
    end

    return {
        mappings = false,
        rules = false,
        breadcrumb = '>',
        separator = '>',
        ellipsis = '.',
        keys = {
            Up = '^ ',
            Down = 'v ',
            Left = '< ',
            Right = '> ',
            C = 'C-',
            M = 'M-',
            D = 'D-',
            S = 'S-',
            CR = '<cr>',
            Esc = '<esc>',
            ScrollWheelDown = 'v',
            ScrollWheelUp = '^ ',
            NL = '<nl>',
            BS = '<bs>',
            Space = '<leader>',
            Tab = '>>',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
        }
    }
end

return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which-key)',
            -- mode = {'n', 'v'}
        },
    },
    opts = {
        preset = 'modern',
        icons = wk_icons(),
        spec = {
            {
                '<leader>b',
                group = 'Buffers',
                expand = function()
                    return require('which-key.extras').expand.buf()
                end
            },
            { '<leader>t',  group = 'Toggle' },
            { '<leader>tp', group = 'Toggle Profiler' },
            { '<leader>s',  group = 'Search' },
            { '<leader>f',  group = 'Find' },
            { '<leader>g',  group = 'Git' },
            { '<leader>l',  group = 'LSP' },
            { '<leader>x',  group = 'Trouble (QFL)' },

            { 'gt', desc = 'Goto next Tab' },
            { 'gT', desc = 'Goto previous Tab' },
        },
    },
    init = function()
        vim.opt.timeout = false
        -- vim.o.timeout = true
        -- vim.o.timeoutlen = 300 -- in milliseconds
    end,
}


-- sort = { 'group', 'alphanum', 'local', 'order', 'mod' },
