{ pkgs, ... }:

let
  myCLIPackages = with pkgs; [
    autossh
    bat
    delta
    exa
    fd
    git
    gnupg
    htop
    #q-text-as-data
    procs
    ripgrep
    starship
    tldr
    tmux
    tokei
    tree
    watchman
  ];

  myNinjaDevSyncPackages = with pkgs; [
    fswatch
  ];

  myDocumentationPackages = with pkgs; [
    ffmpeg
    pandoc
    #plantuml
  ];

  myCLIEmailPackages = with pkgs; [
    aerc
    colordiff
    dante
    isync
    #khal
    lbdb
    msmtp
    neomutt
    #notmuch
    #pass
    rtv
    #todo-txt-cli
    #urlscan
    w3m
  ];

  myJavascriptDevelopmentPackages = with pkgs; [
    httpie
    jq
    nodejs
  ];

  myPackagesForRubyDevelopment = with pkgs; [
    ruby
    solargraph
  ];

in

{
  imports = [
    ./alacritty/alacritty.nix
    ./git/git.nix
    ./neovim/neovim.nix
    ./npm/npm.nix
    ./shell/shell.nix
    #./ssh/ssh.nix
    ./tmux/tmux.nix
  ];

  programs.home-manager.enable = true;

  home.packages = myCLIPackages
  #++ myCLIEmailPackages
  #++ myNinjaDevSyncPackages
  #++ myDocumentationPackages
  ++ myJavascriptDevelopmentPackages;
  #++ myPackagesForRubyDevelopment;
}

