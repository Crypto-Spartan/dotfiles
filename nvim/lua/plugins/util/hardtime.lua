return {
    'm4xshen/hardtime.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim'
    },
    event = { 'LazyFileOpen', 'BufNewFile' },
    opts = {
        max_count = 3,
        restriction_mode = 'hint',
        -- removes hjkl from restricted_keys
        restricted_keys = {
            ['h'] = {},
            ['j'] = {},
            ['k'] = {},
            ['l'] = {},
        },
        -- removes Up, Down, Left, Right from disabled_keys
        disabled_keys = {
            ['<Up>']    = {},
            ['<Down>']  = {},
            ['<Left>']  = {},
            ['<Right>'] = {},
        },
    },
}
