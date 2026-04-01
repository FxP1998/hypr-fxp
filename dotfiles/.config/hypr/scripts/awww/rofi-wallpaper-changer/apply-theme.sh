#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: apply-theme.sh
#  󰁔  Description: Core engine to apply wallpapers, generate colors, and sync assets.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

WALLPAPER="$1"

if [ -z "$WALLPAPER" ]; then
    echo "Usage: apply-theme.sh /path/to/image"
    exit 1
fi

# 1. Start Daemon if needed
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

# 2. Copy for Hyprlock (Sync Lockscreen)
mkdir -p "$HOME/.config/hypr/assets"
cp "$WALLPAPER" "$HOME/.config/hypr/assets/current-wallpaper.png"

# 3. Apply Wallpaper (awww)
awww img "$WALLPAPER" \
    --transition-type "grow" \
    --transition-duration "4" \
    --transition-fps "60"

# 4. Generate Colors (Matugen)
if command -v matugen &>/dev/null; then
    # Detect brightness (0.0 to 1.0) and convert to 0-100 integer for easier Bash comparison
    BRIGHTNESS=$(magick "$WALLPAPER" -colorspace Gray -format "%[fx:int(mean*100)]" info:)

    # 50 threshold (0.5 * 100)
    if [ "$BRIGHTNESS" -gt 75 ]; then
        MODE="light"
    else
        MODE="dark"
    fi

    echo ":: Selected Mode: $MODE (Brightness: $BRIGHTNESS)"
    matugen -c "$HOME/.config/matugen/config.toml" image "$WALLPAPER" --mode "$MODE" --source-color-index 0 --type scheme-rainbow
fi

# 5. Reload Hyprland
hyprctl reload

# 6. Notify
WALL_NAME=$(basename "$WALLPAPER")
notify-send -i "$WALLPAPER" "Wallpaper Changed" "Wallpaper: $WALL_NAME"
