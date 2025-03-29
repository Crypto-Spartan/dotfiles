return {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'LazyFileOpen', 'BufNewFile' },
    ft = { 'scm' },
    opts = {
        max_lines = 12,
        multiline_threshold = 3,
        trim_scope = 'outer'
    },
    config = function(_, opts)
        local pkg_tscontext = require('treesitter-context')
        pkg_tscontext.setup(opts)

        -- snacks toggle setup
        vim.schedule(function()
            local toggle_opts = {
                name = 'Treesitter Context',
                get = pkg_tscontext.enabled,
                set = pkg_tscontext.toggle,
            }
            package.loaded.snacks.toggle.new(toggle_opts):map('<leader>tc')
        end)
    end
}
