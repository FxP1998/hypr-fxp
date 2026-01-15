#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Configuration ---
# Set the root path for your scripts to avoid hardcoding "FxP-Hyprland"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"

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
# Ensure the assets folder exists to prevent errors
mkdir -p "$HOME/.config/hypr/assets"
cp "$WALLPAPER" "$HOME/.config/hypr/assets/current-wallpaper.png"

# 3. Apply Wallpaper (swww)
swww img "$WALLPAPER" \
    --transition-type "grow" \
    --transition-pos "center" \
    --transition-duration "2" \
    --transition-fps "60"

# 4. Generate Colors (Matugen)
if command -v matugen &>/dev/null; then
    matugen image "$WALLPAPER"
fi

# 5. Reload Hyprland
hyprctl reload

# 6. Notify
WALL_NAME=$(basename "$WALLPAPER")
notify-send -i "$WALLPAPER" "Wallpaper Changed" "Wallpaper: $WALL_NAME"
