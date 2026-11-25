local luals_config = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = {
        {
            'pyproject.toml',
            'uv.lock',
            '.python_version',
            'requirements.txt',
            'setup.py',
            'setup.cfg',
            'Pipfile'
        },
        '.git'
    },
    single_file_support = true,
    plugins = {
        jedi_completion = {
            enabled = true,
            eager = true,
            include_params = true
        },
        jedi_definition = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = {
            enabled = true,
            all_scopes = true
        },
        mccabe = { enabled = true },
        rope_rename = { enabled = true },
        pylsp_rope = { enabled = true },
        ruff = { enabled = true }
    }
}

if vim.fn.has('nvim-0.12') then
    return pylsp_config
else
    vim.lsp.config['pylsp'] = pylsp_config
end