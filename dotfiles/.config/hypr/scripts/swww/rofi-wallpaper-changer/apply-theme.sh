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
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

# 2. Copy for Hyprlock (Sync Lockscreen)
mkdir -p "$HOME/.config/hypr/assets"
cp "$WALLPAPER" "$HOME/.config/hypr/assets/current-wallpaper.png"

# 3. Apply Wallpaper (swww)
swww img "$WALLPAPER" \
    --transition-type "grow" \
    --transition-duration "4" \
    --transition-fps "60"

# 4. Generate Colors (Matugen)
if command -v matugen &>/dev/null; then
    matugen -c "$HOME/.config/matugen/config.toml" image "$WALLPAPER" --source-color-index 0 --type scheme-rainbow
fi

# 5. Reload Hyprland
hyprctl reload

# 6. Notify
WALL_NAME=$(basename "$WALLPAPER")
notify-send -i "$WALLPAPER" "Wallpaper Changed" "Wallpaper: $WALL_NAME"
