{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    httpie
    jq
    nodejs
  ];

  home.file.".npmrc".source = ./npmrc;
}
