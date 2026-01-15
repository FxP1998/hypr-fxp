#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RESET="\033[0m"

WALLPAPER_DIR="$HOME/.config/hypr/default-wallpaper"

echo -e "${BLUE}▶ SETTING RANDOM WALLPAPER...${RESET}"

# 1. Start Daemon if needed
if ! pgrep -x "swww-daemon" > /dev/null; then
    echo -e "${BLUE}:: Starting swww-daemon...${RESET}"
    swww-daemon &
    sleep 0.5
fi


# 2. Select Wallpaper
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
NAME=$(basename "$RANDOM_WALLPAPER")

echo -e "${BLUE}:: Selected: $NAME${RESET}"


# 3. Copy the wallpaper for hyprlock
cp "$RANDOM_WALLPAPER" ~/.config/hypr/assets/current-wallpaper.png


# 3. Apply Wallpaper
swww img "$RANDOM_WALLPAPER" \
    --transition-type none \
    --transition-fps 60

# 4. Apply Colors (Matugen)
if command -v matugen &>/dev/null; then
    echo -e "${BLUE}:: Generating Matugen colors...${RESET}"
    matugen image "$RANDOM_WALLPAPER"
fi

echo -e "${GREEN}✔ Done!${RESET}"
