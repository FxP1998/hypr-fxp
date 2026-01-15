#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Configuration ---
# Your Wallpapers Folder
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# 1. Detect where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 2. Path to the Theme (Located in your Rofi config)
ROFI_THEME="$HOME/.config/hypr/scripts/swww/rofi-wallpaper-changer/wallpaper-select.rasi"

# 3. Path to the Apply Script (Located next to this script)
APPLY_SCRIPT="$SCRIPT_DIR/apply-theme.sh"

# --- Safety Checks ---
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send -u critical "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

if [ ! -f "$ROFI_THEME" ]; then
    notify-send -u critical "Error" "Rofi theme not found at: $ROFI_THEME"
    exit 1
fi

if [ ! -x "$APPLY_SCRIPT" ]; then
    notify-send -u critical "Error" "Apply script missing or not executable: $APPLY_SCRIPT"
    exit 1
fi

# --- Generate List for Rofi ---
# Find images and format: Filename \0icon\x1f FullPath
LIST=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | sort)

ROFI_INPUT=""
while read -r file; do
    filename=$(basename "$file")
    # Syntax: Filename \0icon\x1f FullPath
    ROFI_INPUT+="$filename\0icon\x1f$file\n"
done <<< "$LIST"

# --- Launch Rofi ---
SELECTED=$(echo -e "$ROFI_INPUT" | rofi -dmenu -theme "$ROFI_THEME" -p "Select Wallpaper" -markup-rows)

# --- Handle Selection ---
if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALLPAPER_DIR/$SELECTED"
    
    # Run the Apply Script
    "$APPLY_SCRIPT" "$FULL_PATH"
fi
