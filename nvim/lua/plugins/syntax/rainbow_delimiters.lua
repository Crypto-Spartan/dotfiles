return {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'LazyFileOpen', 'LazyOilPreview', 'LazyTelescopePreview', 'BufNewFile' },
    init = function()
        vim.g.rainbow_delimiters = {
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterBlue',
                'RainbowDelimiterYellow',
                'RainbowDelimiterViolet',
                'RainbowDelimiterGreen',
                'RainbowDelimiterCyan',
                'RainbowDelimiterOrange',
            }
        }
    end,
    config = function()
        -- snacks toggle setup
        vim.schedule(function()
            local rd_pkg = require('rainbow-delimiters')
            rd_pkg.enable(0)
            local toggle_opts = {
                name = 'Rainbow Delimiters',
                get = function()
                    return rd_pkg.is_enabled(0)
                end,
                set = function(_)
                    rd_pkg.toggle(0)
                end
            }
            package.loaded.snacks.toggle.new(toggle_opts):map('<leader>tr')
        end)
    end
}

-- default order:
-- 'RainbowDelimiterRed',
-- 'RainbowDelimiterYellow',
-- 'RainbowDelimiterBlue',
-- 'RainbowDelimiterOrange',
-- 'RainbowDelimiterGreen',
-- 'RainbowDelimiterViolet',
-- 'RainbowDelimiterCyan',
