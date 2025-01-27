return {
    'NeogitOrg/neogit',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'sindrets/diffview.nvim',
        'nvim-telescope/telescope.nvim',
    },
    lazy = true,
    cmd = 'Neogit',
    keys = {
        {
            '<leader>gn',
            function()
                package.loaded.neogit.open()
            end,
            desc = 'Neogit'
        },
    },
    opts = {},
}
