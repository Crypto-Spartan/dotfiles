local ra_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' }
}

if vim.fn.has('nvim-0.12') then
    return ra_config
else
    vim.lsp.config['rust_analyzer'] = ra_config
end
