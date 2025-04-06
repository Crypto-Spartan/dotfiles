vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            lsp_rust_desc = function(desc)
                return 'LSP (Rust): ' .. desc
            end

            vim.keymap.set({'n','x'}, 'K', function() vim.cmd.RustLsp({'hover', 'actions'}) end, {
                desc = lsp_rust_desc('Hover'),
                silent = true,
                buffer = bufnr
            })

            vim.keymap.set({'n','x'}, '<leader>le', function() vim.cmd.RustLsp({'hover', 'actions'}) end, {
                desc = lsp_rust_desc('Explain - Error'),
                silent = true,
                buffer = bufnr
            })
        end,
        default_settings = {
            ['rust-analyzer'] = {
                diagnostics = { enable = true },
            }
        }
    }
}

return {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false, -- This plugin is already lazy
}
