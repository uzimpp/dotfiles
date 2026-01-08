# Dotfiles

Unified dotfiles configuration with a centralized theme system.

## How It Works

All tools (Neovim, WezTerm, Kitty, Starship) share a single theme controlled by the `THEME` environment variable in `~/.config/zsh/.zshenv`.

**Theme Flow:**
1. `THEME` is set in `~/.config/zsh/.zshenv`
2. **WezTerm** reads `THEME` and applies matching color scheme
3. **Kitty** uses theme-specific config files (included in `kitty.conf`)
4. **Neovim** reads `THEME` on startup and loads the matching colorscheme
5. **Starship** inherits colors from the terminal (WezTerm/Kitty) automatically

## Available Themes

- `nord` / `nordic` - Nord theme
- `onedark` - OneDark theme
- `catppuccin` - Catppuccin Mocha theme
- `anysphere` - Anysphere/Cursor theme

## Setup

### Initial Installation

**Recommended:** Run the automated setup script:

```bash
cd dotfiles
./setup.sh
```

The script will:
- Create all necessary symlinks with absolute paths
- Remove existing files/directories if they exist (to avoid conflicts)
- Automatically add the source line to `~/.zshrc` if needed

**Manual Installation (alternative):**

If you prefer to set up manually, use symlinks so that updating the dotfiles repo automatically updates your configs:

```bash
cd dotfiles

# WezTerm (must be in home directory, not .config/)
ln -s "$(pwd)/wezterm/.wezterm.lua" ~/.wezterm.lua
ln -s "$(pwd)/wezterm/config.lua" ~/config.lua
ln -s "$(pwd)/wezterm/events.lua" ~/events.lua

# Other configs (standard XDG directories)
# Remove existing directories if they exist, then link
rm -rf ~/.config/kitty ~/.config/nvim ~/.config/starship.toml ~/.config/zsh
ln -s "$(pwd)/kitty" ~/.config/kitty
ln -s "$(pwd)/nvim" ~/.config/nvim
ln -s "$(pwd)/starship/starship.toml" ~/.config/starship.toml
ln -s "$(pwd)/zsh" ~/.config/zsh
```

**Why symlinks?** When you update files in the dotfiles repo, the symlinks automatically point to the updated files. No need to manually copy changes. The setup script uses absolute paths so symlinks work correctly regardless of where you run it from.

### Zsh Configuration

Ensure your `~/.zshrc` sources the config:

```bash
source ~/.config/zsh/.zshrc
```

### Setting Your Theme

Edit `~/.config/zsh/.zshenv`:

```bash
export THEME="catppuccin"  # or nord, onedark, anysphere
```

**After changing the theme:**

1. **WezTerm:** Press `Cmd+Shift+R` or run `wezterm cli reload-config`
2. **Kitty:** Theme applies automatically (or restart Kitty)
3. **Neovim:** Open a new window (reads theme on startup)
4. **Starship:** Inherits terminal colors automatically

## File Locations

| Tool | Config Location | Notes |
|------|----------------|-------|
| WezTerm | `~/.wezterm.lua`, `~/config.lua`, `~/events.lua` | Must be in home directory |
| Kitty | `~/.config/kitty/` | Standard XDG directory |
| Neovim | `~/.config/nvim/` | Standard XDG directory |
| Starship | `~/.config/starship.toml` | Standard XDG directory |
| Zsh | `~/.config/zsh/` | Standard XDG directory |

## Git Tracking

**Important:** The files in `~/.config/dotfiles/` are actual files (not symlinks), so Git can track them properly. The symlinks are created FROM the config locations TO the dotfiles repo, which allows:
- Git to track the actual files in the repo
- Config locations to automatically use updated files from the repo
- No manual copying needed when updating dotfiles
