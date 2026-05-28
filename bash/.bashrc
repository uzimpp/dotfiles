# Dotfiles Git Bash .bashrc — lightweight themed shell for native Windows.
#
# setup.sh links this file to ~/.bashrc on the Windows profile. Git Bash is a
# secondary shell here, so this is intentionally minimal — Starship init, the
# THEME variable and key aliases — not a full port of the zsh config.

# Only run for interactive shells.
case $- in
    *i*) ;;
    *) return ;;
esac

# ----------------------------------------------------------------------------
# Theme — single source of truth is zsh/.zshenv
# ----------------------------------------------------------------------------
# Resolve this file's real location (it is symlinked to ~/.bashrc) to find the
# repo, then read THEME from zsh/.zshenv so Git Bash stays in sync with the
# rest of the toolchain. Falls back gracefully when the file was copied.
_dotfiles_rc="${BASH_SOURCE[0]}"
if command -v readlink >/dev/null 2>&1; then
    _resolved="$(readlink "$_dotfiles_rc" 2>/dev/null)"
    [ -n "$_resolved" ] && _dotfiles_rc="$_resolved"
fi
_dotfiles_dir="$(cd "$(dirname "$_dotfiles_rc")/.." 2>/dev/null && pwd)"

if [ -f "$_dotfiles_dir/zsh/.zshenv" ]; then
    _theme_line="$(grep -E '^[[:space:]]*export[[:space:]]+THEME=' \
        "$_dotfiles_dir/zsh/.zshenv" 2>/dev/null | head -1)"
    _theme_val="${_theme_line#*THEME=}"
    _theme_val="${_theme_val%\"}"; _theme_val="${_theme_val#\"}"
    _theme_val="${_theme_val%\'}"; _theme_val="${_theme_val#\'}"
    [ -n "$_theme_val" ] && export THEME="$_theme_val"
fi
export THEME="${THEME:-catppuccin}"
unset _dotfiles_rc _resolved _dotfiles_dir _theme_line _theme_val

# ----------------------------------------------------------------------------
# Prompt and shell integrations
# ----------------------------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# ----------------------------------------------------------------------------
# Aliases — ported from the zsh config
# ----------------------------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons'
else
    alias ll='ls -la'
    alias la='ls -A'
fi

command -v bat  >/dev/null 2>&1 && alias cat='bat'
command -v nvim >/dev/null 2>&1 && alias vim='nvim' && alias v='nvim'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend 2>/dev/null
