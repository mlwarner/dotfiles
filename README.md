# dotfiles

Personal configuration files managed with GNU Stow. Includes configurations for Neovim, Git, Ghostty, and VS Code.

## Quick Start

1. **Clone this repository**
   ```sh
   git clone https://github.com/mlwarner/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script**
   ```sh
   ./install.sh --all
   ```

That's it! The script will install all dependencies and symlink your configurations.

## Installation Options

```sh
./install.sh --all         # Install dependencies + stow configs (recommended)
./install.sh               # Stow configs only (requires stow already installed)
./install.sh --deps-only   # Install dependencies only
./install.sh --restow      # Update existing symlinks
./install.sh --help        # Show all options
```

## What Gets Installed

**Packages:**
- stow, fzf, ripgrep, neovim, starship, git, tree-sitter, tmux, fd, node, zoxide

**Configurations:**
- **Neovim** - Mini.nvim-based configuration with LSP, Treesitter, and semantic keybindings
- **Git** - Aliases and global ignore patterns
- **Ghostty** - Terminal emulator configuration
- **VS Code** - Settings with Vim mode enabled

## Selective Installation

Install specific configurations only:
```sh
cd ~/dotfiles
stow neovim  # Install only Neovim config
stow git     # Install only Git config
```

