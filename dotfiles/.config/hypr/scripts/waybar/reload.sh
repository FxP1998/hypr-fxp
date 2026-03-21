#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: reload.sh
#  󰁔  Description: Surgical restart of the Waybar status bar.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_RESET='\033[0m'

echo -e "${C_BLUE}:: Reloading Waybar...${C_RESET}"

# Kill all instances
killall waybar 2>/dev/null

# Wait for process to end
sleep 0.2

# Start fresh
waybar & > /dev/null 2>&1

echo -e "${C_GREEN}󰄬 Waybar Restarted.${C_RESET}"
