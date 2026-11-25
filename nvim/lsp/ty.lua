local ty_config = {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = {
        {
            'pyproject.toml',
            'uv.lock',
            '.python_version',
            'requirements.txt',
            'setup.py',
            'setup.cfg'
        },
        '.git'
    }
}

if vim.fn.has('nvim-0.12') then
    return ty_config
else
    vim.lsp.config['ty'] = ty_config
end