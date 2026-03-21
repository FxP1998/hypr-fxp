#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: player-icon.sh
#  󰁔  Description: Returns playback status icon for Hyprlock.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

status=$(playerctl status 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    echo "󰏤" # Nerd Font Pause
else
    echo "󰐊" # Nerd Font Play
fi
