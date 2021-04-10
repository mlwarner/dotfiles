{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    g = "git";

    # Map newer tools
    cat = "bat";
    find = "fd";
    grep = "rg";
    ls = "exa";
    ps = "procs";
    vim = "nvim";

    # Shortcuts
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
  programs.zsh = {
    inherit shellAliases;

    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    sessionVariables = rec {
      EDITOR = "nvim";
    };

    # Loading goes env, profile, zshrc
    envExtra = builtins.readFile ./zshenv;
    profileExtra = builtins.readFile ./zprofile;
    initExtra = builtins.readFile ./zshrc;
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
