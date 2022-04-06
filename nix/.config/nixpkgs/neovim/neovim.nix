{ config, lib, pkgs, ... }:

let
  vim-lists = pkgs.vimUtils.buildVimPlugin {
    name = "vim-lists";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "lists.vim";
      rev = "8e0d489c58b4a67765ea4ee9e3c12547e402fcef";
      sha256 = "0hc9qnj7jqy63ibw6k13yi5pc98z4ka3163biy46pznarcf9q4hm";
    };
  };

  vim-wiki = pkgs.vimUtils.buildVimPlugin {
    name = "vim-wiki";
    src = pkgs.fetchFromGitHub {
      owner = "lervag";
      repo = "wiki.vim";
      rev = "13d7fd6166c65dd9f7c05359543d6e44a9a49426";
      sha256 = "1xd95dk9f5fccc3hwijhaclzc8njd6w08maa3rncnips2ka60kic";
    };
  };

in

{
  programs.neovim = {
    enable = true;

    # Sets alias vim=nvim
    vimAlias = true;

    extraConfig = builtins.readFile ./vimrc;

    # Neovim plugins
    plugins = with pkgs.vimPlugins; [
      # vim compatible plugins
      vim-commentary
      vim-fugitive
      #goyo-vim
      #limelight-vim
      #fzf-vim
      vim-lists
      vim-wiki
      vim-startify
      vim-vsnip

      # Neovim plugins for >0.5
      gruvbox-nvim
      lualine-nvim
      nvim-lspconfig
      nvim-treesitter
      telescope-fzf-native-nvim
      telescope-nvim
      twilight-nvim
      zen-mode-nvim

      # neovim completion plugins
      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-spell
      cmp-vsnip
    ];
  };
}
