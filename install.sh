#!/bin/bash

ln -s $PWD/nix/.config/nixpkgs $HOME/.config/nixpkgs

home-manager switch
