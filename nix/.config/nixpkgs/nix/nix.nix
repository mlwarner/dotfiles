{ config, lib, pkgs, ... }:

{
  xdg.configFile."nix/nix.conf".source = ./nix.conf;
}
