{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    aerc
    colordiff
    dante
    isync
    #khal
    lbdb
    msmtp
    neomutt
    #notmuch
    #pass
    rtv
    #todo-txt-cli
    #urlscan
    w3m
  ];
}
