#!/bin/bash

# Dotfiles Setup Script
# This script creates symlinks from the dotfiles directory to the correct config locations
# For installing dependencies, use ./install.sh

set -e  # Exit on error

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
    echo -e "${MAGENTA}$(printf '=%.0s' {1..50})${NC}"
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
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
BACKUP=true

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --no-backup)
            BACKUP=false
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run, -n   Show what would be done without making changes"
            echo "  --no-backup     Don't backup existing files"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0              # Setup symlinks with backups"
            echo "  $0 --dry-run    # Preview changes"
            echo "  $0 --no-backup  # Setup without backups"
            echo ""
            echo "For installing dependencies, use: ./install.sh"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# ============================================================================
# Symlink Function
# ============================================================================
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ "$DRY_RUN" = true ]; then
        print_step "[DRY RUN] Would link: $target ${ARROW} $source"
        return
    fi
    
    # Backup existing file/directory
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ "$BACKUP" = true ]; then
            mkdir -p "$BACKUP_DIR"
            print_step "Backing up: $target"
            mv "$target" "$BACKUP_DIR/"
        else
            print_step "Removing: $target"
            rm -rf "$target"
        fi
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -s "$source" "$target"
    print_success "Linked: $(basename "$target")"
}

# ============================================================================
# Quick Dependency Check
# ============================================================================
check_essentials() {
    print_header "Checking Essentials"
    
    local missing=()
    local tools=("git" "nvim" "zsh")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &>/dev/null; then
            print_success "$tool"
        else
            print_error "$tool (missing)"
            missing+=("$tool")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo ""
        print_warning "Missing tools detected!"
        print_info "Run ./install.sh first to install dependencies"
    fi
}

# ============================================================================
# Main Setup
# ============================================================================
main() {
    echo ""
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║          Dotfiles Setup                            ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Dotfiles: $DOTFILES_DIR"
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "DRY RUN MODE - No changes will be made"
    fi
    
    if [ "$BACKUP" = true ] && [ "$DRY_RUN" = false ]; then
        print_info "Backups: $BACKUP_DIR"
    fi

    # Quick check
    check_essentials

    # WezTerm (must be in home directory)
    print_header "WezTerm"
    create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
    [ -f "$DOTFILES_DIR/wezterm/config.lua" ] && \
        create_symlink "$DOTFILES_DIR/wezterm/config.lua" "$HOME/config.lua"
    [ -f "$DOTFILES_DIR/wezterm/events.lua" ] && \
        create_symlink "$DOTFILES_DIR/wezterm/events.lua" "$HOME/events.lua"

    # Kitty
    print_header "Kitty"
    if [ -d "$DOTFILES_DIR/kitty" ]; then
        create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
    else
        print_info "Skipped (not found)"
    fi

    # Neovim
    print_header "Neovim"
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Starship
    print_header "Starship"
    if [ -f "$DOTFILES_DIR/starship/starship.toml" ]; then
        create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
    else
        print_info "Skipped (not found)"
    fi

    # Zsh
    print_header "Zsh"
    create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"

    # Setup shell config files (APPEND only, never overwrite existing content)
    print_header "Shell Configuration"
    if [ "$DRY_RUN" = false ]; then
        # ~/.zshenv - sources our environment variables
        ZSHENV_LINE='[ -f "$HOME/.config/zsh/.zshenv" ] && source "$HOME/.config/zsh/.zshenv"'
        if [ ! -f "$HOME/.zshenv" ]; then
            # File doesn't exist, create it
            echo "# Dotfiles environment" > "$HOME/.zshenv"
            echo "$ZSHENV_LINE" >> "$HOME/.zshenv"
            print_success "Created ~/.zshenv"
        elif ! grep -q ".config/zsh/.zshenv" "$HOME/.zshenv" 2>/dev/null; then
            # File exists but doesn't have our line, APPEND (don't overwrite)
            echo "" >> "$HOME/.zshenv"
            echo "# Dotfiles environment" >> "$HOME/.zshenv"
            echo "$ZSHENV_LINE" >> "$HOME/.zshenv"
            print_success "Appended to ~/.zshenv"
        else
            print_info "~/.zshenv already configured"
        fi

        # ~/.zshrc - sources our shell config
        ZSHRC_LINE='[ -f "$HOME/.config/zsh/.zshrc" ] && source "$HOME/.config/zsh/.zshrc"'
        if [ ! -f "$HOME/.zshrc" ]; then
            # File doesn't exist, create it
            echo "# Dotfiles shell config" > "$HOME/.zshrc"
            echo "$ZSHRC_LINE" >> "$HOME/.zshrc"
            print_success "Created ~/.zshrc"
        elif ! grep -q ".config/zsh/.zshrc" "$HOME/.zshrc" 2>/dev/null; then
            # File exists but doesn't have our line, APPEND (don't overwrite)
            echo "" >> "$HOME/.zshrc"
            echo "# Dotfiles shell config" >> "$HOME/.zshrc"
            echo "$ZSHRC_LINE" >> "$HOME/.zshrc"
            print_success "Appended to ~/.zshrc"
        else
            print_info "~/.zshrc already configured"
        fi
    else
        print_step "[DRY RUN] Would append to ~/.zshenv and ~/.zshrc (never overwrites)"
    fi

    # Verification
    print_header "Verification"
    local files=(
        "$HOME/.wezterm.lua:WezTerm"
        "$HOME/.config/nvim/init.lua:Neovim"
        "$HOME/.config/zsh/.zshrc:Zsh"
    )
    
    for item in "${files[@]}"; do
        local file="${item%:*}"
        local name="${item#*:}"
        if [ -e "$file" ] || [ -L "$file" ]; then
            print_success "$name"
        else
            print_error "$name"
        fi
    done

    # Summary
    print_header "Complete!"
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "Dry run - no changes made"
        print_info "Run without --dry-run to apply"
    else
        print_success "All configurations linked!"
        [ -d "$BACKUP_DIR" ] && print_info "Backups: $BACKUP_DIR"
        
        # Auto-reload everything
        print_header "Reloading..."
        
        # Reload WezTerm if running
        if command -v wezterm &>/dev/null && pgrep -f "wezterm" &>/dev/null; then
            wezterm cli reload-configuration 2>/dev/null && \
                print_success "WezTerm reloaded" || \
                print_info "WezTerm: restart manually"
        fi
        
        # Reload Starship (just needs shell reload)
        if command -v starship &>/dev/null; then
            print_success "Starship will reload with shell"
        fi
        
        # Source the new shell config
        print_info "Sourcing shell configuration..."
        
        echo ""
        echo -e "${BOLD}${GREEN}✓ Setup complete!${NC}"
        echo ""
        echo -e "  ${CYAN}Theme:${NC} anysphere (change with: ${BOLD}theme <name>${NC})"
        echo -e "  ${CYAN}Themes:${NC} anysphere, catppuccin, nord, nordic, onedark"
        echo ""
        echo -e "${YELLOW}${WARN}${NC} ${BOLD}Run this to apply shell changes:${NC}"
        echo -e "    ${CYAN}source ~/.zshrc${NC}"
        echo ""
    fi
}

main
