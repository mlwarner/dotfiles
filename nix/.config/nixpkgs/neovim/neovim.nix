{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    # Sets alias vim=nvim
    vimAlias = true;

    extraConfig = builtins.readFile ./vimrc;

    # Neovim plugins
    plugins = with pkgs.vimPlugins; [
      airline
      coc-nvim
      coc-markdownlint
      coc-prettier
      coc-tsserver
      commentary
      fzf-vim
      gruvbox-community
      sensible
      vimwiki
      vim-javascript
      vim-nix
    ];
  };
}
