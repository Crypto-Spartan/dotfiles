return {
    'L3MON4D3/LuaSnip',
    build = (function()
        -- build step is needed for regex support in snippets
        -- this step is not supported in many windows environments
        -- remove the condition below to re-enable on windows
        if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
        end
        return 'make install_jsregexp'
    end)(),
    dependencies = {
        'rafamadriz/friendly-snippets',
        'benfowler/telescope-luasnip.nvim',
    },
    lazy = true,
}
