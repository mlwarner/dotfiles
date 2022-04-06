{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    g = "git";

    # Map newer tools 
    cat = "bat";
    diff = "delta";
    find = "fd";
    grep = "rg";
    ls = "exa";
    ps = "procs";
    vim = "nvim";

    # Shortcuts for common actions
    ta = "tmux attach";
    hme = "home-manager edit";
    hms = "home-manager switch";

    # Reload home manager and zsh
    reload = "home-manager switch && source ~/.zshrc";

    # Nix garbage collection
    garbage = "nix-collect-garbage -d && docker image prune --force";

    # See which Nix packages are installed
    installed = "nix-env --query --installed";

    dns_flush = "sudo killall -HUP mDNSResponder";
  };
in
{
  home.packages = with pkgs; [
    bat
    delta
    exa
    fd
    ffmpeg # Recording gifs
    fswatch # For ninja-dev-sync
    gnupg
    htop
    hyperfine
    #q-text-as-data
    pandoc # Markdown to HTML
    parallel
    procs
    ripgrep
    tldr
    tokei
    tree
    xh
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "less";
  };

  programs.zsh = {
    inherit shellAliases;

    enable = true;
    enableAutosuggestions = false;  # Auto suggestions cause huge latency on commands. Disable until its better.
    enableCompletion = true;

    # Add prezto until starship works again. See further down
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };

    # Loading goes env, profile, zshrc
    envExtra = builtins.readFile ./zshenv;
    profileExtra = builtins.readFile ./zprofile;
    initExtra = builtins.readFile ./zshrc;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    tmux.enableShellIntegration = true;
  };

  # Doesn't build on apple silicon yet. Track in https://github.com/NixOS/nixpkgs/issues/160876
  # x86 workaround in https://github.com/malob/nixpkgs/blob/master/flake.nix
  programs.starship = {
    enable = false;
    enableZshIntegration = true;
    settings = {
      nodejs = {
        disabled = true;  # nodejs execution is terrible in my shell. Need to figure out why
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd j"
    ];
  };
}
