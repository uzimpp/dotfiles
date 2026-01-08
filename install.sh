#!/bin/bash

# Dotfiles Installation Script
# This script installs all dependencies and applications via Homebrew

set -e

# ============================================================================
# Colors and Formatting
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

CHECK="✓"
CROSS="✗"
ARROW="→"
WARN="⚠"
INFO="ℹ"

print_header() {
    echo ""
    echo -e "${BOLD}${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}$(printf '=%.0s' {1..60})${NC}"
}

print_success() { echo -e "${GREEN}${CHECK}${NC} $1"; }
print_error() { echo -e "${RED}${CROSS}${NC} $1"; }
print_warning() { echo -e "${YELLOW}${WARN}${NC} $1"; }
print_info() { echo -e "${CYAN}${INFO}${NC} $1"; }
print_step() { echo -e "${BLUE}${ARROW}${NC} $1"; }

# ============================================================================
# Configuration
# ============================================================================
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
INSTALL_ALL=false
INSTALL_DEV=false
INSTALL_APPS=false
INSTALL_FONTS=false

# ============================================================================
# Dependency Lists
# ============================================================================

# Essential CLI tools (always installed)
ESSENTIAL=(
    "git"
    "zsh"
    "neovim"
    "starship"
)

# Terminal & Shell enhancements
TERMINAL=(
    "wezterm"
    "fzf"
    "zoxide"
    "eza"
    "bat"
    "fd"
    "ripgrep"
    "delta"
    "lazygit"
    "htop"
    "tree"
    "jq"
    "yq"
    "tldr"
    "thefuck"
)

# Development tools
DEVELOPMENT=(
    "node"
    "python"
    "go"
    "rust"
    "lua"
    "luarocks"
    "cmake"
    "make"
    "gcc"
)

# GUI Applications (casks)
APPS=(
    "wezterm"
    "visual-studio-code"
    "discord"
    "slack"
    "notion"
    "figma"
    "spotify"
    "arc"
    "raycast"
    "1password"
    "docker"
    "postman"
    "tableplus"
)

# Nerd Fonts
FONTS=(
    "font-jetbrains-mono-nerd-font"
    "font-geist-mono-nerd-font"
    "font-fira-code-nerd-font"
    "font-hack-nerd-font"
    "font-meslo-lg-nerd-font"
    "font-sf-mono-nerd-font"
)

# ============================================================================
# Functions
# ============================================================================

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all, -a         Install everything"
    echo "  --dev, -d         Install development tools"
    echo "  --apps            Install GUI applications"
    echo "  --fonts, -f       Install Nerd Fonts"
    echo "  --dry-run, -n     Show what would be installed"
    echo "  --list, -l        List all available packages"
    echo "  --help, -h        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                # Install essential + terminal tools"
    echo "  $0 --all          # Install everything"
    echo "  $0 --dev --fonts  # Install dev tools and fonts"
    echo "  $0 --apps         # Install GUI apps only"
    echo "  $0 --list         # Show all packages"
}

list_packages() {
    echo ""
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║              Available Packages                            ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    
    print_header "Essential (always installed)"
    for pkg in "${ESSENTIAL[@]}"; do
        if command -v "$pkg" &>/dev/null || [ "$pkg" = "neovim" ] && command -v nvim &>/dev/null; then
            print_success "$pkg"
        else
            print_info "$pkg"
        fi
    done
    
    print_header "Terminal & Shell"
    for pkg in "${TERMINAL[@]}"; do
        local cmd="$pkg"
        [[ "$pkg" == "ripgrep" ]] && cmd="rg"
        [[ "$pkg" == "fd" ]] && cmd="fd"
        if command -v "$cmd" &>/dev/null; then
            print_success "$pkg"
        else
            print_info "$pkg"
        fi
    done
    
    print_header "Development (--dev)"
    for pkg in "${DEVELOPMENT[@]}"; do
        if command -v "$pkg" &>/dev/null; then
            print_success "$pkg"
        else
            print_info "$pkg"
        fi
    done
    
    print_header "Applications (--apps)"
    for app in "${APPS[@]}"; do
        if brew list --cask "$app" &>/dev/null 2>&1; then
            print_success "$app"
        else
            print_info "$app"
        fi
    done
    
    print_header "Fonts (--fonts)"
    for font in "${FONTS[@]}"; do
        if brew list --cask "$font" &>/dev/null 2>&1; then
            print_success "$font"
        else
            print_info "$font"
        fi
    done
    echo ""
}

