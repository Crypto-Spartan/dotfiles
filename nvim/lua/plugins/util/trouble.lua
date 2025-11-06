local trouble_icons = function()
    if vim.g.have_nerd_font then
        return
    end

    return {
        indent = {
            fold_open = '',
            fold_closed = '',
        },
        folder_open = '',
        folder_closed = '',
        kinds = { false },
    }
end

return {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
        {
            '<leader>qd',
            function()
                vim.cmd('Trouble diagnostics toggle')
            end,
            desc = 'Diagnostics (Trouble)',
        },
        {
            '<leader>qD',
            function()
                vim.cmd('Trouble diagnostics toggle filter.buf=0')
            end,
            desc = 'Buffer Diagnostics (Trouble)',
        },
        {
            '<leader>qs',
            function()
                vim.cmd('Trouble symbols toggle focus=false')
            end,
            desc = 'Symbols (Trouble)',
        },
        {
            '<leader>ql',
            function()
                vim.cmd('Trouble lsp toggle focus=false win.position=right')
            end,
            desc = 'LSP Definitions / references / ... (Trouble)',
        },
        {
            '<leader>qL',
            function()
                vim.cmd('Trouble loclist toggle')
            end,
            desc = 'Location List (Trouble)',
        },
        {
            '<leader>qq',
            function()
                vim.cmd('Trouble qflist toggle')
            end,
            desc = 'Quickfix List (Trouble)',
        },
    },
    opts = {}
    -- opts = {
    --     icons = trouble_icons()
    -- },
}
