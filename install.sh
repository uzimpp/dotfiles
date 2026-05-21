#!/bin/bash

# Dotfiles Installation Script
# Installs CLI dependencies via the platform's native package manager
# (Homebrew on macOS, apt on Debian/Ubuntu/WSL). GUI apps and fonts are
# installed only on macOS; install them manually on Linux/WSL.

set -e

# ============================================================================
# OS Detection
# ============================================================================
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *) echo "unsupported" ;;
    esac
}

OS="$(detect_os)"

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
    "tmux"
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
    "ghostty"
    "wezterm"
    "visual-studio-code"
    "arc"
    "raycast"
    "1password"
    "docker"
    "postman"
    "discord"
    "notion"
    "figma"
    "spotify"
)

# Nerd Fonts
FONTS=(
    "font-jetbrains-mono-nerd-font"
    "font-geist-mono-nerd-font"
)

# Map our canonical package names to apt package names.
# Empty stdout means "no apt package — install manually if needed".
# Defined as a function (not associative array) for bash 3.2 compatibility on macOS.
apt_name_for() {
    case "$1" in
        git)       echo git ;;
        zsh)       echo zsh ;;
        neovim)    echo neovim ;;
        tmux)      echo tmux ;;
        fzf)       echo fzf ;;
        zoxide)    echo zoxide ;;
        eza)       echo eza ;;
        bat)       echo bat ;;           # binary may be 'batcat' on older Ubuntu
        fd)        echo fd-find ;;       # binary is 'fdfind' on Debian/Ubuntu
        ripgrep)   echo ripgrep ;;
        delta)     echo git-delta ;;
        htop)      echo htop ;;
        tree)      echo tree ;;
        jq)        echo jq ;;
        tldr)      echo tldr ;;
        node)      echo nodejs ;;
        python)    echo python3 ;;
        go)        echo golang ;;
        lua)       echo lua5.4 ;;
        luarocks)  echo luarocks ;;
        cmake)     echo cmake ;;
        make)      echo make ;;
        gcc)       echo gcc ;;
        # Tools with no apt package — caller prints a manual-install notice:
        # starship (handled separately), yq, thefuck, wezterm, lazygit, rust
        *)         echo "" ;;
    esac
}

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
    if [ "$OS" = "macos" ]; then
        for app in "${APPS[@]}"; do
            if brew list --cask "$app" &>/dev/null 2>&1; then
                print_success "$app"
            else
                print_info "$app"
            fi
        done
    else
        print_info "GUI apps not auto-installed on $OS (install manually)"
    fi

    print_header "Fonts (--fonts)"
    if [ "$OS" = "macos" ]; then
        for font in "${FONTS[@]}"; do
            if brew list --cask "$font" &>/dev/null 2>&1; then
                print_success "$font"
            else
                print_info "$font"
            fi
        done
    else
        print_info "Fonts not auto-installed on $OS (install Nerd Fonts manually)"
    fi
    echo ""
}

install_homebrew() {
    # Only run on macOS; Linux/WSL use apt.
    [ "$OS" = "macos" ] || return 0

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

# apt-get install wrapper. Uses sudo if not already root.
apt_install() {
    local pkg="$1"
    local sudo_cmd=""
    [ "$(id -u)" -ne 0 ] && sudo_cmd="sudo"
    DEBIAN_FRONTEND=noninteractive $sudo_cmd apt-get install -y "$pkg"
}

apt_update_once() {
    # Only refresh package index once per script run.
    [ "$APT_UPDATED" = true ] && return 0
    [ "$DRY_RUN" = true ] && { APT_UPDATED=true; return 0; }
    local sudo_cmd=""
    [ "$(id -u)" -ne 0 ] && sudo_cmd="sudo"
    print_step "Updating apt package lists..."
    $sudo_cmd apt-get update -qq || print_warning "apt-get update failed"
    APT_UPDATED=true
}

# Install starship via its official installer (no apt package).
install_starship_official() {
    command -v starship &>/dev/null && { print_success "starship (already installed)"; return 0; }
    if [ "$DRY_RUN" = true ]; then
        print_step "[DRY RUN] Would install starship via official installer"
    else
        print_step "Installing starship via official installer..."
        curl -fsSL https://starship.rs/install.sh | sh -s -- --yes \
            || print_warning "Failed to install starship"
    fi
}

# Install one formula on the current OS.
install_one_formula() {
    local pkg="$1"

    if [ "$OS" = "macos" ]; then
        if brew list "$pkg" &>/dev/null 2>&1; then
            print_success "$pkg (already installed)"
        elif [ "$DRY_RUN" = true ]; then
            print_step "[DRY RUN] Would install: $pkg"
        else
            print_step "Installing $pkg..."
            brew install "$pkg" || print_warning "Failed to install $pkg"
        fi
        return 0
    fi

    # Linux / WSL path: use apt with mapped name, or special-case.
    if [ "$pkg" = "starship" ]; then
        install_starship_official
        return 0
    fi

    local apt_name
    apt_name="$(apt_name_for "$pkg")"
    if [ -z "$apt_name" ]; then
        print_warning "$pkg (no apt package — install manually)"
        return 0
    fi

    if dpkg -s "$apt_name" &>/dev/null; then
        print_success "$pkg (already installed)"
    elif [ "$DRY_RUN" = true ]; then
        print_step "[DRY RUN] Would install: $apt_name (for $pkg)"
    else
        apt_update_once
        print_step "Installing $apt_name (for $pkg)..."
        apt_install "$apt_name" || print_warning "Failed to install $apt_name"
    fi
}

install_formulas() {
    local name="$1"
    shift
    print_header "Installing $name"
    for pkg in "$@"; do
        install_one_formula "$pkg"
    done
}

install_casks() {
    local name="$1"
    shift
    local casks=("$@")

    # Casks are macOS-only (Homebrew). Linux/WSL: print notice and skip.
    if [ "$OS" != "macos" ]; then
        print_header "Skipping $name"
        print_info "GUI apps are not auto-installed on $OS — install them manually."
        return 0
    fi

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

    print_info "Detected OS: $OS"

    if [ "$OS" = "unsupported" ]; then
        print_error "Unsupported OS. This script supports macOS, Linux (apt), and WSL."
        exit 1
    fi

    if [ "$DRY_RUN" = true ]; then
        print_warning "DRY RUN MODE - No changes will be made"
    fi

    # macOS-only: install/update Homebrew and add the font tap.
    if [ "$OS" = "macos" ]; then
        install_homebrew

        print_header "Updating Homebrew"
        if [ "$DRY_RUN" = false ]; then
            brew update
        fi

        if [ "$INSTALL_FONTS" = true ] || [ "$INSTALL_ALL" = true ]; then
            if [ "$DRY_RUN" = false ]; then
                brew tap homebrew/cask-fonts 2>/dev/null || true
            fi
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

        # Reload WezTerm (macOS only — on Linux/WSL WezTerm typically runs elsewhere or not at all)
        if [ "$OS" = "macos" ] && command -v wezterm &>/dev/null && pgrep -f "wezterm" &>/dev/null; then
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

