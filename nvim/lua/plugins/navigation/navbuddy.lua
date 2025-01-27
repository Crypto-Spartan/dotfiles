return {
    'SmiteshP/nvim-navbuddy',
    lazy = true,
    dependencies = {
        'SmiteshP/nvim-navic',
        'MunifTanjim/nui.nvim'
    },
    keys = {
        {
            '<leader>n',
            function()
                package.loaded['nvim-navbuddy'].open()
            end,
            desc = 'Navbuddy'
        },
    },
    opts = {
        lsp = { auto_attach = true },
        window = { size = '70%' },
    },
}
