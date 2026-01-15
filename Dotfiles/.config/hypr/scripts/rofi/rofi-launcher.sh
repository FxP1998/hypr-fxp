#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# Kill if running (Toggle behavior)
if pgrep -x "rofi" > /dev/null; then
    pkill -x "rofi"
    exit 0
fi

# Launch Rofi with the config
rofi -show drun -theme ~/.config/rofi/config.rasi
