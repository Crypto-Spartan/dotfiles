return {
    'tpope/vim-fugitive',
    enabled = false,
    cmd = { 'G', 'Git' },
    keys = {
        { '<leader>gf', vim.cmd.Git, desc = 'Git (fugitive)' },
    }
}
