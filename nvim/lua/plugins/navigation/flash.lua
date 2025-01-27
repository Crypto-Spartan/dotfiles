return {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                enabled = false
            }
        }
    },
    -- stylua: ignore
    keys = {
        { 's', mode = { 'n','x','o' }, function() require('flash').jump() end, desc = 'Flash' },
        { 'S', mode = { 'n','x','o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
        { 'r', mode = { 'o' }, function() require('flash').remote() end, desc = 'Flash Remote' },
        { 'R', mode = { 'x','o' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
        { '<leader>tf', mode = { 'n','x','o','c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
}
