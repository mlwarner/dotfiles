{ pkgs, ... }:

let
  myNinjaDevSyncPackages = with pkgs; [
    fswatch
  ];

  myDocumentationPackages = with pkgs; [
    ffmpeg
    pandoc
    #plantuml
  ];
in

{
  imports = [
    ./alacritty/alacritty.nix
    #./email/email.nix
    ./git/git.nix
    ./neovim/neovim.nix
    ./nodejs/nodejs.nix
    #./ruby/ruby.nix
    ./shell/shell.nix
    ./ssh/ssh.nix
    ./tmux/tmux.nix
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    delta
    exa
    fd
    gnupg
    htop
    #q-text-as-data
    procs
    ripgrep
    tldr
    tokei
    tree
    watchman
  ];
}
