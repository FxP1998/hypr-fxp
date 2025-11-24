#!/bin/bash
# Music startup script for Hyprland

# Wait for audio system
sleep 2

# Start MPD if not running
if ! systemctl --user is-active --quiet mpd; then
    systemctl --user start mpd
    echo "MPD started"
fi

# Update library
mpc update

# Set initial volume
mpc volume 80

# Optional: Start visualizer in background
# kitty --class=visualizer -e ncmpcpp -s visualizer &
