-- NOTE: I use Wezterm on Windows, not Linux

-- pull in wezterm API
local wezterm = require('wezterm')
-- this will hold the config
local config = wezterm.config_builder()

-- example:
-- config.color_scheme = 'AdventureTime'

-- fix 'The OpenGL implementation is too old to work with glium'
-- config.prefer_egl = true

config.default_prog = { 'powershell.exe' }
-- config.default_cwd = ''

config.font = wezterm.font_with_fallback({
    'Consolas',
    'JetBrains Mono NL',
    'Cascadia Mono',
    'DejaVu Sans Mono for Powerline',

    -- <built-in>, BuiltIn
    -- Assumed to have Emoji Presentation
    'Noto Color Emoji',
    -- <built-in>, BuiltIn
    'Symbols Nerd Font Mono'
})
config.font_size = 14.0

config.enable_scroll_bar = true
--config.color_scheme = 'Catppuccin Mocha'

return config
