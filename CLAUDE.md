# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies (Homebrew on macOS, apt on Linux/WSL, winget on Windows)
./install.sh           # Essential + terminal tools
./install.sh --all     # macOS/Windows: + apps + fonts. Linux/WSL: GUI apps skipped
./install.sh --dev     # Add development tools
./install.sh --apps    # Install GUI apps (macOS/Windows)
./install.sh --fonts   # Install Nerd Fonts (macOS)
./install.sh --list    # Show all packages and install status

# Native Windows entry point — run in PowerShell. Provisions Git Bash + winget,
# then hands off to setup.sh under Git Bash.
.\bootstrap.ps1

# Interactive setup + symlinks
./setup.sh             # Setup-type menu + 4 checkbox screens; offers to install missing deps
./setup.sh --dry-run   # Preview without making changes
./setup.sh --no-backup # Skip backup of existing files
./setup.sh --reconfigure  # Re-run the interactive menus

# Apply shell changes after setup
source ~/.zshrc

# Change theme across all tools
theme anysphere         # or: catppuccin, nord, nordic, onedark, vague
```

## Architecture

### Cross-platform Support

Both `install.sh` and `setup.sh` detect the host OS via a small `detect_os()` helper and set `$OS` to one of `macos`, `linux`, `wsl`, `windows`, or `unsupported`. Git Bash reports `uname -s` as `MINGW*`/`MSYS*`/`CYGWIN*` → `windows`.

**Native Windows** runs the bash scripts under Git Bash — there is no PowerShell port of the setup logic. `bootstrap.ps1` (the only PowerShell file) provisions Git for Windows + winget, checks Developer Mode, then execs `setup.sh` under Git Bash.

**install.sh** branches on `$OS`:
- **macOS**: Homebrew formulas, casks, fonts, auto-reload of WezTerm.
- **Linux** (Debian/Ubuntu): CLI tools via `apt` (mapped through `apt_name_for()`). Three exceptions bypass apt: Starship (official installer), **Neovim** (`install_neovim_linux` — official GitHub release tarball into `/opt/nvim-linux-<arch>`, symlinked to `/usr/local/bin/nvim`, because apt ships 0.6.x which predates `nvim_create_autocmd` and lazy.nvim), and **Nerd Fonts** (`install_fonts_linux` — zips from `ryanoasis/nerd-fonts` releases into `~/.local/share/fonts`, mapped by `nerd_font_asset_for()`). GUI apps still must be installed manually.
- **WSL**: same package handling as Linux.
- **Windows**: everything via `winget` (mapped through `winget_name_for()`, which covers both CLI tools and GUI apps since Windows has no separate cask concept). Tools with no winget package are skipped with a notice.

`install.sh` guards `main()` behind `if [[ "${BASH_SOURCE[0]}" == "${0}" ]]`, so `setup.sh` can **source** it to reuse its package arrays and install functions (`install_one_formula`, `install_casks`) without triggering an install.

To support a new Linux distro, extend `apt_name_for()` (or add a parallel `dnf_name_for()` and branch on `$OS`). To add a Windows package, extend `winget_name_for()`.

**setup.sh** is fully interactive. On first run (or `--reconfigure`):
1. A radio menu picks the **setup profile** (`macos`, `linux`, `wsl`, `wsl-windows`, `windows`), pre-selected from `$OS`.
2. Four checkbox screens select CLI Tools, Applications, Fonts and Configs (arrow-key multi-select: `Space` toggle, `a`/`n` all/none, `Enter` confirm).
3. Missing selected packages are detected and `setup.sh` offers to install them by sourcing `install.sh`.
4. Selected configs are linked; the link target is derived from the profile, not asked per-item.

Choices are saved to `~/.config/dotfiles/config` (`SETUP_PROFILE`, `SELECTED_TOOLS/APPS/FONTS/CONFIGS`, `WIN_HOME`) and reused silently on later runs. An old-format config (pre-existing `COMPONENT_*` keys) is treated as absent so the new flow runs.

Link targets by profile: the Windows-capable configs (WezTerm, Neovim, Starship) link to `$WIN_HOME` on the `wsl-windows` profile and to `$HOME` otherwise; CLI configs (tmux, zsh, Kitty, Ghostty) always link to `$HOME` and are skipped on the `windows` profile, which instead links the PowerShell profile and Git Bash `.bashrc`. On `wsl-windows`, `$WIN_HOME` is resolved from `cmd.exe %USERPROFILE%` via `wslpath`.

The menu primitives (`checkbox_menu`, `radio_menu`) are bash-3.2 compatible, degrade to the pre-checked defaults when stdin is not a TTY, and restore the cursor on exit/interrupt via a `trap`. On native Windows, `setup.sh` exports `MSYS=winsymlinks:nativestrict`; `create_symlink()` falls back to a copy (with a warning) when native symlinks fail because Developer Mode is off.

### Unified Theme System

The most important architectural concept: a single `THEME` env variable in `zsh/.zshenv` drives all tools simultaneously.

- `zsh/colors.zsh` — defines `COLOR_*` env vars and generator functions (`_generate_ghostty_config`, `_generate_wezterm_colors`)
- `setup.sh` calls `_generate_ghostty_config` to write `ghostty/colors.inc` at link time
- WezTerm reads `~/colors.lua` (generated by `_generate_wezterm_colors`)
- Neovim reads `THEME` or `NVIM_THEME` env var via `nvim/lua/config/theme.lua`, which maps theme names to plugin modules and colorscheme commands
- `powershell/Microsoft.PowerShell_profile.ps1` and `bash/.bashrc` (native-Windows shells) read `THEME` straight out of `zsh/.zshenv`; they are lightweight ports (Starship init, `THEME`, key aliases), not full zsh ports

### Neovim Plugin Architecture

Each plugin is a self-contained file in `nvim/lua/plugins/` returning a lazy.nvim spec. To add a plugin:
1. Create `nvim/lua/plugins/<name>.lua` returning the lazy.nvim spec table
2. Add `require 'plugins.<name>'` to the plugins list in `nvim/init.lua`

Key structural files:
- `nvim/init.lua` — entry point; sets up lazy.nvim and lists all plugins
- `nvim/lua/core/` — options, keymaps, snippets (loaded before plugins)
- `nvim/lua/config/theme.lua` — theme resolution logic; reads `THEME`/`NVIM_THEME` env, falls back to reading `zsh/.zshenv` directly if env is unset
- `nvim/lua/plugins/themes/` — one file per supported theme colorscheme

### Symlink Strategy

`setup.sh` symlinks entire directories (e.g. `nvim/` → `~/.config/nvim`), so editing files in this repo takes effect immediately without re-running setup. The exception is `ghostty/colors.inc` and `~/colors.lua`, which are generated files written during `setup.sh`.

### image.nvim Setup

`nvim/lua/plugins/image.lua` uses `3rd/image.nvim` with the kitty graphics backend. It requires:
- `imagemagick` (`brew install imagemagick`)
- `magick` luarock (`luarocks --lua-version 5.1 install magick`)
- tmux `allow-passthrough on` (already set in `tmux/tmux.conf`)

The plugin manually prepends `~/.luarocks` to `package.path` at startup since Neovim doesn't pick it up automatically.
