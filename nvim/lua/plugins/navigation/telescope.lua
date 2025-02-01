return {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    cmd = 'Telescope',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        'benfowler/telescope-luasnip.nvim',
    },
    keys = function()
        local function ts_actions()
            return require('telescope.actions')
        end
        local function ts_builtin()
            return require('telescope.builtin')
        end
        local function ts_utils()
            return require('telescope.utils')
        end

        -- local function get_nvim_root_dir()
        --     return vim.fn.getcwd()
        -- end
        -- local function get_cwd()
        --     return ts_utils().buffer_dir()
        -- end

        local function current_buffer_fuzzy_find()
            return ts_builtin().current_buffer_fuzzy_find()
        end

        local function ts_buffers_cmd()
            ts_builtin().buffers({ sort_mru = true, sort_lastused = true, initial_mode = 'normal' })
        end

        local function ts_resume_cmd()
            ts_builtin().resume({ initial_mode = 'normal' })
        end

        local plugins_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
        local nvim_config_dir = vim.fn.stdpath('config')

        local function has_rg_program(picker_name, program)
            if vim.fn.executable(program) == 1 then
                return true
            end

            ts_utils().notify(picker_name, {
                msg = string.format(
                "'ripgrep', or similar alternative, is a required dependency for the %s picker. "
                .. "Visit https://github.com/BurntSushi/ripgrep for installation instructions.",
                picker_name
                ),
                level = 'ERROR',
            })
            return false
        end

        local function get_help_files()
            local help_files = {}
            local rtp = vim.o.runtimepath

            -- extend the runtime path with all plugins not loaded by lazy.nvim
            local lazy = package.loaded['lazy.core.util']
            if lazy and lazy.get_unloaded_rtp then
                local paths = lazy.get_unloaded_rtp('')
                if #paths > 0 then
                    rtp = rtp .. ',' .. table.concat(paths, ',')
                end
            end
            local all_files = vim.fn.globpath(rtp, 'doc/*', 1, 1)
            for _, fullpath in ipairs(all_files) do
                local file = ts_utils().path_tail(fullpath)
                if file ~= 'tags' and not file:match('^tags%-..$') then
                    table.insert(help_files, fullpath)
                end
            end

            return help_files
        end

        local function opts_contain_invert(args)
            local invert = false
            local files_with_matches = false

            for _, v in ipairs(args) do
                if v == '--invert-match' then
                    invert = true
                elseif v == '--files-with-matches' or v == '--files-without-match' then
                    files_with_matches = true
                end

                if #v >= 2 and v:sub(1, 1) == '-' and v:sub(2, 2) ~= '-' then
                    local non_option = false
                    for i = 2, #v do
                        local vi = v:sub(i, i)
                        if vi == '=' then -- ignore option -g=xxx
                            break
                        elseif vi == 'g' or vi == 'f' or vi == 'm' or vi == 'e' or vi == 'r' or vi == 't' or vi == 'T' then
                            non_option = true
                        elseif non_option == false and vi == 'v' then
                            invert = true
                        elseif non_option == false and vi == 'l' then
                            files_with_matches = true
                        end
                    end
                end
            end
            return invert, files_with_matches
        end

        local function grep_help(opts)
            if opts == nil then
                opts = {}
            end

            local conf = require('telescope.config').values
            local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
            if not has_rg_program('live_grep', vimgrep_arguments[1]) then
                return
            end

            local additional_args = {}
            if opts.additional_args ~= nil then
                if type(opts.additional_args) == 'function' then
                    additional_args = opts.additional_args(opts)
                elseif type(opts.additional_args) == 'table' then
                    additional_args = opts.additional_args
                end
            end

            if opts.type_filter then
                additional_args[#additional_args + 1] = '--type=' .. opts.type_filter
            end

            if opts.glob_pattern ~= nil then
                if type(opts.glob_pattern) == 'string' then
                    additional_args[#additional_args + 1] = '--glob=' .. opts.glob_pattern
                elseif type(opts.glob_pattern) == 'table' then
                    for i = 1, #opts.glob_pattern do
                        additional_args[#additional_args + 1] = '--glob=' .. opts.glob_pattern[i]
                    end
                end
            end

            if opts.file_encoding then
                additional_args[#additional_args + 1] = '--encoding=' .. opts.file_encoding
            end

            local flatten = ts_utils().flatten
            local args = flatten({ vimgrep_arguments, additional_args })
            opts.__inverted, opts.__matches = opts_contain_invert(args)

            local finders = require('telescope.finders')
            local make_entry = require('telescope.make_entry')
            local search_list = get_help_files()

            local live_grepper = finders.new_job(function(prompt)
                if not prompt or prompt == '' then
                    return nil
                end

                return flatten({ args, '--', prompt, search_list })
            end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

            local pickers = require('telescope.pickers')
            local sorters = require('telescope.sorters')
            pickers.new(opts, {
                prompt_title = 'Live Grep',
                finder = live_grepper,
                previewer = conf.grep_previewer(opts),
                -- TODO: it would be cool to use `--json` output for this
                -- and then we could get the highlight positions directly
                sorter = sorters.highlighter_only(opts),
                attach_mappings = function(_, map)
                    map('i', '<c-space>', ts_actions().to_fuzzy_refine)
                    return true
                end,
                push_cursor_on_edit = true,
            })
            :find()
        end

        return {
            {
                '<leader>/',
                current_buffer_fuzzy_find,
                desc = 'Fuzzy find in current buffer'
            },
            {
                '<leader>:',
                function()
                    ts_builtin().command_history()
                end,
                desc = 'Command History'
            },
            {
                '<leader>"',
                function()
                    ts_builtin().registers()
                end,
                desc = 'Registers'
            },

            -- buffers
            {
                '<leader>bb',
                ts_buffers_cmd,
                desc = 'Open Buffers'
            },
            {
                '<leader>fb',
                ts_buffers_cmd,
                desc = 'Open Buffers'
            },

            -- find
            {
                '<leader>f/',
                function()
                    current_buffer_fuzzy_find()
                end,
                desc = 'Fuzzy find in current buffer'
            },
            {
                '<leader>fa',
                function()
                    ts_builtin().autocommands()
                end,
                desc = 'Auto Commands'
            },
            {
                '<leader>fc',
                function()
                    ts_builtin().commands()
                end,
                desc = 'Commands'
            },
            {
                '<leader>fC',
                function()
                    ts_builtin().colorscheme({ initial_mode = 'normal' })
                end,
                desc = 'Colorschemes with Preview'
            },
            {
                '<leader>fd',
                function()
                    ts_builtin().diagnostics({ bufnr = 0 })
                end,
                desc = 'Diagnostics - Document'
            },
            {
                '<leader>fD',
                function()
                    ts_builtin().diagnostics()
                end,
                desc = 'Diagnostics - Workspace'
            },
            {
                '<leader>ff',
                function()
                    local path = vim.custom_fn.get_nvim_cwd()
                    ts_builtin().find_files({
                        cwd = path,
                        prompt_title = 'Files in' .. path,
                    })
                end,
                desc = 'Files (nvim root dir)'
            },
            {
                '<leader>fF',
                function()
                    local path = vim.custom_fn.get_buf_cwd()
                    ts_builtin().find_files({
                        cwd = path,
                        prompt_title = 'Files in' .. path,
                    })
                end,
                desc = 'Files (cwd)'
            },
            {
                '<leader>fh',
                function()
                    ts_builtin().help_tags({
                        attach_mappings = function(_, map)
                            map({'i','n'}, '<cr>', ts_actions().select_tab)
                            return true
                        end
                    })
                end,
                desc = 'Help Tags'
            },
            {
                '<leader>fH',
                function()
                    ts_builtin().highlights()
                end,
                desc = 'Highlight Groups'
            },
            {
                '<leader>fi',
                function()
                    vim.cmd('Telescope luasnip')
                end,
                desc = 'Snippets'
            },
            {
                '<leader>fj',
                function()
                    ts_builtin().jumplist({ initial_mode = 'normal' })
                end,
                desc = 'Jumplist'
            },
            {
                '<leader>fk',
                function()
                    ts_builtin().keymaps()
                end,
                desc = 'Keymaps'
            },
            {
                '<leader>fl',
                function()
                    ts_builtin().loclist({ initial_mode = 'normal' })
                end,
                desc = 'Location List'
            },
            {
                '<leader>fm',
                function()
                    ts_builtin().man_pages()
                end,
                desc = 'Man Pages'
            },
            {
                '<leader>fn',
                function()
                    ts_builtin().find_files({
                        cwd = nvim_config_dir,
                        prompt_title = 'Files in' .. nvim_config_dir,
                    })
                end,
                desc = 'Neovim Config Files'
            },
            {
                '<leader>fp',
                function()
                    ts_builtin().find_files({
                        cwd = plugins_dir,
                        prompt_title = 'Plugin Files in' .. plugins_dir,
                    })
                end,
                desc = 'Plugin Files'
            },
            {
                '<leader>fq',
                function()
                    ts_builtin().quickfix({ initial_mode = 'normal' })
                end,
                desc = 'Quickfix List'
            },
            {
                '<leader>fr',
                function()
                    ts_resume_cmd()
                end,
                desc = 'Resume (Telescope)'
            },
            {
                '<leader>ft',
                function()
                    ts_builtin().builtin()
                end,
                desc = 'Telescope Functions'
            },
            {
                '<leader>fv',
                function()
                    ts_builtin().vim_options()
                end,
                desc = 'Vim Options'
            },

            -- search
            {
                '<leader>sf',
                function()
                    local path = vim.custom_fn.get_nvim_cwd()
                    ts_builtin().live_grep({
                        cwd = path,
                        prompt_title = 'Grep in' .. path,
                    })
                end,
                desc = 'Grep (nvim root dir)'
            },
            {
                '<leader>sF',
                function()
                    local path = vim.custom_fn.get_buf_cwd()
                    ts_builtin().live_grep({
                        cwd = path,
                        prompt_title = 'Grep in' .. path,
                    })
                end,
                desc = 'Grep (cwd)'
            },
            {
                '<leader>sh',
                function()
                    grep_help({
                        attach_mappings = function(_, map)
                            map({'i','n'}, '<CR>', ts_actions().select_tab)
                            return true
                        end,
                        prompt_title = 'Grep in Help Docs'
                    })
                end,
                desc = 'Help Docs (Grep)'
            },
            {
                '<leader>sn',
                function()
                    ts_builtin().live_grep({
                        cwd = nvim_config_dir,
                        prompt_title = 'Grep in' .. nvim_config_dir,
                    })
                end,
                desc = 'Neovim Config Files (Grep)'
            },
            {
                '<leader>so',
                function()
                    ts_builtin().live_grep({
                        grep_in_open_files = true,
                        prompt_title = 'Grep in Open Files',

                    })
                end,
                desc = 'Open Files (Grep)'
            },
            {
                '<leader>sp',
                function()
                    ts_builtin().live_grep({
                        cwd = plugins_dir,
                        prompt_title = 'Grep in Plugin Files',

                    })
                end,
                desc = 'Plugin Files (Grep)'
            },
            {
                '<leader>sr',
                ts_resume_cmd,
                desc = 'Telescope Resume'
            },
            {
                '<leader>sw',
                function()
                    local path = vim.custom_fn.get_nvim_cwd()
                    ts_builtin().live_grep({
                        cwd = path,
                        prompt_title = 'Grep (current word) in' .. path,
                        word_match = '-w',
                        initial_mode = 'normal'
                    })
                end,
                desc = 'Grep current Word (nvim root dir)',
                mode = {'n', 'v'}
            },
            {
                '<leader>sW',
                function()
                    local path = vim.custom_fn.get_buf_cwd()
                    ts_builtin().live_grep({
                        cwd = path,
                        prompt_title = 'Grep (current word) in' .. path,
                        word_match = '-w',
                        initial_mode = 'normal'
                    })
                end,
                desc = 'Grep current Word (cwd)',
                mode = {'n', 'v'}
            },
        }
    end,
    config = function()
        -- 2 important keymaps in telescope are:
        --  - insert mode: <C-/>
        --  - normal mode: ?
        -- these open a window that shows all of the keymaps for the current telescope picker

        -- [ Configure Telescope ]
        -- see `:help telescope` & `:help telescope.setup()`

        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ['<C-c>']   = { '<esc>', type = 'command' },
                        ['<C-k>']   = actions.move_selection_previous,
                        ['<C-j>']   = actions.move_selection_next,
                        ['<C-q>']   = actions.send_selected_to_qflist + actions.open_qflist,
                        ['<Left>']  = actions.preview_scrolling_left,
                        ['<Right>'] = actions.preview_scrolling_right,
                        ['<Up>']    = actions.preview_scrolling_up,
                        ['<Down>']  = actions.preview_scrolling_down,
                    },
                    n = {
                        ['q'] = actions.close,
                    },
                },
                layout_config = {
                    cursor = { width = 0.9 },
                    horizontal = { width = 0.9 },
                    vertical = { width = 0.9 },
                }
            },
            pickers = {
                colorscheme = {
                    enable_preview = true,
                },
            },
            extensions = { 'fzf', 'luasnip' },
        })

        telescope.load_extension('fzf')
        telescope.load_extension('luasnip')
    end
}

