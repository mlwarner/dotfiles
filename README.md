# dotfiles

Personal configuration files managed with GNU Stow. Includes configurations for Neovim, Git, Ghostty, and VS Code.

## Quick Start

1. **Install dependencies**
   ```sh
   # macOS
   brew install stow node neovim starship fzf zoxide

   # Linux (Ubuntu/Debian)
   sudo apt install stow nodejs neovim fzf zoxide
   ```

2. **Clone this repository**
   ```sh
   git clone https://github.com/mlwarner/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

3. **Run the installation script**
   ```sh
   ./install.sh
   ```

That's it! All configurations are now symlinked to the appropriate locations.

## Updating

To update symlinks after making changes:
```sh
./install.sh --restow
```

## What's Included

- **Neovim** - Mini.nvim-based configuration with LSP, Treesitter, and semantic keybindings
- **Git** - Aliases and global ignore patterns
- **Ghostty** - Terminal emulator configuration
- **VS Code** - Settings with Vim mode enabled

## Manual Installation

If you prefer to selectively install configurations:
```sh
cd ~/dotfiles
stow neovim  # Install only Neovim config
stow git     # Install only Git config
```

