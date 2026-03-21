#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: restart-swayosd.sh
#  󰁔  Description: Surgical restart of the SwayOSD server for volume/brightness overlays.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_RESET='\033[0m'

echo -e "${C_BLUE}:: Restarting SwayOSD Service...${C_RESET}"

# Kill existing instance
pkill swayosd-server 2>/dev/null

# Wait briefly
sleep 0.5

# Start fresh instance
swayosd-server & > /dev/null 2>&1

echo -e "${C_GREEN}󰄬 SwayOSD Restarted.${C_RESET}"
