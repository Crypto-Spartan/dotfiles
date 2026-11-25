local gopls_config = {
    cmd = { 'gopls' },
    filetypes = { 'go' },
    settings = {
        hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true
        }
    }
}

if vim.fn.has('nvim-0.12') then
    return gopls_config
else
    vim.lsp.config['gopls'] = gopls_config
end