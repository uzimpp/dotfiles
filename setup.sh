#!/bin/bash

# Dotfiles Setup Script
# Creates symlinks from this repo to the correct config locations and offers
# to install any missing dependencies. For installing dependencies directly,
# use ./install.sh.
#
# Supports macOS, Linux, WSL and native Windows (run under Git Bash, usually
# via bootstrap.ps1). The flow is interactive: a setup-type menu followed by
# four checkbox screens (CLI Tools, Applications, Fonts, Configs).

set -e # Exit on error

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
        MINGW* | MSYS* | CYGWIN*) echo "windows" ;;
        *) echo "unsupported" ;;
    esac
}

OS="$(detect_os)"

# On native Windows, make Git Bash `ln -s` create real Windows symlinks.
# (Requires Developer Mode or admin; create_symlink() falls back to a copy.)
[ "$OS" = "windows" ] && export MSYS=winsymlinks:nativestrict

# ============================================================================
# Configuration
# ============================================================================
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
BACKUP=true
RECONFIGURE=false
WIN_HOME=""

# Selections (populated interactively or loaded from the saved config).
SETUP_PROFILE=""
SELECTED_TOOLS=""
SELECTED_APPS=""
SELECTED_FONTS=""
SELECTED_CONFIGS=""

# Saved preferences live in ~/.config/dotfiles/config (one per host).
DOTFILES_CONF_DIR="$HOME/.config/dotfiles"
DOTFILES_CONF_FILE="$DOTFILES_CONF_DIR/config"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run | -n)
            DRY_RUN=true
            shift
            ;;
        --no-backup)
            BACKUP=false
            shift
            ;;
        --reconfigure)
            RECONFIGURE=true
            shift
            ;;
        --help | -h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run, -n    Show what would be done without making changes"
            echo "  --no-backup      Don't backup existing files"
            echo "  --reconfigure    Re-run the interactive menus and overwrite saved config"
            echo "  --help, -h       Show this help message"
            echo ""
            echo "On first run (or with --reconfigure), setup walks an interactive"
            echo "setup-type menu and four checkbox screens (CLI Tools, Applications,"
            echo "Fonts, Configs). Choices are saved to ~/.config/dotfiles/config and"
            echo "reused on subsequent runs."
            echo ""
            echo "Examples:"
            echo "  $0                # Setup symlinks (interactive on first run)"
            echo "  $0 --dry-run      # Preview changes"
            echo "  $0 --reconfigure  # Re-pick environment, tools and configs"
            echo ""
            echo "For installing dependencies directly, use: ./install.sh"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Reuse install.sh's package lists and install functions as a single source of
# truth. install.sh guards main() behind a BASH_SOURCE check, so sourcing it
# only defines functions/arrays — it does not run an install. DRY_RUN is
# exported first so the sourced functions honour it.
export DRY_RUN
# shellcheck source=install.sh
source "$DOTFILES_DIR/install.sh"

# ============================================================================
# Colors and Formatting
# ============================================================================
# Defined after sourcing install.sh so these win over the near-identical
# definitions install.sh also provides.
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
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
# Cursor / interrupt handling for the interactive menus
# ============================================================================
_show_cursor() { printf '\033[?25h'; }
_on_interrupt() { _show_cursor; echo ""; print_warning "Interrupted."; exit 130; }
trap _show_cursor EXIT
trap _on_interrupt INT TERM

# ============================================================================
# Saved Configuration File
# ============================================================================
load_config() {
    [ -f "$DOTFILES_CONF_FILE" ] || return 1
    # shellcheck disable=SC1090
    source "$DOTFILES_CONF_FILE"
    # An old-format config (COMPONENT_* keys, no SETUP_PROFILE) is treated as
    # absent so the new interactive flow runs.
    [ -n "$SETUP_PROFILE" ] || return 1
    return 0
}

save_config() {
    mkdir -p "$DOTFILES_CONF_DIR"
    {
        echo "# Dotfiles setup preferences (generated by setup.sh)"
        echo "# Re-run with --reconfigure to change."
        echo "OS_AT_SETUP=\"$OS\""
        echo "SETUP_PROFILE=\"$SETUP_PROFILE\""
        echo "WIN_HOME=\"$WIN_HOME\""
        echo "SELECTED_TOOLS=\"$SELECTED_TOOLS\""
        echo "SELECTED_APPS=\"$SELECTED_APPS\""
        echo "SELECTED_FONTS=\"$SELECTED_FONTS\""
        echo "SELECTED_CONFIGS=\"$SELECTED_CONFIGS\""
    } > "$DOTFILES_CONF_FILE"
}

