return {
    'lukas-reineke/indent-blankline.nvim',
    -- cond = vim.g.have_nerd_font,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'HiPhish/rainbow-delimiters.nvim',
    },
    event = { 'LazyFileOpen', 'BufNewFile' },
    main = 'ibl',
    config = function()
        local hooks = require('ibl.hooks')

        -- create the highlight groups in the highlight setup hook
        -- this ensures they are reset if the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, 'RainbowRed',    { link = 'RainbowDelimiterRed' })
            vim.api.nvim_set_hl(0, 'RainbowViolet', { link = 'RainbowDelimiterViolet' })
            vim.api.nvim_set_hl(0, 'RainbowGreen',  { link = 'RainbowDelimiterGreen' })
            vim.api.nvim_set_hl(0, 'RainbowBlue',   { link = 'RainbowDelimiterBlue' })
            vim.api.nvim_set_hl(0, 'RainbowYellow', { link = 'RainbowDelimiterYellow' })
            vim.api.nvim_set_hl(0, 'RainbowCyan',   { link = 'RainbowDelimiterCyan' })
            vim.api.nvim_set_hl(0, 'RainbowOrange', { link = 'RainbowDelimiterOrange' })
        end)

        local ibl_pkg = require('ibl')
        ibl_pkg.setup({
            scope = {
                highlight = vim.g.rainbow_delimiters.highlight, -- defined in rainbow_delims.lua
                include = {
                    node_type = {
                        python = { 'argument_list', 'with_statement', 'parenthesized_expression' },
                        lua = { 'return_statement', 'table_constructor' }
                    }
                }
            }
        })
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

        -- snacks toggle setup
        vim.schedule(function()
            local ibl_snacks_enabled = ibl_pkg.initialized
            local toggle_opts = {
                name = 'Indent Blankline',
                get = function()
                    return ibl_snacks_enabled
                end,
                set = function(state)
                    if state then
                        ibl_snacks_enabled = true
                        ibl_pkg.update({ enabled = true })
                    else
                        ibl_snacks_enabled = false
                        ibl_pkg.update({ enabled = false })
                    end
                end,
            }
            package.loaded.snacks.toggle.new(toggle_opts):map('<leader>ti')
        end)
    end
}
