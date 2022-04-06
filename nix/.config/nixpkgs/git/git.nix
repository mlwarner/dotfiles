{ config, lib, pkgs, ... }:

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

    delta.enable = true;

    extraConfig = {
      amazon = {
        append-cr-url = true;
        pull-request-by-default = true;
      };
      commit.template = "~/.config/git/message";
      pull.rebase = false;
      push.default = "simple";
    };
  };

  xdg.configFile."git/message".source = ./message;
}