install_homebrew() {
    if ! command -v brew &>/dev/null; then
        print_header "Installing Homebrew"
        if [ "$DRY_RUN" = true ]; then
            print_step "[DRY RUN] Would install Homebrew"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for Apple Silicon
            if [[ $(uname -m) == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi
    else
        print_success "Homebrew is already installed"
    fi
}

install_formulas() {
    local name="$1"
    shift
    local packages=("$@")
    
    print_header "Installing $name"
    
    local to_install=()
    for pkg in "${packages[@]}"; do
        if brew list "$pkg" &>/dev/null 2>&1; then
            print_success "$pkg (already installed)"
        else
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -gt 0 ]; then
        if [ "$DRY_RUN" = true ]; then
            for pkg in "${to_install[@]}"; do
                print_step "[DRY RUN] Would install: $pkg"
            done
        else
            for pkg in "${to_install[@]}"; do
                print_step "Installing $pkg..."
                brew install "$pkg" || print_warning "Failed to install $pkg"
            done
        fi
    fi
}

install_casks() {
    local name="$1"
    shift
    local casks=("$@")
    
    print_header "Installing $name"
    
    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null 2>&1; then
            print_success "$cask (already installed)"
        else
            if [ "$DRY_RUN" = true ]; then
                print_step "[DRY RUN] Would install: $cask"
            else
                print_step "Installing $cask..."
                brew install --cask "$cask" || print_warning "Failed to install $cask"
            fi
        fi
    done
}

# ============================================================================
# Parse Arguments
# ============================================================================
while [[ $# -gt 0 ]]; do
    case $1 in
        --all|-a)
            INSTALL_ALL=true
            shift
            ;;
        --dev|-d)
            INSTALL_DEV=true
            shift
            ;;
        --apps)
            INSTALL_APPS=true
            shift
            ;;
        --fonts|-f)
            INSTALL_FONTS=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --list|-l)
            list_packages
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# ============================================================================
# Main
# ============================================================================
main() {
    echo ""
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║              Dotfiles Installer                            ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "DRY RUN MODE - No changes will be made"
    fi
    
    # Install Homebrew first
    install_homebrew
    
    # Update Homebrew
    print_header "Updating Homebrew"
    if [ "$DRY_RUN" = false ]; then
        brew update
    fi
    
    # Add font tap
    if [ "$INSTALL_FONTS" = true ] || [ "$INSTALL_ALL" = true ]; then
        if [ "$DRY_RUN" = false ]; then
            brew tap homebrew/cask-fonts 2>/dev/null || true
        fi
    fi
    
    # Always install essentials and terminal tools
    install_formulas "Essential Tools" "${ESSENTIAL[@]}"
    install_formulas "Terminal & Shell" "${TERMINAL[@]}"
    
    # Optional installs based on flags
    if [ "$INSTALL_DEV" = true ] || [ "$INSTALL_ALL" = true ]; then
        install_formulas "Development Tools" "${DEVELOPMENT[@]}"
    fi
    
    if [ "$INSTALL_APPS" = true ] || [ "$INSTALL_ALL" = true ]; then
        install_casks "Applications" "${APPS[@]}"
    fi
    
    if [ "$INSTALL_FONTS" = true ] || [ "$INSTALL_ALL" = true ]; then
        install_casks "Nerd Fonts" "${FONTS[@]}"
    fi
    
    # Summary
    print_header "Installation Complete!"
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "This was a dry run - no changes were made"
        echo ""
        echo -e "${BOLD}Next Steps:${NC}"
        echo -e "  1. ${CYAN}Run without --dry-run to install${NC}"
    else
        print_success "All requested packages have been processed"
        
        # Reload WezTerm if it was installed and is running
        if command -v wezterm &>/dev/null && pgrep -f "wezterm" &>/dev/null; then
            wezterm cli reload-configuration 2>/dev/null && \
                print_success "WezTerm reloaded" || true
        fi
        
        echo ""
        echo -e "${BOLD}${GREEN}✓ Installation complete!${NC}"
        echo ""
        echo -e "${BOLD}Next Steps:${NC}"
        echo -e "  1. ${CYAN}Run setup:${NC} ${BOLD}./setup.sh${NC}"
        echo -e "  2. ${CYAN}Reload shell:${NC} ${BOLD}source ~/.zshrc${NC}"
        echo ""
    fi
}

main

