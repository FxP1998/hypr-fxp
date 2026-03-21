#!/usr/bin/env bash

# Icons
I_PKG="󰚰"
I_ARCH=""
I_AUR=""

# Fetch counts
OFFICIAL=$(checkupdates 2>/dev/null | wc -l)
AUR=$(yay -Qua 2>/dev/null | wc -l)
TOTAL=$((OFFICIAL + AUR))

if [ "$TOTAL" -eq 0 ]; then
    echo '{"text": "", "alt": "", "tooltip": "System up to date"}'
else
    # Determine color based on count
    if [ "$TOTAL" -gt 50 ]; then
        COLOR="#ffb4ab" # Red/Error
    elif [ "$TOTAL" -gt 20 ]; then
        COLOR="#f6c177" # Yellow/Warning
    else
        COLOR="#c0c1ff" # Blue/Primary
    fi

    TOOLTIP="<b>$I_PKG $TOTAL Updates Available</b>\n\n$I_ARCH Official: $OFFICIAL\n$I_AUR AUR: $AUR\n\n󰁔 Click to start update"
    
    # Clean output for Waybar
    echo "{\"text\": \"<span color='$COLOR'>$I_PKG $TOTAL</span>\", \"tooltip\": \"$TOOLTIP\"}"
fi
