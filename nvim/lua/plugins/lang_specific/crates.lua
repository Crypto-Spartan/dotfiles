return {
    'saecki/crates.nvim',
    dependencies = {
        'hrsh7th/nvim-cmp',
    },
    event = 'BufRead Cargo.toml',
    init = function()
        vim.api.nvim_create_autocmd('BufRead', {
            group = vim.api.nvim_create_augroup('CmpSourceCargo', { clear = true }),
            pattern = 'Cargo.toml',
            callback = function()
                package.loaded.cmp.setup.buffer({ sources = { { name = 'crates' } } })
            end,
        })
    end,
    opts = {
        lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
        }
    },
}
