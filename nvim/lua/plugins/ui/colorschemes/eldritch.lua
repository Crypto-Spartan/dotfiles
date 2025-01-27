return {
    'eldritch-theme/eldritch.nvim',
    lazy = false,
    priority = 800,
    config = function()
        require('eldritch').setup({
            transparent = false,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
            },
            on_colors = function(c)
                c.comment = '#787fa1'
                c.bg_dark = '#12121a'
                c.bg = '#171826'
            end,
        })

        vim.cmd.colorscheme('eldritch')
    end,
}
