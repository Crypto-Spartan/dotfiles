return {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git' },
    keys = {
        { '<leader>gf', vim.cmd.Git, desc = 'Git (fugitive)' },
    }
}
