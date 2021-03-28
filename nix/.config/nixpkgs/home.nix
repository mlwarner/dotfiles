{ pkgs, ... }:

let
  my-dotfile-dir = ~/dotfiles;

  myCLIPackages = with pkgs; [
    autossh
    #eternal-terminal
    fasd
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
    ./programs/alacritty/alacritty.nix
    ./programs/git/git.nix
    ./programs/neovim/neovim.nix
    ./programs/shell/shell.nix
    ./programs/tmux/tmux.nix
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

  home.file = {
      ".npmrc".source = "${my-dotfile-dir}/npm/.npmrc";
      #".ssh/config".source = "${my-dotfile-dir}/ssh/.ssh/config";

      # Cannot symlink config that needs to be writable
      #".config/ninja-dev-sync.json".source = "${my-dotfile-dir}/ninja-dev-sync/.config/ninja-dev-sync.json";
  };
}

