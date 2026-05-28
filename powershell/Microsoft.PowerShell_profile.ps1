# Dotfiles PowerShell profile — themed shell for native Windows.
#
# setup.sh links this file to both PowerShell editions:
#   Documents\PowerShell\Microsoft.PowerShell_profile.ps1         (PowerShell 7+)
#   Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1  (Windows PowerShell 5.1)
#
# This is a lightweight port — Starship init, the THEME variable and key
# aliases — not a full port of the zsh config. zsh remains the primary shell
# on macOS / Linux / WSL.

# ----------------------------------------------------------------------------
# Locate the dotfiles repo
# ----------------------------------------------------------------------------
# This profile is normally a symlink into the repo. Resolve the link to find
# the repo root; fall back gracefully when it was copied (no Developer Mode).
function Get-DotfilesRoot {
    $self = $PROFILE.CurrentUserCurrentHost
    try {
        $item = Get-Item -LiteralPath $self -ErrorAction Stop
        if ($item.Target) { $self = $item.Target }
    } catch { }
    # $self -> <repo>\powershell\Microsoft.PowerShell_profile.ps1
    return (Split-Path -Parent (Split-Path -Parent $self))
}

# ----------------------------------------------------------------------------
# Theme — single source of truth is zsh/.zshenv
# ----------------------------------------------------------------------------
# Neovim, WezTerm and Starship all derive their colors from THEME. Read the
# value out of zsh/.zshenv so PowerShell stays in sync with the rest.
function Import-DotfilesTheme {
    $root = Get-DotfilesRoot
    $zshenv = Join-Path $root 'zsh/.zshenv'
    if (Test-Path -LiteralPath $zshenv) {
        $match = Select-String -LiteralPath $zshenv -Pattern '^\s*export\s+THEME=' |
                 Select-Object -First 1
        if ($match) {
            $value = $match.Line -replace '^\s*export\s+THEME=', ''
            $value = $value.Trim().Trim('"').Trim("'")
            if ($value) { $env:THEME = $value }
        }
    }
    if (-not $env:THEME) { $env:THEME = 'catppuccin' }
}
Import-DotfilesTheme

# ----------------------------------------------------------------------------
# Prompt and shell integrations
# ----------------------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ----------------------------------------------------------------------------
# Aliases — ported from the zsh config
# ----------------------------------------------------------------------------
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza --icons --group-directories-first @args }
    function ll { eza -la --icons --group-directories-first @args }
    function la { eza -a --icons --group-directories-first @args }
    function lt { eza --tree --icons @args }
} else {
    function ll { Get-ChildItem -Force @args }
    function la { Get-ChildItem -Force @args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat @args }
}

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    function v   { nvim @args }
    function vim { nvim @args }
}

# Git shortcuts
function g  { git @args }
function gs { git status @args }
function ga { git add @args }
function gc { git commit @args }
function gp { git push @args }
function gl { git log --oneline --graph --decorate @args }

# Navigation
function ..  { Set-Location .. }
function ... { Set-Location ../.. }
