{ config, lib, pkgs, ... }:

{
  home.file.".npmrc".source = ./npmrc;
}
