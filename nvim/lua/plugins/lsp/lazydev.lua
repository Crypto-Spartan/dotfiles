return {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    -- dependencies = { 'Bilal2453/luvit-meta' },
    opts = {
        library = {
            -- load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { path = 'snacks.nvim',        words = { 'Snacks' } },
        },
    },
}
