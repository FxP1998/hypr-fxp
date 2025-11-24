#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="$HOME/.config/hypr-fxp/themes/Gruvbox-Light/wallpapers"
WALL=$(find "$WALL_DIR" -type f | shuf -n 1) || { echo "No wallpaper found in $WALL_DIR"; exit 1; }

# Ensure swww-daemon is running (start it if not)
if ! pgrep -x swww-daemon >/dev/null; then
  swww-daemon
  sleep 0.1
fi

# 1) Start the wallpaper transition in background (non-blocking)
swww img "$WALL" --transition-type grow --transition-duration 2 --transition-fps 60

# 2) Let the transition start (sleep shord be the transition duration: 2 of the swww command)
sleep 2

# 3) Generate colors quietly (non-blocking)
wal -i "$WALL"

# 4) Sleep 0.5 Seconds
sleep 1

# 5) Reload Hyprland
hyprctl reload

# 6) NEW: Update Firefox theme without restarting
# Option A: Using pywalfox (recommended - more reliable)
if command -v pywalfox >/dev/null; then
    pywalfox update & disown
# Option B: Using wal's built-in Firefox theming (fallback)
elif command -v wal >/dev/null; then
    wal -f & disown
fi

# 7) Reload mako
makoctl reload

exit 0
