{ config, lib, pkgs, ... }:

let
  my-dotfile-dir = ~/dotfiles;

  # Git configuration
  gitConfigDir = "${my-dotfile-dir}/git/.config/git";
in

{
  programs.git = {
    enable = true;
    userName = "Matt Warner";
    userEmail = "mwarner@amazon.com";

    aliases = {
      br = "branch";
      ci = "commit";
      co = "checkout";
      df = "diff";
      dt = "difftool";
      mt = "mergetool";
      st = "status";
      sw = "switch";
    };

    ignores = [
      "*.iml"
      "build"
      "node_modules"
    ];

    extraConfig = {
      amazon = {
        append-cr-url = true;
        pull-request-by-default = true;
      };
      commit.template = "~/.config/git/message";
      core.pager = "less -FMRiX";
      pull.rebase = false;
      push.default = "simple";
    };
  };

  home.file.".config/git/message".source = ./message;
}
