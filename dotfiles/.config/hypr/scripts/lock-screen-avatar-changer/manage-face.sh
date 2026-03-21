#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: lock-screen-avatar-changer/manage-face.sh
#  󰁔  Description: Tool to change the user avatar image used in Hyprlock.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_IMAGE="[IMG]"; I_OK="[OK]"; I_INFO="->"; I_WARN="[!]"; LINE="----------------------------------------------------"
else
    I_IMAGE="󰋩"; I_OK="󰄬"; I_INFO="󰁔"; I_WARN="󰀦"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
ASSETS_DIR="$HOME/.config/hypr/assets"
FACE_IMAGE="$ASSETS_DIR/face.jpg"

# --- UI Helpers ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_IMAGE}  ${C_BOLD}HYPRLOCK AVATAR MANAGER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

usage() {
    echo -e "  ${C_YELLOW}Usage:${C_RESET}"
    echo -e "    ${C_GREEN}face-set /path/to/image.jpg${C_RESET}  - Set a new avatar image"
    echo -e "    ${C_GREEN}face-set --current${C_RESET}           - Show current avatar path"
    echo -e ""
    echo -e "  ${C_YELLOW}Note:${C_RESET} The image will be automatically converted to JPG format."
}

# --- Execution ---
print_header

if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

# 1. Show current
if [[ "$1" == "--current" ]]; then
    if [[ -f "$FACE_IMAGE" ]]; then
        echo -e "  ${I_INFO} Current avatar is set at: ${C_BLUE}$FACE_IMAGE${C_RESET}"
        echo -e "\n  ${C_BOLD}Preview:${C_RESET}"
        chafa --size=30x30 "$FACE_IMAGE"
    else
        echo -e "  ${C_RED}${I_WARN} No avatar image found at assets directory.${C_RESET}"
    fi
    exit 0
fi

# 2. Set new image
NEW_IMAGE="$1"

if [[ ! -f "$NEW_IMAGE" ]]; then
    echo -e "  ${C_RED}[✘] Error: File not found: $NEW_IMAGE${C_RESET}"
    exit 1
fi

echo -e "  ${I_INFO} Processing new avatar: ${C_YELLOW}$(basename "$NEW_IMAGE")${C_RESET}..."

# Ensure dependencies
if ! command -v magick &>/dev/null; then
    echo -e "  ${C_YELLOW}${I_WARN} Installing 'imagemagick' for conversion...${C_RESET}"
    sudo pacman -S --needed --noconfirm imagemagick >/dev/null 2>&1
fi

# Create assets dir if missing
mkdir -p "$ASSETS_DIR"

# Convert and Move
if magick "$NEW_IMAGE" -resize 256x256^ -gravity center -extent 256x256 "$FACE_IMAGE" &>/dev/null; then
    echo -e "  ${C_GREEN}${I_OK} Success! New avatar has been set.${C_RESET}"
    echo -e "  ${I_INFO} Location: $FACE_IMAGE"
    
    echo -e "\n  ${C_BOLD}New Avatar Preview:${C_RESET}"
    chafa --size=30x30 "$FACE_IMAGE"
    
    # Notify
    if command -v notify-send &>/dev/null; then
        notify-send -i "$FACE_IMAGE" "Avatar Updated" "Your Hyprlock profile image has been changed."
    fi
else
    echo -e "  ${C_RED}[✘] Error: Failed to process the image.${C_RESET}"
    exit 1
fi
