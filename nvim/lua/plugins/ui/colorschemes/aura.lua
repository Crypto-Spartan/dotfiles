return {
    'daltonmenezes/aura-theme',
    lazy = true,
    priority = 800,
    config = function(plugin)
        vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
        vim.cmd.colorscheme('aura-dark')
    end
}