# ============================================================================
# WSL: detect the Windows %USERPROFILE% mounted under /mnt/c
# ============================================================================
detect_windows_home() {
    # Try cmd.exe first (most reliable on modern WSL).
    local win_userprofile
    win_userprofile="$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')"

    if [ -n "$win_userprofile" ] && command -v wslpath &>/dev/null; then
        wslpath "$win_userprofile" 2>/dev/null
        return 0
    fi

    # Fallback: scan /mnt/c/Users for a single non-system user dir.
    if [ -d /mnt/c/Users ]; then
        local candidate
        candidate=$(find /mnt/c/Users -mindepth 1 -maxdepth 1 -type d \
            ! -name 'Public' ! -name 'Default*' ! -name 'All Users' \
            ! -name 'desktop.ini' 2>/dev/null | head -1)
        [ -n "$candidate" ] && echo "$candidate" && return 0
    fi

    echo ""
}

# ============================================================================
# Interactive Menu Primitives
# ============================================================================
# Shared globals (caller fills them, the menu reads/writes them):
#   MENU_ITEMS[]    - display labels
#   MENU_CHECKED[]  - "1"/"0" per item (checkbox state; written back in place)
#   MENU_DISABLED[] - "1"/"0" per item (disabled items are greyed, not selectable)
#   _MENU_NAMES[]   - canonical name per item (parallel to MENU_ITEMS)
# Outputs:
#   checkbox_menu -> final MENU_CHECKED state
#   radio_menu    -> MENU_RADIO_RESULT (selected index)

_menu_reset() { _MENU_NAMES=(); MENU_ITEMS=(); MENU_CHECKED=(); MENU_DISABLED=(); }

# _menu_add <canonical-name> <label> <disabled 0|1> <checked 0|1>
_menu_add() {
    _MENU_NAMES+=("$1")
    MENU_ITEMS+=("$2")
    MENU_DISABLED+=("$3")
    MENU_CHECKED+=("$4")
}

# Echo a space-separated list of canonical names whose checkbox is set.
_menu_selected() {
    local i out=""
    for i in "${!_MENU_NAMES[@]}"; do
        [ "${MENU_CHECKED[$i]}" = "1" ] && out="$out ${_MENU_NAMES[$i]}"
    done
    echo "${out# }"
}

_menu_first_enabled() {
    local i
    for i in "${!MENU_ITEMS[@]}"; do
        [ "${MENU_DISABLED[$i]}" != "1" ] && { echo "$i"; return; }
    done
    echo 0
}

_menu_next_enabled() {
    local n="${#MENU_ITEMS[@]}" i="$_menu_cursor" tries=0
    while [ "$tries" -lt "$n" ]; do
        i=$(( (i + 1) % n ))
        tries=$(( tries + 1 ))
        [ "${MENU_DISABLED[$i]}" != "1" ] && { echo "$i"; return; }
    done
    echo "$_menu_cursor"
}

_menu_prev_enabled() {
    local n="${#MENU_ITEMS[@]}" i="$_menu_cursor" tries=0
    while [ "$tries" -lt "$n" ]; do
        i=$(( (i - 1 + n) % n ))
        tries=$(( tries + 1 ))
        [ "${MENU_DISABLED[$i]}" != "1" ] && { echo "$i"; return; }
    done
    echo "$_menu_cursor"
}

_menu_toggle() {
    [ "${MENU_DISABLED[$_menu_cursor]}" = "1" ] && return 0
    if [ "${MENU_CHECKED[$_menu_cursor]}" = "1" ]; then
        MENU_CHECKED[$_menu_cursor]=0
    else
        MENU_CHECKED[$_menu_cursor]=1
    fi
}

_menu_set_all() {
    local v="$1" i
    for i in "${!MENU_ITEMS[@]}"; do
        [ "${MENU_DISABLED[$i]}" = "1" ] && continue
        MENU_CHECKED[$i]="$v"
    done
}

# Keep the cursor inside the visible window.
_menu_scroll_to_cursor() {
    if [ "$_menu_cursor" -lt "$_menu_top" ]; then
        _menu_top="$_menu_cursor"
    elif [ "$_menu_cursor" -gt $(( _menu_top + _menu_view - 1 )) ]; then
        _menu_top=$(( _menu_cursor - _menu_view + 1 ))
    fi
}

