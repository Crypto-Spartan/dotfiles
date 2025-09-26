local toggle_icons = function()
    if vim.g.have_nerd_font then
        return
    end

    return {
        enabled = '✅',
        disabled = '❌'
    }
end

return {
    'folke/snacks.nvim',
    lazy = false,
    priority = 900,
    ---@type snacks.Config
    opts = {
        animate   = { enabled = true },
        bigfile   = { enabled = false },
        bufdelete = { enabled = true },
        dashboard = { enabled = false },
        debug     = { enabled = true },
        dim       = { enabled = false },
        git       = { enabled = true },
        gitbrowse = { enabled = false },
        indent    = { enabled = false },
        input     = { enabled = false },
        lazygit   = { enabled = false },
        notifier  = {
            enabled = false,
            -- timeout = 3000,
        },
        notify       = { enabled = false },
        profiler     = { enabled = true },
        quickfile    = { enabled = false },
        rename       = { enabled = false },
        scope        = { enabled = false },
        scratch      = { enabled = true },
        scroll       = { enabled = true },
        statuscolumn = { enabled = true },
        terminal     = { enabled = true },
        toggle       = {
            enabled = true,
            which_key = true,
            icon = toggle_icons(),
            color = {
                enabled = 'green',
                disabled = 'red'
            },
        },
        util  = { enabled = true },
        win   = { enabled = true },
        words = { enabled = false },
        zen   = { enabled = false },
        styles = {
            notification = {
                wo = { wrap = true } -- wrap notifications
            }
        }
    },
    keys = {
        { '<leader>bd',  function() Snacks.bufdelete() end,        desc = 'Delete Buffer' },
        { '<leader>gb',  function() Snacks.git.blame_line() end,   desc = 'Git Blame Line' },
        {
            '<leader>gg',
            desc = 'Lazygit',
            function()
                local current_dir = vim.custom_fn.get_buf_cwd()
                local _, git_dir = next(vim.fs.find('.git', {
                    path = current_dir,
                    upward = true,
                    type = 'directory'
                }))
                if git_dir == nil or git_dir:len() == 0 then
                    vim.notify('Unable to open LazyGit, not in a git directory', vim.log.levels.WARN, {
                        title = 'LazyGit Warning',
                        timeout = 2500
                    })
                    return
                end
                Snacks.lazygit({
                    args = { '-p', vim.fs.dirname(git_dir) }
                })
            end
        },
        { '<leader>gf',  function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
        { '<leader>gl',  function() Snacks.lazygit.log() end,      desc = 'Lazygit Log (cwd)' },
        { '<leader>tps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' },
        { '<c-/>',       function() Snacks.terminal() end,         desc = 'Toggle Terminal' },
        {
            '<leader>N',
            desc = 'Neovim News',
            function()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
                    width = 0.8,
                    height = 0.8,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = 'yes',
                        statuscolumn = ' ',
                        conceallevel = 3,
                    },
                })
            end,
        },
    },
    init = function()
        -- snacks config on VeryLazy
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            once = true,
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dbg = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                -- vim.print = _G.dbg -- Override print to use snacks for `:=` command

                -- toggle the profiler
                Snacks.toggle.profiler():map('<leader>tpp')
                -- toggle the profiler highlights
                Snacks.toggle.profiler_highlights():map('<leader>tph')

                -- Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
                -- Snacks.toggle.line_number():map('<leader>ul')
                -- Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>uc')
                -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
                -- Snacks.toggle.inlay_hints():map('<leader>uh')
            end,
        })

        -- snacks config on file open
        vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyFileOpen',
            once = true,
            callback = function()
                Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
                Snacks.toggle.diagnostics():map('<leader>td')
                Snacks.toggle.treesitter():map('<leader>tt')
            end,
        })
    end,
}
