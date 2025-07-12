return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'LazyFileOpen', 'LazyTelescopePreview', 'BufNewFile' },
    opts = {
        signs = false,
    }
}