# Read one keypress, echo a normalized token.
_read_key() {
    local k rest
    IFS= read -rsn1 k 2>/dev/null || { echo "ENTER"; return; }
    case "$k" in
        '' | $'\n' | $'\r') echo "ENTER"; return ;;
        ' ')                echo "SPACE"; return ;;
        a | A)              echo "ALL";   return ;;
        n | N)              echo "NONE";  return ;;
        j | J)              echo "DOWN";  return ;;
        k | K)              echo "UP";    return ;;
    esac
    if [ "$k" = $'\033' ]; then
        IFS= read -rsn2 -t 1 rest 2>/dev/null || true
        case "$rest" in
            '[A' | 'OA') echo "UP";   return ;;
            '[B' | 'OB') echo "DOWN"; return ;;
        esac
        echo "OTHER"; return
    fi
    echo "OTHER"
}

_checkbox_line() {
    local i="$1"
    local checked="${MENU_CHECKED[$i]}" disabled="${MENU_DISABLED[$i]}"
    local label="${MENU_ITEMS[$i]}"
    local mark="[ ]"
    [ "$checked" = "1" ] && mark="[x]"
    if [ "$disabled" = "1" ]; then
        printf '\033[2K\r    %b[-] %s%b\n' "$DIM" "$label" "$NC"
    elif [ "$i" = "$_menu_cursor" ]; then
        printf '\033[2K\r  %b❯ %s %s%b\n' "$BOLD$CYAN" "$mark" "$label" "$NC"
    elif [ "$checked" = "1" ]; then
        printf '\033[2K\r    %b%s%b %s\n' "$GREEN" "$mark" "$NC" "$label"
    else
        printf '\033[2K\r    %s %s\n' "$mark" "$label"
    fi
}

_checkbox_render() {
    local i shown_end scroll=""
    shown_end=$(( _menu_top + _menu_view - 1 ))
    if [ "$_menu_view" -lt "${#MENU_ITEMS[@]}" ]; then
        scroll="  ($(( _menu_top + 1 ))-$(( shown_end + 1 )) of ${#MENU_ITEMS[@]})"
    fi
    printf '\033[2K\r  %b%s%b%b%s%b\n' "$BOLD$MAGENTA" "$_menu_title" "$NC" "$DIM" "$scroll" "$NC"
    for i in $(seq "$_menu_top" "$shown_end"); do
        _checkbox_line "$i"
    done
    printf '\033[2K\r  %b↑/↓ move · Space toggle · Enter confirm · a all · n none%b\n' "$DIM" "$NC"
}

# checkbox_menu <title> — interactive multi-select over MENU_* globals.
checkbox_menu() {
    _menu_title="$1"
    local n="${#MENU_ITEMS[@]}"
    [ "$n" -eq 0 ] && return 0

    if [ ! -t 0 ] || [ ! -t 1 ]; then
        print_info "$_menu_title — non-interactive, using defaults"
        return 0
    fi

    local term_lines
    term_lines="${LINES:-$(tput lines 2>/dev/null || echo 24)}"
    _menu_view=$(( term_lines - 5 ))
    [ "$_menu_view" -gt "$n" ] && _menu_view="$n"
    [ "$_menu_view" -lt 1 ] && _menu_view=1
    _menu_top=0
    _menu_cursor="$(_menu_first_enabled)"
    _menu_scroll_to_cursor
    local total=$(( _menu_view + 2 ))

    printf '\033[?25l'
    _checkbox_render
    local key
    while true; do
        key="$(_read_key)"
        case "$key" in
            UP)    _menu_cursor="$(_menu_prev_enabled)"; _menu_scroll_to_cursor ;;
            DOWN)  _menu_cursor="$(_menu_next_enabled)"; _menu_scroll_to_cursor ;;
            SPACE) _menu_toggle ;;
            ALL)   _menu_set_all 1 ;;
            NONE)  _menu_set_all 0 ;;
            ENTER) break ;;
        esac
        printf '\033[%dA' "$total"
        _checkbox_render
    done
    _show_cursor
}

_radio_render() {
    local i label
    printf '\033[2K\r  %b%s%b\n' "$BOLD$MAGENTA" "$_menu_title" "$NC"
    for i in "${!MENU_ITEMS[@]}"; do
        label="${MENU_ITEMS[$i]}"
        if [ "${MENU_DISABLED[$i]}" = "1" ]; then
            printf '\033[2K\r    %b( ) %s%b\n' "$DIM" "$label" "$NC"
        elif [ "$i" = "$_menu_cursor" ]; then
            printf '\033[2K\r  %b❯ (•) %s%b\n' "$BOLD$CYAN" "$label" "$NC"
        else
            printf '\033[2K\r    ( ) %s\n' "$label"
        fi
    done
    printf '\033[2K\r  %b↑/↓ move · Enter select%b\n' "$DIM" "$NC"
}

