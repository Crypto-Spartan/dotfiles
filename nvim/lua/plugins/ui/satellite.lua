return {
    'lewis6991/satellite.nvim',
    lazy = true,
    event = { 'LazyFileOpen', 'BufNewFile' },
    opts = {
        winblend = 50 -- level of transparency, 0-100
    }
}
