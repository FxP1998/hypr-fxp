#!/usr/bin/env bash

# Configuration
THEMES_DIR="$HOME/.config/hypr-fxp/themes"

# Get available themes (folder names)
themes=($(find "$THEMES_DIR" -maxdepth 1 -type d -printf "%f\n" | tail -n +2))

# Show rofi menu with theme names
selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -p "Select theme:")

# Exit if no selection
if [[ -z "$selected_theme" ]]; then
    exit 0
fi

# Check if theme exists and has copy script
if [[ ! -d "$THEMES_DIR/$selected_theme" ]]; then
    notify-send "Theme Error" "Theme '$selected_theme' not found!"
    exit 1
fi

# Run the theme's copy script
if [[ -f "$THEMES_DIR/$selected_theme/theme-copy.sh" ]]; then
    bash "$THEMES_DIR/$selected_theme/theme-copy.sh"
else
    notify-send "Theme Error" "Copy script not found for '$selected_theme'"
    exit 1
fi
