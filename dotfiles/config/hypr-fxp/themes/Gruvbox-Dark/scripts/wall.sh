#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="$HOME/.config/hypr-fxp/themes/Gruvbox-Dark/wallpapers/default/"
WALL=$(find "$WALL_DIR" -type f | shuf -n 1) || { echo "No wallpaper found in $WALL_DIR"; exit 1; }

# Ensure swww-daemon is running (start it if not)
if ! pgrep -x swww-daemon >/dev/null; then
  swww-daemon &
  sleep 0.1
fi

# 1) Start the wallpaper transition in background (non-blocking)
swww img "$WALL" --transition-type none --transition-fps 60

# 2) Let the transition start (this is your 2s; we still wait a little to avoid thrash)
sleep 0.1

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

# 8) Sleep 0.2
sleep 0.2

# 9) Notify theme
notify-send "Gruvbox Dark" "Theme Applied "

# 10) Kill swayosd-server and restart it
killall swayosd-server
sleep 0.1
swayosd-server &

exit 0
