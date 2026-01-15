#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/scr_$(date +%Y-%m-%d_%H-%M-%S).png"

if [ "$1" == "area" ]; then
    SEL=$(slurp) || exit 1
    grim -g "$SEL" "$FILE"
else
    grim "$FILE"
fi

if [ -f "$FILE" ]; then
    wl-copy < "$FILE"
    notify-send -i "$FILE" "Screenshot Saved" "$FILE"
else
    notify-send "Error" "Screenshot failed."
fi
