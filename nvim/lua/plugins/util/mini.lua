return {
    'echasnovski/mini.nvim',
    version = false,
    event = 'VimEnter',
    config = function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.cursorword').setup()
        -- require('mini.diff').setup()
        -- require('mini.hipatterns').setup()
        if not vim.g.have_nerd_font then
            require('mini.icons').setup({
                style = 'ascii',
            })
        end

        require('mini.move').setup({
            mappings = {
                -- visual mode, alt+shift+<hl>
                left = '<M-S-h>',
                right = '<M-S-l>',
                -- normal mode, alt+shift+<hl>
                line_left = '<M-S-h>',
                line_right = '<M-S-l>',
            }
        })
        require('mini.statusline').setup({
            use_icons = vim.g.have_nerd_font
        })

        require('mini.trailspace').setup()
    end
}