# radio_menu <title> — single-select. Caller presets _menu_cursor to the
# default index. Result is left in MENU_RADIO_RESULT.
radio_menu() {
    _menu_title="$1"
    MENU_RADIO_RESULT="$_menu_cursor"
    local n="${#MENU_ITEMS[@]}"
    [ "$n" -eq 0 ] && return 0

    if [ ! -t 0 ] || [ ! -t 1 ]; then
        print_info "$_menu_title — non-interactive, using default: ${MENU_ITEMS[$_menu_cursor]}"
        return 0
    fi

    local total=$(( n + 2 ))
    printf '\033[?25l'
    _radio_render
    local key
    while true; do
        key="$(_read_key)"
        case "$key" in
            UP)          _menu_cursor="$(_menu_prev_enabled)" ;;
            DOWN)        _menu_cursor="$(_menu_next_enabled)" ;;
            ENTER|SPACE) break ;;
        esac
        printf '\033[%dA' "$total"
        _radio_render
    done
    _show_cursor
    MENU_RADIO_RESULT="$_menu_cursor"
}

# ============================================================================
# Package availability per OS (drives which checkbox items are disabled)
# ============================================================================
# A CLI tool is "available" if there is an auto-install path on this OS.
tool_has_package() {
    case "$OS" in
        macos)      return 0 ;;
        windows)    [ -n "$(winget_name_for "$1")" ] ;;
        linux|wsl)
            [ "$1" = "starship" ] && return 0
            [ -n "$(apt_name_for "$1")" ]
            ;;
        *)          return 1 ;;
    esac
}

# A GUI app is "available" if there is an auto-install path on this OS.
app_has_package() {
    case "$OS" in
        macos)   return 0 ;;
        windows) [ -n "$(winget_name_for "$1")" ] ;;
        *)       return 1 ;;
    esac
}

# ============================================================================
# Installed-state detection (for the install hand-off)
# ============================================================================
# Map a canonical CLI name to the binary it would put on PATH.
tool_binary() {
    case "$1" in
        ripgrep) echo "rg" ;;
        neovim)  echo "nvim" ;;
        python)  echo "python3" ;;
        rust)    echo "rustc" ;;
        *)       echo "$1" ;;
    esac
}

is_tool_installed() {
    local pkg="$1"
    command -v "$pkg" &>/dev/null && return 0
    command -v "$(tool_binary "$pkg")" &>/dev/null && return 0
    # Debian/Ubuntu rename a couple of binaries.
    case "$pkg" in
        fd)  command -v fdfind  &>/dev/null && return 0 ;;
        bat) command -v batcat &>/dev/null && return 0 ;;
    esac
    return 1
}

# Detect an installed GUI app / font where the package manager allows it.
is_cask_installed() {
    local name="$1"
    if [ "$OS" = "macos" ]; then
        brew list --cask "$name" &>/dev/null 2>&1
    elif [ "$OS" = "windows" ]; then
        local id
        id="$(winget_name_for "$name")"
        [ -n "$id" ] && winget_is_installed "$id"
    else
        return 1
    fi
}

# ============================================================================
# Interactive flow — setup type + four checkbox screens
# ============================================================================
choose_profile() {
    print_header "Setup Type"
    _menu_reset
    local profiles=("macos" "linux" "wsl" "wsl-windows" "windows")
    MENU_ITEMS=("macOS" "Linux" "WSL (Linux side only)" "WSL + Windows host" "Windows (native)")
    MENU_DISABLED=(0 0 0 0 0)
    case "$OS" in
        macos)   _menu_cursor=0 ;;
        linux)   _menu_cursor=1 ;;
        wsl)     _menu_cursor=2 ;;
        windows) _menu_cursor=4 ;;
        *)       _menu_cursor=0 ;;
    esac
    radio_menu "Which environment are you setting up?"
    SETUP_PROFILE="${profiles[$MENU_RADIO_RESULT]}"
    print_success "Profile: $SETUP_PROFILE"
}

