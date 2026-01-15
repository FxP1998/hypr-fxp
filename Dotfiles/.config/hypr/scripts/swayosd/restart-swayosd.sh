#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${BLUE}:: Restarting SwayOSD Service...${RESET}"

# Kill existing instance
pkill swayosd-server 2>/dev/null

# Wait briefly
sleep 0.5

# Start fresh instance
swayosd-server &

echo -e "${GREEN}✔ SwayOSD Restarted.${RESET}"
