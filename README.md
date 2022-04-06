# dotfiles

## Description

This is a collection of my different configurations I use. I've attempted to 
create a reproducible setup across machines by:

- Creating a collection of dotfiles which contain my configurations
- Using Nix flakes for reproducible build environments (tooling)
- Using Home Manager to vend the configuration and build tools

## Setup

### Install Nix

`curl https://nixos.org/nix/install | sh`

https://nixos.org/

### Install dotfiles

Make a clone of this repository in your home folder. This will be the source of
truth for configurations in your workspace.

`git clone https://github.com/mlwarner/dotfiles.git $HOME`

## Usage

`nix flake update "Dotfiles/." && home-manager switch --flake '/Users/mwarner/Dotfiles/.#mwarner'`

