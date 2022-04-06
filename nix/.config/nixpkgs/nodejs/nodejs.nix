{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    #httpie
    hey
    jq
    nodejs
  ];

  home.file.".npmrc".source = ./npmrc;
}
