#!/usr/bin/env bash

# Dotfiles installation script
# Automatically installs dependencies and stows all configuration directories

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required packages
BREW_PACKAGES=(
    "stow"
    "fzf"
    "ripgrep"
    "neovim"
    "starship"
    "git"
    "tree-sitter"
    "tmux"
    "fd"
    "node"
    "zoxide"
)

APT_PACKAGES=(
    "stow"
    "fzf"
    "ripgrep"
    "neovim"
    "git"
    "tmux"
    "fd-find"
    "nodejs"
)

# List of stow packages (directories to symlink)
STOW_PACKAGES=(
    "ghostty"
    "git"
    "neovim"
    "vscode"
)

# Parse flags
INSTALL_DEPS=false
DEPS_ONLY=false
RESTOW=false

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -d, --deps          Install dependencies before stowing"
    echo "  -D, --deps-only     Only install dependencies, skip stowing"
    echo "  -r, --restow        Restow packages (update existing symlinks)"
    echo "  -a, --all           Install dependencies and stow configs"
    echo
    echo "Examples:"
    echo "  $0                  Stow configs only"
    echo "  $0 --all            Install deps and stow configs"
    echo "  $0 --deps-only      Only install dependencies"
    echo "  $0 --restow         Update existing symlinks"
}

for arg in "$@"; do
    case $arg in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--deps)
            INSTALL_DEPS=true
            ;;
        -D|--deps-only)
            INSTALL_DEPS=true
            DEPS_ONLY=true
            ;;
        -r|--restow)
            RESTOW=true
            ;;
        -a|--all)
            INSTALL_DEPS=true
            ;;
        *)
            echo -e "${RED}Unknown option: $arg${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Install dependencies
install_dependencies() {
    local platform=$(detect_platform)

    echo -e "${BLUE}Installing dependencies...${NC}"
    echo

    if [[ "$platform" == "macos" ]]; then
        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        echo "Installing packages via Homebrew..."
        for package in "${BREW_PACKAGES[@]}"; do
            if brew list "$package" &> /dev/null; then
                echo -e "${GREEN}✓${NC} $package (already installed)"
            else
                echo "Installing $package..."
                brew install "$package"
            fi
        done

        # Install starship separately if not in brew packages
        if ! command -v starship &> /dev/null; then
            echo "Installing starship..."
            brew install starship
        fi

        # Install zoxide separately if not in brew packages
        if ! command -v zoxide &> /dev/null; then
            echo "Installing zoxide..."
            brew install zoxide
        fi

    elif [[ "$platform" == "linux" ]]; then
        echo "Installing packages via apt..."
        sudo apt update

        for package in "${APT_PACKAGES[@]}"; do
            if dpkg -l | grep -q "^ii  $package "; then
                echo -e "${GREEN}✓${NC} $package (already installed)"
            else
                echo "Installing $package..."
                sudo apt install -y "$package"
            fi
        done

        # Install starship via curl (not in standard apt repos)
        if ! command -v starship &> /dev/null; then
            echo "Installing starship..."
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        fi

        # Install zoxide via curl (may not be in older apt repos)
        if ! command -v zoxide &> /dev/null; then
            echo "Installing zoxide..."
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        fi

    else
        echo -e "${RED}Unsupported platform: $platform${NC}"
        echo "Please install dependencies manually"
        exit 1
    fi

    echo
    echo -e "${GREEN}✓ Dependencies installed successfully!${NC}"
    echo
}

# Main installation logic
main() {
    # Ensure we're in the dotfiles directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"

    # Install dependencies if requested
    if [[ "$INSTALL_DEPS" == true ]]; then
        install_dependencies
    fi

    # Exit if only installing dependencies
    if [[ "$DEPS_ONLY" == true ]]; then
        exit 0
    fi

    # Check if stow is installed (needed for stowing)
    if ! command -v stow &> /dev/null; then
        echo -e "${RED}Error: GNU Stow is not installed${NC}"
        echo "Run with --deps or --all to install dependencies automatically:"
        echo "  ./install.sh --all"
        echo
        echo "Or install manually:"
        echo "  macOS:  brew install stow"
        echo "  Linux:  sudo apt install stow"
        exit 1
    fi

    echo -e "${GREEN}Setting up dotfiles...${NC}"
    echo

    # Stow each package
    for package in "${STOW_PACKAGES[@]}"; do
        if [[ ! -d "$package" ]]; then
            echo -e "${YELLOW}Warning: Package '$package' not found, skipping${NC}"
            continue
        fi

        if [[ "$RESTOW" == true ]]; then
            echo "Restowing $package..."
            stow -R "$package"
        else
            echo "Stowing $package..."
            stow "$package" 2>/dev/null || stow -R "$package"
        fi
    done

    echo
    echo -e "${GREEN}✓ Dotfiles installation complete!${NC}"
    echo
    echo "Stowed packages: ${STOW_PACKAGES[*]}"
    echo
    echo "Useful commands:"
    echo "  ./install.sh --restow     Update symlinks"
    echo "  ./install.sh --deps-only  Install/update dependencies"
    echo "  ./install.sh --help       Show all options"
}

main
