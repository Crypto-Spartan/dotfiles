return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    priority = 800,
    config = function()
        require('catppuccin').setup({
            transparent_background = false,
        })

        vim.cmd.colorscheme('catppuccin')
    end
}
