local function treesitter_try_attach(buf, lang)
    -- check if a parser exists and load it
    if not vim.treesitter.language.add(lang) then return end
    -- check if the buffer is valid (might not be after install completes)
    if not vim.api.nvim_buf_is_valid(buf) then return end

    vim.treesitter.start(buf, lang)

    -- enable treesitter based folds
    -- for more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- check if treesitter indentation is available for this language, and if so, enable it
    -- in case there is no indent query, the indentexpr will fallback to vim's builtin one
    local has_indent_query = vim.treesitter.query.get(lang, 'indents') ~= nil

    -- enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()" end
end

return {
    'nvim-treesitter/nvim-treesitter',
    enabled = false,
    branch = 'master',
    build = ':TSUpdate',
    event = { 'LazyFileOpen', 'LazyOilPreview', 'LazyTelescopePreview', 'BufNewFile' },
    ft = { 'scm' },
    opts = {
        ensure_installed = {
            'bash', 'comment', 'diff', 'dockerfile', 'elixir', 'go', 'html',
            'javascript', 'json', 'kdl', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'ocaml', 'perl',
            'python', 'r', 'query', 'regex', 'sql', 'toml', 'vim', 'vimdoc', 'xml', 'yaml', 'zig'
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
        indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

        -- prefer git instead of curl in order to improve connectivity in some environments
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
    end
}
