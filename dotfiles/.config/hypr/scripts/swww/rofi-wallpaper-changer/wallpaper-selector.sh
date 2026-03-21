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
# We use an associative array to map the displayed name back to the full path
declare -A WALLPAPER_MAP

LIST=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | sort)

ROFI_INPUT=""
while read -r file; do
    # Get relative path for uniqueness (e.g. Anime/girl.png)
    rel_path="${file#$WALLPAPER_DIR/}"
    WALLPAPER_MAP["$rel_path"]="$file"

    # Syntax for Rofi: DisplayName \0icon\x1f FullPathForIcon
    ROFI_INPUT+="$rel_path\0icon\x1f$file\n"
done <<< "$LIST"

# --- Launch Rofi ---
SELECTED=$(echo -ne "$ROFI_INPUT" | rofi -dmenu -theme "$ROFI_THEME" -p "Select Wallpaper" -markup-rows)

# --- Handle Selection ---
if [ -n "$SELECTED" ]; then
    FULL_PATH="${WALLPAPER_MAP[$SELECTED]}"

    # Run the Apply Script
    if [ -f "$FULL_PATH" ]; then
        "$APPLY_SCRIPT" "$FULL_PATH"
    else
        notify-send -u critical "Error" "Selected file not found: $FULL_PATH"
    fi
fi
