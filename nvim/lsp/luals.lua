local luals_config = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        {
            '.luarc.json',
            '.luarc.jsonc'
        },
        '.git'
    },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            completion = { callSnippet = 'Replace' },
            diagnostics = {
                -- disable = { 'missing-fields' }, -- ignore LuaLS's noisy `missing-fields` warnings
                globals = { 'vim', 'require' },
            },
            workspace = {
                -- make LSP aware of runtime files
                library = {
                    vim.fn.expand('$VIMRUNTIME/lua'),
                    vim.fn.stdpath('config')..'/lua',
                    '${3rd}/luv/library'
                }
            },
            telemetry = { enable = false }
        }
    }
}

if vim.fn.has('nvim-0.12') then
    return luals_config
else
    vim.lsp.config['luals'] = luals_config
end