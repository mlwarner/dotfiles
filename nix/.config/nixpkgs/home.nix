{ pkgs, ... }:

let

  my-dotfile-dir = ~/dotfiles;

  # Git configuration
  gitConfig = "${my-dotfile-dir}/git/.config/git";

  # Vim Configuration
  vimRC = "${my-dotfile-dir}/vim/.vimrc";
  neovimRC = "${my-dotfile-dir}/neovim/.config/nvim/init.vim";
  neovimConfig = builtins.readFile neovimRC;

in

{
  home.packages = with pkgs; [
    fasd
    gnupg
    httpie
    jq
    mosh
    ripgrep
    rtv
    rustup
    tmux
    tree
  ];

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;

    configure.customRC = neovimConfig;

    vimAlias = true;
  };

  /*
  programs.git = {
    enable = true;

    userName = "Matt Warner";
    userEmail = "mlwarner632@gmail.com";

    aliases = {
      br = "branch";
      co = "checkout";
      ci = "commit";
      df = "diff";
      dt = "difftool";
      hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      mt = "mergetool";
      st = "status";
    };

    ignores = [
      "node_modules"
      "*.iml"
      "build"
    ];

    extraConfig = {
      core.pager = "less -FMRiX";
      difftool.prompt = false;

      mergetool = {
        keepBackup = false;
        prompt = false;
      };

      push.default = "simple";
    };
  };
  */

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";

      plugins = [
        "cargo"
        "git"
        "nix-shell"
        "rust"
      ];
    };
  };

  home.file = {
      # neovimRC depends on vimRC to exist in the filesystem
      # This is only necessary until we change the paths to load the plugins + source
      ".vimrc".source = vimRC;

      ".config/git" = {
        source = gitConfig;
        recursive = true;
      };
  };

  home.sessionVariables = {
      EDITOR = "vim";
  };
}
