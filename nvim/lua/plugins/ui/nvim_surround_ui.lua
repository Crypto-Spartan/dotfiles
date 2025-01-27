return {
    'roobert/surround-ui.nvim',
    lazy = true,
    dependencies = {
        'kylechui/nvim-surround',
        'folke/which-key.nvim',
    },
    event = { 'LazyFileOpen', 'BufNewFile' },
    -- config = function()
    --     require('surround-ui').setup({
    --         root_key = 'S'
    --     })
    -- end,
    opts = {
        root_key = 'S',
    }
}
