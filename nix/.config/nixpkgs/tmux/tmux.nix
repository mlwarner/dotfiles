{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
  };
}
