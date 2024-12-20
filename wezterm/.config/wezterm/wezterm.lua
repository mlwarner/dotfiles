-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.color_scheme = "Tango (terminal.sexy)"
-- config.color_scheme = "Gruvbox dark, hard (base16)"
-- config.font = wezterm.font("JetBrains Mono")
config.font = wezterm.font({
    family = "Cascadia Code NF",
    weight = "Regular"
})
config.font_size = 16.0
config.line_height = 1.2
config.front_end = "WebGpu"

config.use_dead_keys = false
config.adjust_window_size_when_changing_font_size = false

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = true

config.keys = {
    -- {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"}
}

return config
