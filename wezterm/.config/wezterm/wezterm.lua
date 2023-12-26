-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Turn on webgpu. Default in later versions
config.front_end = 'WebGpu'

-- This is where you actually apply your config choices
config.color_scheme = "GruvboxDarkHard"
config.font = wezterm.font("JetBrains Mono Medium")
config.font_size = 15.0
config.line_height = 1.2

config.use_dead_keys = false
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = true

config.keys = {
	-- {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"}
}

return config
