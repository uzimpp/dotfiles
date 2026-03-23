# Dotfiles

Modern, minimal dotfiles with a unified theme system across all tools.

Theme: Anysphere | Font: Geist Mono | Shell: Zsh

## Features

- Unified Theming - One `THEME` variable controls all tools
- WezTerm / Ghostty - GPU-accelerated terminal with custom themes
- Neovim - Full IDE setup with LSP, completion, and more
- Starship - Fast, minimal prompt
- Neo-tree - File explorer with git integration
- Telescope - Fuzzy finder for everything
- Consistent Font - Geist Mono Nerd Font everywhere

## Quick Start

### 1. Install Dependencies

```bash
./install.sh --all
```

Or install selectively:
```bash
./install.sh              # Essential + terminal tools
./install.sh --dev        # Add development tools
./install.sh --apps       # Add GUI apps
./install.sh --fonts      # Add Nerd Fonts
./install.sh --list       # Show all packages
```

### 2. Setup Symlinks

```bash
./setup.sh
```

### 3. Reload Shell

```bash
source ~/.zshrc
```

## Themes

| Theme | Description |
|-------|-------------|
| `anysphere` | Dark theme inspired by Cursor IDE *(default)* |
| `catppuccin` | Soothing pastel theme |
| `nord` | Arctic, bluish colors |
| `nordic` | Enhanced Nord variant |
| `onedark` | Atom One Dark colors |

### Change Theme

```bash
theme anysphere  # or: catppuccin, nord, nordic, onedark
```

Or edit `~/.config/zsh/.zshenv`:
```bash
export THEME="anysphere"
```

## Structure

```
dotfiles/
├── install.sh          # Install dependencies
├── setup.sh            # Setup symlinks
├── Brewfile            # Homebrew packages
│
├── nvim/               # Neovim config
│   ├── init.lua
│   └── lua/
│       ├── core/       # Options, keymaps
│       └── plugins/    # Plugin configs
│           └── themes/ # Theme configs
│
├── wezterm/            # WezTerm terminal
│   ├── .wezterm.lua
│   ├── config.lua
│   └── events.lua
│
├── ghostty/            # Ghostty terminal
│   └── config
│
├── starship/           # Starship prompt
│   └── starship.toml
│
└── zsh/                # Zsh shell
    ├── .zshrc
    ├── .zshenv
    ├── aliases.zsh
    └── custom.zsh
```

## Key Bindings

### Neovim

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>gg` | Open Lazygit |
| `\\` | Reveal current file |

### Terminal (WezTerm / Ghostty)

| Key | Action |
|-----|--------|
| `Ctrl+Shift+h/j/k/l` | Navigate splits |
| `Ctrl+Shift+\|` | Split horizontally |
| `Ctrl+Shift+-` | Split vertically |
| `Ctrl+Shift+t` | New tab |
| `Ctrl+Shift+[` | Previous tab |
| `Ctrl+Shift+]` | Next tab |
| `Ctrl+Shift+x` | Close pane |

## Configuration

### Font

All configs use Geist Mono Nerd Font:

- WezTerm: `config.lua`
- Ghostty: `config`
- Neovim: Inherits from terminal

### Git Blame (GitLens-style)

Shows in status bar: `Author at 08 Jan 2026 - commit message...`

Configure in `nvim/lua/plugins/gitblame.lua`:
```lua
vim.g.gitblame_max_commit_summary_length = 20
```

## What Gets Installed

### Essential
- git, zsh, neovim, starship

### Terminal Tools
- fzf, zoxide, eza, bat, fd, ripgrep
- delta, lazygit, htop, tree, jq, tldr

### Development (--dev)
- node, python, go, rust, lua

### Apps (--apps)
- WezTerm, VS Code, Arc, Raycast
- Discord, Slack, Notion, Spotify
- Docker, Postman, TablePlus

### Fonts (--fonts)
- JetBrains Mono Nerd Font
- Geist Mono Nerd Font
- Fira Code Nerd Font
- Hack Nerd Font

## Updating

```bash
cd ~/dotfiles
git pull
```

Symlinks automatically point to updated files!
