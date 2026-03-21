#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: convert-to-png.sh
#  󰁔  Description: Mass image converter to PNG using ImageMagick.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE
    I_IMG="[IMG]"; I_DIR="[DIR]"; I_WORK="[*]"; I_OK="[OK]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE
    I_IMG="󰋩"; I_DIR="󰉋"; I_WORK="󰚰"; I_OK="󰄬"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

TARGET="${1:-.}"

print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_IMG}  ${C_BOLD}FxP IMAGE CONVERTER (TO PNG)${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

convert_file() {
    local file="$1"
    local base=$(basename "$file")
    if [[ "$file" == *.png ]]; then return; fi
    
    echo -ne "  ${C_BLUE}${I_WORK}${C_RESET} Converting: ${C_YELLOW}$base${C_RESET}..."
    if magick "$file" "${file%.*}.png" &>/dev/null; then
        rm "$file"
        echo -e "\r  ${C_GREEN}${I_OK}${C_RESET} Converted:  ${C_GREEN}$base${C_RESET}   "
    else
        echo -e "\r  ${C_RED}[✘]${C_RESET} Failed:     $base"
    fi
}

# --- Execution ---
print_header

if [ -f "$TARGET" ]; then
    convert_file "$TARGET"
    echo -e "\n  ${C_GREEN}${I_OK} Conversion finished.${C_RESET}"
elif [ -d "$TARGET" ]; then
    echo -e "  ${I_DIR} Processing directory: ${C_BLUE}$TARGET${C_RESET}\n"
    
    # Count files first
    count=$(find "$TARGET" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) | wc -l)
    
    if [ "$count" -eq 0 ]; then
        echo -e "  ${I_INFO} No compatible images found (JPG/WEBP)."
    else
        find "$TARGET" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) | while read -r img; do
            convert_file "$img"
        done
        echo -e "\n  ${C_GREEN}${I_OK} All $count images processed successfully!${C_RESET}"
    fi
else
    echo -e "  ${C_RED}[✘] Error: Path not found ($TARGET).${C_RESET}"
fi
