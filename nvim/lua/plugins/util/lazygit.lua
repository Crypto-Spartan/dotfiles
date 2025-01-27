return {
    'kdheepak/lazygit.nvim',
    enabled = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    cmd = {
        'LazyGit',
        'LazyGitConfig',
        'LazyGitCurrentFile',
        'LazyGitFilter',
        'LazyGitFilterCurrentFile',
    },
    keys = {
        { '<leader>gl', vim.cmd.LazyGit, desc = 'LazyGit' },
        { '<leader>lg', vim.cmd.LazyGit, desc = 'LazyGit' },
    }
}
