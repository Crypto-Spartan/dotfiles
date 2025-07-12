return {
    -- if encountering errors, see telescope-fzf-native README for installation instructions
    'nvim-telescope/telescope-fzf-native.nvim',
    lazy = true,

    -- `build` is used to run some command when the plugin is installed/updated
    -- this is only run then, not every time neovim starts up
    build = 'make',
    -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',

    cond = function()
        return vim.fn.executable('make') == 1
    end,
}
