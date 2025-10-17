local precognition_keymap = '<leader>tm'

return {
    'tris203/precognition.nvim',
    dependencies = { 'folke/snacks.nvim' },
    lazy = true,
    keys = {
        {
            precognition_keymap,
            function()
                -- snacks toggle setup
                local p_pkg = package.loaded.precognition
                local toggle_opts = {
                    name = 'Precognition (Motions)',
                    get = function()
                        return p_pkg.is_visible
                    end,
                    set = function(state)
                        if state then
                            p_pkg.show()
                        else
                            p_pkg.hide()
                        end
                    end,
                }
                package.loaded.snacks.toggle.new(toggle_opts):map(precognition_keymap)
                package.loaded.snacks.toggle.toggles.precognition_motions:toggle()
            end,
            desc = 'Enable Precognition (Motions)'
        },
    },
    opts = {
        startVisible = false,
        showBlankVirtLine = false,
    }
}
