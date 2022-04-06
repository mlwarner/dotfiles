{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {

      window = {
        padding.x = 4;
        padding.y = 4;
        decorations = "full";
        dynamic_title = true;
        dynamic_padding = true;
      };

      font = {
        size = 15.0;

        # Offset is the extra space around each character. `offset.y` can be thought of
        # as modifying the line spacing, and `offset.x` as modifying the letter spacing
        # I've given in 14 spacing which fits really well with my fonts, you may change it
        # to your convenience but make sure to adjust 'glyph_offset' appropriately post that
        offset = {
          x = 0;
          y = 4;
        };

        # Note: This requires RESTART
        # By default when you change the offset above you'll see an issue, where the texts are bottom
        # aligned with the cursor, this is to make sure they center align.
        # This offset should usually be 1/2 of the above offset-y being set.
        glyph_offset = {
          x = 0;
          y = 2;
        };
        #use_thin_strokes = true;

        normal = {
          #family = "Jetbrains Mono";
          family = "Cascadia Code PL";
          style = "Regular";
        };
        bold = {
          #family = "Jetbrains Mono";
          family = "Cascadia Code PL";
          style = "Bold";
        };
        italic = {
          #family = "Jetbrains Mono";
          family = "Cascadia Code PL";
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

      # What happens with things we highlight
      selection = {
        # When set to `true`, selected text will be copied to the primary clipboard.
        save_to_clipboard = true;
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
        { key = "Key0";     mods = "Command";       chars = "\\x02\\x30"; }
        { key = "Key1";     mods = "Command";       chars = "\\x02\\x31"; }
        { key = "Key2";     mods = "Command";       chars = "\\x02\\x32"; }
        { key = "Key3";     mods = "Command";       chars = "\\x02\\x33"; }
        { key = "Key4";     mods = "Command";       chars = "\\x02\\x34"; }
        { key = "Key5";     mods = "Command";       chars = "\\x02\\x35"; }
        { key = "Key6";     mods = "Command";       chars = "\\x02\\x36"; }
        { key = "Key7";     mods = "Command";       chars = "\\x02\\x37"; }
        { key = "Key8";     mods = "Command";       chars = "\\x02\\x38"; }
        { key = "Key9";     mods = "Command";       chars = "\\x02\\x39"; }

        # Fix ctrl+space
        { key = "Space";    mods = "Control";       chars = "\\x00";      }
      ];
    };
  };
}
