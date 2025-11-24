#!/usr/bin/env bash

# Directory to save screenshots
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Filename with timestamp
FILE="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

# Take screenshot: full screen or selection
if [ "$1" == "area" ]; then
    SEL=$(slurp)
    if [ -z "$SEL" ]; then
        notify-send "Screenshot cancelled" "No area selected"
        exit 1
    fi
    grim -g "$SEL" "$FILE"
else
    grim "$FILE"
fi

# Check if screenshot was created successfully
if [ ! -f "$FILE" ]; then
    notify-send "Screenshot failed" "Could not save screenshot"
    exit 1
fi

# Copy to clipboard
wl-copy < "$FILE"

# Show notification with mako
if command -v mako >/dev/null 2>&1; then
    notify-send -i "$FILE" "Screenshot saved" "$FILE"
else
    notify-send "Screenshot saved" "$FILE"
fi

