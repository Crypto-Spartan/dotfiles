return {
    'neovim/nvim-lspconfig',
    event = { 'LazyFileOpen', 'BufNewFile' },
    dependencies = {
        'williamboman/mason.nvim', -- NOTE: Must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'SmiteshP/nvim-navbuddy',
        'j-hui/fidget.nvim',
        'hrsh7th/cmp-nvim-lsp',
    },
    init = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

                map('gr', require('telescope.builtin').lsp_references, 'Goto References')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('gi', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map('<leader>gt', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map('<leader>fs', require('telescope.builtin').lsp_document_symbols, 'Find Symbols (Document)')

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map('<leader>fS', require('telescope.builtin').lsp_document_symbols, 'Find Symbols (Workspace)')

                map('<leader>lr', vim.lsp.buf.rename, 'Rename')
                map('<leader>la', vim.lsp.buf.code_action, 'Action', {'n','x'})
                map('<leader>lR', vim.cmd.LspRestart, 'Restart')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed

                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                --     local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                --         buffer = event.buf,
                --         group = highlight_augroup,
                --         callback = vim.lsp.buf.document_highlight,
                --     })
                --
                --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                --         buffer = event.buf,
                --         group = highlight_augroup,
                --         callback = vim.lsp.buf.clear_references,
                --     })
                --
                --     vim.api.nvim_create_autocmd('LspDetach', {
                --         group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                --         callback = function(event2)
                --             vim.lsp.buf.clear_references()
                --             vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                --         end,
                --     })
                -- end

                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, 'Toggle Hints')
                    vim.lsp.inlay_hint.enable(true)
                    local toggle_opts = {
                        name = 'Hints (LSP)',
                        get = function()
                            return vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
                        end,
                        set = function(state)
                            if state then
                                vim.lsp.inlay_hint.enable(true)
                            else
                                vim.lsp.inlay_hint.enable(false)
                            end
                        end,
                    }
                    package.loaded.snacks.toggle.new(toggle_opts):map('<leader>th')
                end
            end,
        })
    end,
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        completion = { callSnippet = 'Replace' },
                        diagnostics = {
                            -- disable = { 'missing-fields' }, -- ignore Lua_LS's noisy `missing-fields` warnings
                            globals = { 'vim' }, -- make the LSP recognize 'vim' global
                        },
                        workspace = {
                            -- make LSP aware of runtime files
                            library = {
                                vim.fn.expand('$VIMRUNTIME/lua'),
                                vim.fn.stdpath('config') .. '/lua',
                                '${3rd}/luv/library',
                            },
                        },
                    },
                },
            },
            -- gopls = {
            --     settings = {
            --         hints = {
            --             assignVariableTypes = true,
            --             compositeLiteralFields = true,
            --             compositeLiteralTypes = true,
            --             constantValues = true,
            --             functionTypeParameters = true,
            --             parameterNames = true,
            --             rangeVariableTypes = true,
            --         },
            --     },
            -- },
        }

        require('mason').setup()

        -- You can add other tools here that you want Mason to install for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            -- 'gopls',
            -- 'goimports',
            'lua_ls',
            -- 'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

        require('mason-lspconfig').setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        })
    end,
}
