local zls_config = {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' }
}

if vim.fn.has('nvim-0.12') then
    return zls_config
else
    vim.lsp.config['zls'] = zls_config
end