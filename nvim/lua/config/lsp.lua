local lsp_servers = { 'bashls', 'gopls', 'luals', 'rust-analyzer', 'ty', 'zls' }
for _, name in ipairs(lsp_servers) do
    vim.lsp.enable(name)
end
