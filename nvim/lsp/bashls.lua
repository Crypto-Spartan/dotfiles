local bashls_config = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' }
}

if vim.fn.has('nvim-0.12') then
    return bashls_config
else
    vim.lsp.config['bashls'] = bashls_config
end