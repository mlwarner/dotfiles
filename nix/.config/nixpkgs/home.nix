{ pkgs, ... }:

{
  imports = [
    ./alacritty/alacritty.nix
    #./email/email.nix
    ./git/git.nix
    ./neovim/neovim.nix
    #./nix/nix.nix
    ./nodejs/nodejs.nix
    ./ruby/ruby.nix
    ./shell/shell.nix
    ./ssh/ssh.nix
    ./tmux/tmux.nix
  ];

  programs.home-manager.enable = true;

  # nixpkgs.overlays = [
  #   (self: super: {
  #     # Overwrite broken miniupnpc on darwin
  #     miniupnpc = super.miniupnpc.overrideAttrs (oldAttrs: {
  #       postInstall = '''';
  #     });
  #   })
  #   (self: super: {
  #     # Overwrite broken miniupnpc on darwin
  #     aerc = super.aerc.overrideAttrs (oldAttrs: {
  #     });
  #   })
  # ];
}
