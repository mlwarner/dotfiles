{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    autossh
  ];

  home.file.".ssh/config".source = ./config;
}