choose_cli_tools() {
    print_header "CLI Tools"
    _menu_reset
    local pkg
    # Essentials + terminal tools are checked by default; dev tools are opt-in.
    for pkg in "${ESSENTIAL[@]}" "${TERMINAL[@]}"; do
        if tool_has_package "$pkg"; then
            _menu_add "$pkg" "$pkg" 0 1
        else
            _menu_add "$pkg" "$pkg  (no package on $OS — install manually)" 1 0
        fi
    done
    for pkg in "${DEVELOPMENT[@]}"; do
        if tool_has_package "$pkg"; then
            _menu_add "$pkg" "$pkg  (dev)" 0 0
        else
            _menu_add "$pkg" "$pkg  (dev — no package on $OS)" 1 0
        fi
    done
    checkbox_menu "Select CLI tools to install"
    SELECTED_TOOLS="$(_menu_selected)"
    print_info "CLI tools selected: ${SELECTED_TOOLS:-none}"
}

choose_apps() {
    print_header "Applications"
    _menu_reset
    local app
    for app in "${APPS[@]}"; do
        if app_has_package "$app"; then
            _menu_add "$app" "$app" 0 0
        else
            _menu_add "$app" "$app  (no auto-install on $OS — install manually)" 1 0
        fi
    done
    checkbox_menu "Select GUI applications to install"
    SELECTED_APPS="$(_menu_selected)"
    print_info "Applications selected: ${SELECTED_APPS:-none}"
}

choose_fonts() {
    print_header "Fonts"
    _menu_reset
    local font
    for font in "${FONTS[@]}"; do
        if [ "$OS" = "macos" ]; then
            _menu_add "$font" "$font" 0 1
        else
            _menu_add "$font" "$font  (install manually on $OS)" 1 0
        fi
    done
    checkbox_menu "Select Nerd Fonts to install"
    SELECTED_FONTS="$(_menu_selected)"
    print_info "Fonts selected: ${SELECTED_FONTS:-none}"
}

choose_configs() {
    print_header "Configs"
    _menu_reset
    # Windows-capable configs (linked on every profile).
    _menu_add wezterm  "WezTerm"  0 1
    _menu_add nvim     "Neovim"   0 1
    _menu_add starship "Starship" 0 1
    if [ "$SETUP_PROFILE" = "windows" ]; then
        _menu_add powershell "PowerShell profile" 0 1
        _menu_add bashrc     "Git Bash .bashrc"   0 1
        _menu_add tmux    "tmux  (not applicable on Windows)"    1 0
        _menu_add zsh     "zsh  (not applicable on Windows)"     1 0
        _menu_add kitty   "Kitty  (not applicable on Windows)"   1 0
        _menu_add ghostty "Ghostty  (not applicable on Windows)" 1 0
    else
        _menu_add tmux "tmux" 0 1
        _menu_add zsh  "zsh"  0 1
        # Kitty/Ghostty have no real Windows build; on WSL they default off.
        local kc=1 gc=1
        case "$SETUP_PROFILE" in
            wsl|wsl-windows) kc=0; gc=0 ;;
        esac
        _menu_add kitty   "Kitty"   0 "$kc"
        _menu_add ghostty "Ghostty" 0 "$gc"
    fi
    checkbox_menu "Select configs to link"
    SELECTED_CONFIGS="$(_menu_selected)"
    print_info "Configs selected: ${SELECTED_CONFIGS:-none}"
}

run_interactive() {
    choose_profile

    # The "WSL + Windows host" profile needs the Windows %USERPROFILE%.
    if [ "$SETUP_PROFILE" = "wsl-windows" ]; then
        [ -z "$WIN_HOME" ] && WIN_HOME="$(detect_windows_home)"
        if [ -n "$WIN_HOME" ]; then
            print_info "Windows home: $WIN_HOME"
        else
            print_warning "Could not detect the Windows home — Windows-side links will be skipped."
        fi
    fi

    choose_cli_tools
    choose_apps
    choose_fonts
    choose_configs
}

