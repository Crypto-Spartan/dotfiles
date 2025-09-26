return {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 800,
    config = function()
        require('tokyonight').setup({
            style = 'night',

            on_colors = function(c)
                c.green = '#40ff70'
                c.red = '#ff4d6a'
                c.yellow = '#f4ff80'
                c.purple = '#955ce6'
                c.magenta = '#ff73ff'
                c.orange = '#ffae57'
                c.warning = '#ffae57'
                c.blue = '#80aaff'
                c.blue1 = '#00eaff'
                c.cyan = '#00eaff'
                c.teal = '#1dbf97'

                c.comment = '#787fa1'
                c.bg_dark = '#12121a'
                c.bg = '#171826'
            end,

            on_highlights = function(hi, c)
                -- search highlight color
                hi.IncSearch = { fg = c.black, bg = c.yellow }

                -- relative line num colors
                hi.LineNr = { fg = '#84899c' }
                hi.LineNrAbove = { fg = '#84899c' }
                hi.LineNrBelow = { fg = '#84899c' }

                -- cursor line num color
                hi.CursorLineNr = { fg = '#00ff00', bold = true }
                -- cursor line background color
                hi.CursorLine = { bg = '#2e3142' }

                hi.Comment = { fg = c.comment }
                hi.CmpGhostText = { fg = c.comment }
                hi.DiagnosticUnnecessary = { fg = c.comment }

                hi.TelescopePromptBorder = { fg = c.green, bg = c.bg_float }
                hi.TelescopePromptTitle = { fg = c.green, bg = c.bg_float }

                -- hi.SpecialKey = { fg = c.comment }
            end
        })

        vim.cmd.colorscheme('tokyonight-night')
    end
}
