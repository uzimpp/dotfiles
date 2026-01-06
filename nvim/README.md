# Neovim Configuration with LazyVim

This configuration uses [LazyVim](https://www.lazyvim.org/) as the base framework with a customizable theme system that integrates with your unified theme environment.

## Theme System

The theme is controlled by the `THEME` environment variable set in `~/.config/zsh/.zshenv`. Changing this variable updates Neovim, Starship, and WezTerm simultaneously.

### Available Themes

- **nordic** - Nordic color palette (default)
- **nord** - Nord color palette  
- **onedark** - One Dark color palette
- **catpuccin** - Catppuccin Mocha color palette
- **anysphere** - [Cursor Dark Anysphere theme](https://github.com/evanlouie/cursor-dark-anysphere.nvim) - Proper Anysphere theme with VS Code fidelity

### Changing Themes

Edit `~/.config/zsh/.zshenv`:
```bash
export THEME="anysphere"  # or: nordic, nord, onedark, catpuccin
```

Then restart Neovim:
```bash
source ~/.config/zsh/.zshenv
nvim
```

The theme will be automatically applied based on the `THEME` environment variable.

## Structure

- `init.lua` - Main entry point, bootstraps LazyVim and applies theme based on `THEME` env var
- `lua/config/theme.lua` - Theme configuration module (helper functions)
- `lua/plugins/themes/` - Theme plugin configurations

## Theme Plugins

Each theme has its own plugin configuration in `lua/plugins/themes/`:
- `nordic.lua` - Nord theme (shaunsingh/nord.nvim)
- `nord.lua` - Nord theme (shaunsingh/nord.nvim)
- `onedark.lua` - OneDark theme (navarasu/onedark.nvim)
- `catpuccin.lua` - Catppuccin theme (catppuccin/nvim)
- `anysphere.lua` - **Cursor Dark Anysphere theme** (evanlouie/cursor-dark-anysphere.nvim)
  - Full VS Code compatibility
  - 160+ colors
  - Semantic highlighting support
  - 20+ plugin integrations

## LazyVim Features

This configuration includes all LazyVim defaults:
- File explorer (neo-tree)
- Fuzzy finder (telescope)
- LSP support
- Auto-completion
- Git integration
- And much more!

See [LazyVim documentation](https://www.lazyvim.org/) for full feature list.

## Key Bindings

- `<leader>bg` - Toggle background transparency (theme-dependent)
- Standard LazyVim keybindings apply

## Notes

- All themes are configured but only the active one (based on `THEME` env var) is loaded
- The anysphere theme uses the proper plugin with full VS Code compatibility
- Themes integrate seamlessly with LazyVim's plugin ecosystem

