return {
    'navarasu/onedark.nvim',
    lazy = true,
    priority = 800,
    config = function()
        require('onedark').setup({
            style = 'deep'
        })

        vim.cmd.colorscheme('onedark')
    end
}
