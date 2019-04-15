# Dotfiles

## Description

This is a collection of my different configurations I use. I've attempted to create a reproducible setup across machines by:

- Creating a collection of dotfiles  which contain my configurations
- Using Nix for reproducible build environments (tooling)
- Using Home Manager to vend the configuration and build tools

## Setup

### Install Nix

`curl https://nixos.org/nix/install | sh`

https://nixos.org/

### Install Home Manager

https://github.com/rycee/home-manager

### Install dotfiles

Make a clone of this repository in your home folder. This will be the source of truth for configurations in your workspace.

`git clone https://github.com/mlwarner/dotfiles.git $HOME`

Copy the home-manager configuration into your XDG configuration directory.

`cp ~/dotfiles/nix/.config/nixpkgs/home.nix ~/.config/nixpkgs/home.nix`

## Usage

This configuration works by creating symlinks to your dotfiles directory, your "source of truth" if you will. So anytime you need to modify your workspace you should change the dotfiles and update the home-manager configuration `~/.config/nixpkgs/home.nix`

After making a change, you build the change into your workspace:

`home-manager switch`
