return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'LazyFileOpen', 'BufNewFile' },
    opts = {
        signs = false,
    }
}
