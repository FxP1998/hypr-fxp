#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: set-wall-on-boot.sh
#  󰁔  Description: Sets a random wallpaper from the organized gallery.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE
    I_WALL="[WALL]"; I_OK="[OK]"; I_INFO="->"; I_WORK="[*]"
else
    # GUI CANDY MODE
    I_WALL="󰸉"; I_OK="󰄬"; I_INFO="󰁔"; I_WORK="󰚰"
fi

# --- Configuration ---
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# --- Logic ---
echo -e "${C_BLUE}${I_WALL}  Picking random wallpaper...${C_RESET}"

# 1. Start Daemon if needed
if ! pgrep -x "swww-daemon" > /dev/null; then
    echo -e "      ${I_INFO} Starting swww-daemon..."
    swww-daemon &
    sleep 0.5
fi

# 2. Select Wallpaper (Recursive)
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

if [ -z "$RANDOM_WALLPAPER" ]; then
    echo -e "  ${C_RED}[✘] Error: No wallpapers found in $WALLPAPER_DIR${C_RESET}"
    exit 1
fi

NAME=$(basename "$RANDOM_WALLPAPER")
echo -e "      ${I_INFO} Selected: ${C_YELLOW}$NAME${C_RESET}"

# 3. Sync Lockscreen Asset
mkdir -p "$HOME/.config/hypr/assets"
cp "$RANDOM_WALLPAPER" "$HOME/.config/hypr/assets/current-wallpaper.png"

# 4. Apply Wallpaper
swww img "$RANDOM_WALLPAPER" --transition-type none

# 5. Apply Colors (Matugen)
if command -v matugen &>/dev/null; then
    echo -e "      ${I_WORK} Regenerating Material You palette..."
    matugen -c "$HOME/.config/matugen/config.toml" image "$RANDOM_WALLPAPER" --source-color-index 0 --type scheme-rainbow > /dev/null 2>&1
fi

echo -e "  ${C_GREEN}${I_OK} Done! Enjoy your new look.${C_RESET}"