# ============================================================================
# Install hand-off — install missing selected packages via install.sh
# ============================================================================
install_handoff() {
    print_header "Dependencies"

    local missing_tools=() missing_apps=() missing_fonts=()
    local t a f
    for t in $SELECTED_TOOLS; do
        is_tool_installed "$t" || missing_tools+=("$t")
    done
    for a in $SELECTED_APPS; do
        is_cask_installed "$a" || missing_apps+=("$a")
    done
    for f in $SELECTED_FONTS; do
        is_cask_installed "$f" || missing_fonts+=("$f")
    done

    local total=$(( ${#missing_tools[@]} + ${#missing_apps[@]} + ${#missing_fonts[@]} ))
    if [ "$total" -eq 0 ]; then
        print_success "All selected packages are already installed"
        return 0
    fi

    print_warning "$total selected package(s) not detected:"
    for t in "${missing_tools[@]}"; do print_info "  $t (CLI tool)"; done
    for a in "${missing_apps[@]}"; do print_info "  $a (application)"; done
    for f in "${missing_fonts[@]}"; do print_info "  $f (font)"; done

    if [ "$DRY_RUN" = true ]; then
        print_step "[DRY RUN] Would prompt to install $total package(s)"
        return 0
    fi
    if [ ! -t 0 ]; then
        print_info "Non-interactive — skipping install. Run ./install.sh to install them."
        return 0
    fi

    # The package manager itself is install.sh's job to provision.
    if [ "$OS" = "macos" ] && ! command -v brew &>/dev/null; then
        print_warning "Homebrew not found — run ./install.sh first to install packages."
        return 0
    fi
    if [ "$OS" = "windows" ] && ! command -v winget &>/dev/null; then
        print_warning "winget not found — run bootstrap.ps1 / install.sh first."
        return 0
    fi

    printf "  Install %d missing package(s)? [Y/n]: " "$total" >&2
    local answer
    read -r answer || answer=""
    case "$(printf '%s' "$answer" | tr '[:upper:]' '[:lower:]')" in
        n | no)
            print_info "Skipped install. Run ./install.sh later to install them."
            return 0
            ;;
    esac

    if [ "${#missing_tools[@]}" -gt 0 ]; then
        print_header "Installing CLI Tools"
        for t in "${missing_tools[@]}"; do
            install_one_formula "$t"
        done
    fi
    [ "${#missing_apps[@]}" -gt 0 ] && install_casks "Applications" "${missing_apps[@]}"
    [ "${#missing_fonts[@]}" -gt 0 ] && install_casks "Nerd Fonts" "${missing_fonts[@]}"
}

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

    # Backup or remove anything already at the target.
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

    mkdir -p "$(dirname "$target")"

    if ln -s "$source" "$target" 2>/dev/null; then
        print_success "Linked: $(basename "$target")"
    else
        # Native Windows symlinks need Developer Mode / admin. Fall back to a
        # copy so setup still works, but warn that edits won't propagate live.
        cp -r "$source" "$target"
        print_warning "Copied (not linked): $(basename "$target") — edits in the repo won't propagate; enable Developer Mode and re-run setup."
    fi
}

# ============================================================================
# Link-target helpers (derived from the chosen profile)
# ============================================================================
# Home directory for the Windows-capable configs (WezTerm, Neovim, Starship).
configs_home() {
    case "$SETUP_PROFILE" in
        wsl-windows) echo "$WIN_HOME" ;;
        *)           echo "$HOME" ;;
    esac
}

# Neovim's config directory differs between Unix and Windows layouts.
nvim_target() {
    local home
    home="$(configs_home)"
    case "$SETUP_PROFILE" in
        wsl-windows | windows) echo "$home/AppData/Local/nvim" ;;
        *)                     echo "$home/.config/nvim" ;;
    esac
}

# ============================================================================
# Per-config link functions
# ============================================================================
link_wezterm() {
    local home
    home="$(configs_home)"
    if [ -z "$home" ]; then
        print_warning "WezTerm: no target home for this profile — skipped"
        return
    fi
    [ -f "$DOTFILES_DIR/wezterm/.wezterm.lua" ] &&
        create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$home/.wezterm.lua"
    [ -f "$DOTFILES_DIR/wezterm/config.lua" ] &&
        create_symlink "$DOTFILES_DIR/wezterm/config.lua" "$home/config.lua"
    [ -f "$DOTFILES_DIR/wezterm/events.lua" ] &&
        create_symlink "$DOTFILES_DIR/wezterm/events.lua" "$home/events.lua"
}

link_nvim() {
    local target
    target="$(nvim_target)"
    if [ -z "$target" ]; then
        print_warning "Neovim: no target home for this profile — skipped"
        return
    fi
    create_symlink "$DOTFILES_DIR/nvim" "$target"
}

link_starship() {
    local home
    home="$(configs_home)"
    if [ -z "$home" ]; then
        print_warning "Starship: no target home for this profile — skipped"
        return
    fi
    if [ -f "$DOTFILES_DIR/starship/starship.toml" ]; then
        create_symlink "$DOTFILES_DIR/starship/starship.toml" "$home/.config/starship.toml"
    else
        print_info "Starship: no starship.toml in repo — skipped"
    fi
}

link_tmux() {
    if [ -f "$DOTFILES_DIR/tmux/tmux.conf" ]; then
        create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    else
        print_info "tmux: no tmux.conf in repo — skipped"
    fi
}

