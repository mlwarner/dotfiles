# Dotfiles

## Description

This is a collection of my different configurations I use. I've attempted to 
create a reproducible setup across machines by:

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

Make a clone of this repository in your home folder. This will be the source of
truth for configurations in your workspace.

`git clone https://github.com/mlwarner/dotfiles.git $HOME`

Run the installation script which will symlink the nix configuration.

`cd $HOME/dotfiles`
`./install.sh`

## Usage

All of the tooling is managed using home manager. You can see the configuration with

`home-manager edit`

The configurations live inside `~/dotfiles/nix/.config/nixpkgs` which are 
symlinked to your local folder. When you are done making changes just switch to
the latest version of your configuration.

`home-manager switch`
