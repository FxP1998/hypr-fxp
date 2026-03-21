#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: song-status.sh
#  󰁔  Description: Returns currently playing track information for Hyprlock.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# Check if media is playing
if playerctl status >/dev/null 2>&1; then
  # Print song info with Nerd Font icon
  playerctl metadata --format "{{title}} 󰓇 {{artist}}" | cut -c 1-35
else
  # If nothing is playing
  echo "Not playing"
fi
