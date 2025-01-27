return {
    'stevearc/aerial.nvim',
    lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
        { '<leader>a', '<cmd>AerialToggle<CR>', desc = 'aerial.nvim' },
    },
    opts = {
        default_direction = 'left'
    },
}
