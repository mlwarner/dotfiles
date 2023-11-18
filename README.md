# dotfiles

## Description

This is a collection of my different configurations I use. I checkout this
repository and use GNU stow to symlink the layout of my folders.

## Setup

### Install Homebrew

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

### Install CLI packages

```sh
brew install node neovim starship stow fzf zoxide
```

### Install dotfiles

Make a clone of this repository in your home folder. This will be the source of
truth for configurations in your workspace.

`git clone https://github.com/mlwarner/dotfiles.git $HOME`

### Create symlinks

```
cd $HOME/dotfiles
stow .
```

