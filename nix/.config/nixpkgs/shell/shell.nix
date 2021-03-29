{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    g = "git";

    vim = "nvim";
    ta = "tmux attach";

    hms = "home-manager switch";

    # Reload home manager and zsh
    reload = "home-manager switch && source ~/.zshrc";

    # Nix garbage collection
    garbage = "nix-collect-garbage -d && docker image prune --force";

    # See which Nix packages are installed
    installed = "nix-env --query --installed";

    # Imported from zsh
    bb = "brazil-build";
    bbb = "bb build";
    bbc = "bb clean clean";
    bbr = "bb release";
    bbs = "bb server";
    brc = "brazil-recursive-cmd";
    bbbb = "brc brazil-build build";
    bball = "brc --allPackages";
    bbsuds = "bb --ds-type=suds --cloud";

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

    envExtra = builtins.readFile ./zshenv;

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
