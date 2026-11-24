return {
    'roobert/surround-ui.nvim',
    lazy = true,
    dependencies = {
        'kylechui/nvim-surround',
        'folke/which-key.nvim',
    },
    event = { 'LazyFileOpen', 'BufNewFile' },
    opts = {
        root_key = 'S'
    }
}
