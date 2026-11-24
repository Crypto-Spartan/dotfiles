return {
    'lewis6991/satellite.nvim',
    lazy = true,
    event = { 'LazyFileOpen', 'BufNewFile' },
    opts = {
        winblend = 50 -- level of transparency, 0-100
    },
    config = function(_, opts)
        local stl_pkg = require('satellite')
        stl_pkg.setup(opts)

        local satellite_enabled = true
        local toggle_opts = {
            name = 'satellite.nvim',
            get = function()
                return satellite_enabled
            end,
            set = function(state)
                if state then
                    vim.cmd('SatelliteEnable')
                    satellite_enabled = true
                    vim.cmd('SatelliteRefresh')
                else
                    vim.cmd('SatelliteDisable')
                    satellite_enabled = false
                end
            end
        }
        package.loaded.snacks.toggle.new(toggle_opts):map('<leader>ts')
    end
}
