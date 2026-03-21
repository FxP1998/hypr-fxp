#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: rofi-launcher.sh
#  󰁔  Description: Toggling application launcher using Rofi (Wayland).
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Toggle Logic ---
if pgrep -x "rofi" > /dev/null; then
    pkill -x "rofi"
    exit 0
fi

# --- Launch ---
# Standard drun mode with your main config
rofi -show drun -theme ~/.config/rofi/config.rasi
