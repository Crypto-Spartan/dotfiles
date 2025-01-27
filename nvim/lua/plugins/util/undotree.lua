return {
    'mbbill/undotree',
    dependencies = { 'folke/snacks.nvim' },
    lazy = true,
    cmd = 'UndotreeToggle',
    init = function()
        vim.g.undotree_SetFocusWhenToggle = 1

        -- snacks toggle setup
        vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyFileOpen',
            once = true,
            callback = function()
                local undotree_snacks_enabled = false
                local toggle_opts = {
                    name = 'UndoTree',
                    get = function()
                        return undotree_snacks_enabled
                    end,
                    set = function()
                        undotree_snacks_enabled = not undotree_snacks_enabled
                        vim.cmd('UndotreeToggle')
                    end,
                }
                package.loaded.snacks.toggle.new(toggle_opts):map('<leader>tu')
            end
        })
    end,
}
