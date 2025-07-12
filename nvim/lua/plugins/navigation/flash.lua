return {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                enabled = false,
                -- -- hide after jump when not using jump labels
                -- autohide = false,
                -- -- show jump labels
                -- jump_labels = false,
                -- -- when using jump labels, don't use these keys
                -- -- this allows using those keys directly after the motion
                -- label = { exclude = 'hjkliarxdc' },
                -- highlight = { backdrop = false },
            }
        }
    },
    -- stylua: ignore
    keys = {
        { 's', mode = { 'n','x' }, function() package.loaded.flash.jump() end, desc = 'Flash' },
        { 'S', mode = { 'n' }, function() package.loaded.flash.treesitter() end, desc = 'Flash Treesitter' },
        { 'r', mode = { 'o' }, function() package.loaded.flash.remote() end, desc = 'Flash Remote' },
        { 'R', mode = { 'x','o' }, function() package.loaded.flash.treesitter_search() end, desc = 'Treesitter Search' },
        { '<leader>tf', mode = { 'n','x' }, function() package.loaded.flash.toggle() end, desc = 'Toggle Flash' },
    },
}
