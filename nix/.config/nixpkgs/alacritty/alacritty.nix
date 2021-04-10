{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {

      window = {
        padding.x = 10;
        padding.y = 10;
        decorations = "full";
        dynamic_title = true;
      };

      font = {
        size = 14.0;
        offset = {
          x = 0;
          y = 10;
        };
        use_thin_strokes = false;

        normal = {
          family = "Jetbrains Mono";
          style = "Regular";
        };
        bold = {
          family = "Jetbrains Mono";
          style = "Bold";
        };
        italic = {
          family = "Jetbrains Mono";
          style = "Italic";
        };
      };

      # Colors (Gruvbox dark)
      colors = {
        primary = {
          background = "#282828";
          foreground = "#ebdbb2";
        };

        normal = {
          black =   "#282828";
          red =     "#cc241d";
          green =   "#98971a";
          yellow =  "#d79921";
          blue =    "#458588";
          magenta = "#b16286";
          cyan =    "#689d6a";
          white =   "#a89984";
        };

        bright = {
          black =   "#928374";
          red =     "#fb4934";
          green =   "#b8bb26";
          yellow =  "#fabd2f";
          blue =    "#83a598";
          magenta = "#d3869b";
          cyan =    "#8ec07c";
          white = "#ebdbb2";
        };
      };

      # Add additional keybinds for tmux
      key_bindings = [
        # New tab.
        { key = "T";        mods = "Command";       chars = "\\x02\\x63"; }

        # Close tab.
        { key = "W";        mods = "Command";       chars = "\\x02\\x64"; }

        # Move one tab right.
        { key = "RBracket"; mods = "Command|Shift"; chars = "\\x02\\x6e"; }

        # Move one tab left.
        { key = "LBracket"; mods = "Command|Shift"; chars = "\\x02\\x70"; }

        # Move to tab x.
        { key = "Key1";     mods = "Command";       chars = "\\x02\\x31"; }
        { key = "Key2";     mods = "Command";       chars = "\\x02\\x32"; }
        { key = "Key3";     mods = "Command";       chars = "\\x02\\x33"; }
        { key = "Key4";     mods = "Command";       chars = "\\x02\\x34"; }
        { key = "Key5";     mods = "Command";       chars = "\\x02\\x35"; }
        { key = "Key6";     mods = "Command";       chars = "\\x02\\x36"; }
        { key = "Key7";     mods = "Command";       chars = "\\x02\\x37"; }
        { key = "Key8";     mods = "Command";       chars = "\\x02\\x38"; }
        { key = "Key9";     mods = "Command";       chars = "\\x02\\x39"; }
      ];
    };
  };
}
