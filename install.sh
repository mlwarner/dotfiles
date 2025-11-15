#!/usr/bin/env bash

# Dotfiles installation script
# Automatically stows all configuration directories

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# List of stow packages (directories to symlink)
PACKAGES=(
    "ghostty"
    "git"
    "neovim"
    "vscode"
)

# Parse flags
RESTOW=false
if [[ "$1" == "-r" ]] || [[ "$1" == "--restow" ]]; then
    RESTOW=true
fi

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: GNU Stow is not installed${NC}"
    echo "Please install stow first:"
    echo "  macOS:  brew install stow"
    echo "  Linux:  sudo apt install stow  # or your package manager"
    exit 1
fi

# Ensure we're in the dotfiles directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${GREEN}Setting up dotfiles...${NC}"
echo

# Stow each package
for package in "${PACKAGES[@]}"; do
    if [[ ! -d "$package" ]]; then
        echo -e "${YELLOW}Warning: Package '$package' not found, skipping${NC}"
        continue
    fi

    if [[ "$RESTOW" == true ]]; then
        echo "Restowing $package..."
        stow -R "$package"
    else
        echo "Stowing $package..."
        stow "$package"
    fi
done

echo
echo -e "${GREEN}✓ Dotfiles installation complete!${NC}"
echo
echo "Installed packages: ${PACKAGES[*]}"
echo
echo "To update symlinks in the future, run:"
echo "  ./install.sh --restow"
