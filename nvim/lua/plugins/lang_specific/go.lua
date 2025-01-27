return {
    'ray-x/go.nvim',
    enabled = false,
    dependencies = {
        'ray-x/guihua.lua',
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
    },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    ft = { 'go', 'gomod' },
    event = { 'CmdlineEnter' },
    config = function()
        require('go').setup()
    end,
}
