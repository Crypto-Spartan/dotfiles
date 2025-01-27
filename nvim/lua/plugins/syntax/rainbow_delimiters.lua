return {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'LazyFileOpen', 'LazyOilPreview', 'BufNewFile' },
    main = 'rainbow-delimiters.setup',
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
    opts = function()
        return { highlight = vim.g.rainbow_delimiters.highlight }
    end,
}

-- default order:
-- 'RainbowDelimiterRed',
-- 'RainbowDelimiterYellow',
-- 'RainbowDelimiterBlue',
-- 'RainbowDelimiterOrange',
-- 'RainbowDelimiterGreen',
-- 'RainbowDelimiterViolet',
-- 'RainbowDelimiterCyan',
