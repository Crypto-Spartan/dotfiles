return {
    'hrsh7th/nvim-cmp',
    event = { 'BufEnter' },
    dependencies = {
        'L3MON4D3/LuaSnip',                -- snippet engine
        'saadparwaiz1/cmp_luasnip',        -- autocompletion
        'rafamadriz/friendly-snippets',    -- useful snippets
        'hrsh7th/cmp-nvim-lsp',            -- source for LSP
        'hrsh7th/cmp-buffer',              -- source for text in buffer
        'hrsh7th/cmp-path'                 -- source for file system paths
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
            completion = {
                completeopt = 'menu,menuone,preview,noselect'
            },
            snippet = { -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-n>']     = cmp.mapping.select_next_item(),
                ['<C-p>']     = cmp.mapping.select_prev_item(),
                ['<C-k>']     = cmp.mapping.select_prev_item(),
                ['<C-j>']     = cmp.mapping.select_next_item(),
                ['<C-u>']     = cmp.mapping.scroll_docs(-4),
                ['<C-d>']     = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                ['<C-y>']     = cmp.mapping.confirm({ select = true }),
                ['<CR>']      = cmp.mapping.confirm({ select = false })
            }),
            sources = cmp.config.sources({
                {
                    name = 'lazydev',
                    -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                    group_index = 0,
                },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' }
            })
        })
    end
}
