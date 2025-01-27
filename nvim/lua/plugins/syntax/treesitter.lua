return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'LazyOilPreview', 'LazyFileOpen', 'BufNewFile' },
    opts = {
        ensure_installed = {
            'bash', 'diff', 'go', 'html',
            'javascript', 'json', 'kdl', 'lua', 'luadoc', 'markdown', 'markdown_inline',
            'python', 'query', 'regex', 'sql', 'toml', 'vim', 'vimdoc', 'xml',
            'yaml'
        },
        -- auto install missing parsers when entering buffer
        auto_install = true,
        highlight = {
            enable = true,
            -- some languages depend on vim's regex highlighting system (e.g. ruby) for indent rules
            -- if you are experiencing weird indenting issues, add the language to the list of
            --     additional_vim_regex_highlighting and disabled languages for indent
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby', 'lua' } },
    },
    config = function(_, opts)
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

        -- Prefer git instead of curl in order to improve connectivity in some environments
        require('nvim-treesitter.install').prefer_git = true
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup(opts)

        vim.treesitter.language.register('python', { 'scube' })
        vim.treesitter.language.register('c', { 'h' })

        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
}
