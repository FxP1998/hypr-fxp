#!/usr/bin/env bash

# Current theme directory
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="Catppuccin-Latte"

echo "Applying theme: $THEME_NAME"

# Copy items one by one
if [[ -f "$THEME_DIR/scripts/wall.sh" ]]; then
    mkdir -p "$HOME/.config/hypr/scripts" && cp "$THEME_DIR/scripts/wall.sh" "$HOME/.config/hypr/scripts/wall.sh" && echo "Copied: wall.sh"
fi

if [[ -f "$THEME_DIR/scripts/wall-reload.sh" ]]; then
    mkdir -p "$HOME/.config/hypr/scripts" && cp "$THEME_DIR/scripts/wall-reload.sh" "$HOME/.config/hypr/scripts/wall-reload.sh" && echo "Copied: wall-reload.sh"
fi

if [[ -d "$THEME_DIR/config/.vim" ]]; then
    mkdir -p "$HOME/.vim" && cp -r "$THEME_DIR/config/.vim" "$HOME/" && echo "Copied: .vim"
fi

if [[ -d "$THEME_DIR/config/nvim" ]]; then
    mkdir -p "$HOME/.config/nvim" && cp -r "$THEME_DIR/config/nvim" "$HOME/.config/" && echo "Copied: nvim"
fi

if [[ -d "$THEME_DIR/config/gtk-3.0" ]]; then
    mkdir -p "$HOME/.config/gtk-3.0" && cp -r "$THEME_DIR/config/gtk-3.0" "$HOME/.config/" && echo "Copied: gtk-3.0"
fi

# Sleep 0.2 Second
sleep 0.2

# Change wallpaper (swww)
~/.config/hypr/scripts/wall.sh

# Restart swayosd
killall swayosd-server
sleep 0.1
swayosd-server &