link_kitty() {
    if [ -d "$DOTFILES_DIR/kitty" ]; then
        create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
    else
        print_info "Kitty: no kitty config in repo — skipped"
    fi
}

link_ghostty() {
    if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
        create_symlink "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
    else
        print_info "Ghostty: no ghostty config in repo — skipped"
        return
    fi

    # Regenerate ghostty/colors.inc from the unified theme.
    if [ "$DRY_RUN" = true ]; then
        print_step "[DRY RUN] Would regenerate ghostty/colors.inc"
    elif source "$HOME/.config/zsh/.zshenv" 2>/dev/null &&
        source "$HOME/.config/zsh/colors.zsh" 2>/dev/null; then
        _generate_ghostty_config &&
            print_success "colors.inc regenerated (theme: $THEME)" ||
            print_warning "Failed to generate colors.inc"
    else
        print_warning "Could not source zsh colors — link zsh and re-run to regenerate colors.inc"
    fi
}

link_zsh() {
    create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"

    # git-completion.bash is required by the zsh config.
    local git_completion="$DOTFILES_DIR/zsh/git-completion.bash"
    if [ ! -f "$git_completion" ]; then
        if [ "$DRY_RUN" = true ]; then
            print_step "[DRY RUN] Would download git-completion.bash"
        else
            print_step "Downloading git-completion.bash..."
            curl -fsSo "$git_completion" \
                https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash &&
                print_success "git-completion.bash downloaded" ||
                print_warning "Failed to download git-completion.bash"
        fi
    else
        print_success "git-completion.bash (already present)"
    fi

    setup_shell_rc
}

# Append (never overwrite) the source lines to ~/.zshenv and ~/.zshrc.
setup_shell_rc() {
    if [ "$DRY_RUN" = true ]; then
        print_step "[DRY RUN] Would append to ~/.zshenv and ~/.zshrc (never overwrites)"
        return
    fi

    local zshenv_line='[ -f "$HOME/.config/zsh/.zshenv" ] && source "$HOME/.config/zsh/.zshenv"'
    if [ ! -f "$HOME/.zshenv" ]; then
        printf '%s\n%s\n' "# Dotfiles environment" "$zshenv_line" > "$HOME/.zshenv"
        print_success "Created ~/.zshenv"
    elif ! grep -q ".config/zsh/.zshenv" "$HOME/.zshenv" 2>/dev/null; then
        printf '\n%s\n%s\n' "# Dotfiles environment" "$zshenv_line" >> "$HOME/.zshenv"
        print_success "Appended to ~/.zshenv"
    else
        print_info "~/.zshenv already configured"
    fi

    local zshrc_line='[ -f "$HOME/.config/zsh/.zshrc" ] && source "$HOME/.config/zsh/.zshrc"'
    if [ ! -f "$HOME/.zshrc" ]; then
        printf '%s\n%s\n' "# Dotfiles shell config" "$zshrc_line" > "$HOME/.zshrc"
        print_success "Created ~/.zshrc"
    elif ! grep -q ".config/zsh/.zshrc" "$HOME/.zshrc" 2>/dev/null; then
        printf '\n%s\n%s\n' "# Dotfiles shell config" "$zshrc_line" >> "$HOME/.zshrc"
        print_success "Appended to ~/.zshrc"
    else
        print_info "~/.zshrc already configured"
    fi
}

link_powershell() {
    local src="$DOTFILES_DIR/powershell/Microsoft.PowerShell_profile.ps1"
    if [ ! -f "$src" ]; then
        print_warning "PowerShell profile not found in repo — skipped"
        return
    fi
    create_symlink "$src" "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
    create_symlink "$src" "$HOME/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
}

link_bashrc() {
    if [ -f "$DOTFILES_DIR/bash/.bashrc" ]; then
        create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    else
        print_warning "bash/.bashrc not found in repo — skipped"
    fi
}

link_configs() {
    print_header "Linking Configs"
    if [ -z "$SELECTED_CONFIGS" ]; then
        print_info "No configs selected — nothing to link"
        return
    fi
    local cfg
    for cfg in $SELECTED_CONFIGS; do
        case "$cfg" in
            wezterm)    link_wezterm ;;
            nvim)       link_nvim ;;
            starship)   link_starship ;;
            tmux)       link_tmux ;;
            zsh)        link_zsh ;;
            kitty)      link_kitty ;;
            ghostty)    link_ghostty ;;
            powershell) link_powershell ;;
            bashrc)     link_bashrc ;;
        esac
    done
}

