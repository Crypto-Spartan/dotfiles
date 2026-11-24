return {
    'kylechui/nvim-surround',
    version = '*', -- use for stability; omit to use `main` branch for latest features
    dependencies = { 'roobert/surround-ui.nvim' },
    event = { 'LazyFileOpen', 'BufNewFile' },
    opts = {},
}
