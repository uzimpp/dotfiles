#!/bin/zsh
# Theme color definitions for unified theme system
# This file defines color palettes for each theme

get_theme_colors() {
  local theme="${1:-catpuccin}"
  
  case "$theme" in
    nordic)
      # Nordic color palette
      export THEME_BG_DARK="#2E3440"
      export THEME_BG="#3B4252"
      export THEME_BG_LIGHT="#434C5E"
      export THEME_FG="#D8DEE9"
      export THEME_FG_LIGHT="#ECEFF4"
      export THEME_BLUE="#5E81AC"
      export THEME_CYAN="#88C0D0"
      export THEME_TEAL="#8FBCBB"
      export THEME_GREEN="#A3BE8C"
      export THEME_YELLOW="#EBCB8B"
      export THEME_ORANGE="#D08770"
      export THEME_RED="#BF616A"
      export THEME_PURPLE="#B48EAD"
      ;;
    nord)
      # Nord color palette (same as Nordic, but can be customized)
      export THEME_BG_DARK="#2E3440"
      export THEME_BG="#3B4252"
      export THEME_BG_LIGHT="#434C5E"
      export THEME_FG="#D8DEE9"
      export THEME_FG_LIGHT="#ECEFF4"
      export THEME_BLUE="#5E81AC"
      export THEME_CYAN="#88C0D0"
      export THEME_TEAL="#8FBCBB"
      export THEME_GREEN="#A3BE8C"
      export THEME_YELLOW="#EBCB8B"
      export THEME_ORANGE="#D08770"
      export THEME_RED="#BF616A"
      export THEME_PURPLE="#B48EAD"
      ;;
    onedark)
      # OneDark color palette
      export THEME_BG_DARK="#181a1f"
      export THEME_BG="#282c34"
      export THEME_BG_LIGHT="#31353f"
      export THEME_FG="#abb2bf"
      export THEME_FG_LIGHT="#c8ccd4"
      export THEME_BLUE="#61afef"
      export THEME_CYAN="#56b6c2"
      export THEME_TEAL="#56b6c2"
      export THEME_GREEN="#98c379"
      export THEME_YELLOW="#e5c07b"
      export THEME_ORANGE="#d19a66"
      export THEME_RED="#e86671"
      export THEME_PURPLE="#c678dd"
      ;;
    catpuccin)
      # Catppuccin Mocha color palette
      export THEME_BG_DARK="#1e1e2e"
      export THEME_BG="#24273a"
      export THEME_BG_LIGHT="#363a4f"
      export THEME_FG="#cad3f5"
      export THEME_FG_LIGHT="#f4dbd6"
      export THEME_BLUE="#8aadf4"
      export THEME_CYAN="#91d7e3"
      export THEME_TEAL="#7dc4a4"
      export THEME_GREEN="#a6da95"
      export THEME_YELLOW="#eed49f"
      export THEME_ORANGE="#f5a97f"
      export THEME_RED="#ed8796"
      export THEME_PURPLE="#c6a0f6"
      ;;
    anysphere)
      # Anysphere color palette (from anysphere.nvim plugin)
      export THEME_BG_DARK="#181818"
      export THEME_BG="#26292f"
      export THEME_BG_LIGHT="#4b5261"
      export THEME_FG="#d6d6dd"
      export THEME_FG_LIGHT="#eeeeee"
      export THEME_BLUE="#61afef"
      export THEME_CYAN="#83d6c5"
      export THEME_TEAL="#83d6c5"
      export THEME_GREEN="#98c379"
      export THEME_YELLOW="#ebc88d"
      export THEME_ORANGE="#efb080"
      export THEME_RED="#f75f5f"
      export THEME_PURPLE="#e394dc"
      ;;
    *)
      # Default to catpuccin
      get_theme_colors "catpuccin"
      ;;
  esac
}

# Load theme colors based on THEME environment variable
if [[ -n "$THEME" ]]; then
  get_theme_colors "$THEME"
else
  get_theme_colors "catpuccin"
fi