# ============================================================================
# Verification
# ============================================================================
verify_links() {
    print_header "Verification"
    local files=() cfg
    for cfg in $SELECTED_CONFIGS; do
        case "$cfg" in
            wezterm)    files+=("$(configs_home)/.wezterm.lua:WezTerm") ;;
            nvim)       files+=("$(nvim_target):Neovim") ;;
            starship)   files+=("$(configs_home)/.config/starship.toml:Starship") ;;
            tmux)       files+=("$HOME/.tmux.conf:tmux") ;;
            zsh)        files+=("$HOME/.config/zsh/.zshrc:zsh") ;;
            kitty)      files+=("$HOME/.config/kitty:Kitty") ;;
            ghostty)    files+=("$HOME/.config/ghostty/config:Ghostty") ;;
            powershell) files+=("$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1:PowerShell") ;;
            bashrc)     files+=("$HOME/.bashrc:Git Bash .bashrc") ;;
        esac
    done

    local item file name
    for item in "${files[@]}"; do
        file="${item%:*}"
        name="${item#*:}"
        if [ -e "$file" ] || [ -L "$file" ]; then
            print_success "$name"
        else
            print_error "$name"
        fi
    done
}

# ============================================================================
# macOS-only: reload running apps after linking
# ============================================================================
reload_apps() {
    [ "$OS" = "macos" ] || { print_info "Reload your terminal manually to pick up changes."; return; }

    print_header "Reloading..."
    if command -v wezterm &>/dev/null && pgrep -f "wezterm" &>/dev/null; then
        wezterm cli reload-configuration 2>/dev/null &&
            print_success "WezTerm reloaded" ||
            print_info "WezTerm: restart manually"
    fi
    if command -v starship &>/dev/null; then
        print_success "Starship will reload with shell"
    fi
    if command -v ghostty &>/dev/null && pgrep -x ghostty &>/dev/null; then
        print_info "Reloading Ghostty..."
        killall ghostty 2>/dev/null
        sleep 0.1
        open -a ghostty 2>/dev/null && print_success "Ghostty reloaded" ||
            print_info "Ghostty: restart manually"
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
    print_info "Detected OS: $OS"

    if [ "$OS" = "unsupported" ]; then
        print_error "Unsupported OS. This script supports macOS, Linux, WSL and Windows (Git Bash)."
        exit 1
    fi

    if [ "$DRY_RUN" = true ]; then
        print_warning "DRY RUN MODE - No changes will be made"
    fi
    if [ "$BACKUP" = true ] && [ "$DRY_RUN" = false ]; then
        print_info "Backups: $BACKUP_DIR"
    fi

    # Load saved selections, or run the interactive flow (first run / --reconfigure).
    if [ "$RECONFIGURE" = true ] || ! load_config; then
        run_interactive
        if [ "$DRY_RUN" = false ]; then
            save_config
            print_success "Saved preferences to $DOTFILES_CONF_FILE"
        else
            print_step "[DRY RUN] Would save preferences to $DOTFILES_CONF_FILE"
        fi
    else
        print_info "Loaded preferences from $DOTFILES_CONF_FILE (use --reconfigure to change)"
        print_info "Profile: $SETUP_PROFILE"
    fi

    # Install any missing selected packages.
    install_handoff

    # Link the selected configs.
    link_configs

    # Verify and summarize.
    verify_links

    print_header "Complete!"
    if [ "$DRY_RUN" = true ]; then
        print_warning "Dry run - no changes made"
        print_info "Run without --dry-run to apply"
    else
        print_success "All selected configurations linked!"
        [ -d "$BACKUP_DIR" ] && print_info "Backups: $BACKUP_DIR"

        reload_apps

        echo ""
        echo -e "${BOLD}${GREEN}✓ Setup complete!${NC}"
        echo ""
        if [ "$SETUP_PROFILE" = "windows" ]; then
            echo -e "${YELLOW}${WARN}${NC} ${BOLD}Restart PowerShell / Git Bash to apply changes.${NC}"
        else
            echo -e "${YELLOW}${WARN}${NC} ${BOLD}Run this to apply shell changes:${NC}"
            echo -e "    ${CYAN}source ~/.zshrc${NC}"
        fi
        echo ""
        echo -e "  ${CYAN}Change theme:${NC} edit ${BOLD}THEME${NC} in zsh/.zshenv (or run ${BOLD}theme <name>${NC})"
        echo ""
    fi
}

main
