#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${BLUE}:: Reloading Waybar...${RESET}"

# Kill all instances
killall waybar 2>/dev/null

# Wait a moment to ensure it's dead
sleep 0.2

# Start fresh
waybar &

echo -e "${GREEN}✔ Waybar Reloaded.${RESET}"
