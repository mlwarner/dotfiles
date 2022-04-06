{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
