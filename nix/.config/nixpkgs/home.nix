{ pkgs, ... }:

let
  myCLIPackages = with pkgs; [
    autossh
    #eternal-terminal
    fd
    git
    gnupg
    mosh
    #q-text-as-data
    ripgrep
    silver-searcher
    starship
    #taskwarrior
    #timewarrior
    tldr
    tmux
    tree
    zsh-autosuggestions
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

  home.packages = with pkgs; [
    #neovim
    watchman # To monitor file changes with vim-coc
  ]
  ++ myCLIPackages
  #++ myCLIEmailPackages
  #++ myNinjaDevSyncPackages
  #++ myDocumentationPackages
  ++ myJavascriptDevelopmentPackages;
  #++ myPackagesForRubyDevelopment;
}

