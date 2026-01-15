#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998
# DESCRIPTION: Smart Image to PNG Converter (Path Aware)

# --- Nerd Font Icons ---
ICON_IMG="󰋩"
ICON_DIR="󰉋"
ICON_WORK="󰚰"

# Colors
BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

TARGET="${1:-.}" # Use argument if provided, otherwise current directory

convert_file() {
    local file="$1"
    if [[ "$file" == *.png ]]; then return; fi
    echo -e "${BLUE}$ICON_WORK Converting:${NC} $(basename "$file")"
    magick "$file" "${file%.*}.png" && rm "$file"
}

echo -e "${BLUE}$ICON_IMG FxP Image Converter${NC}"

if [ -f "$TARGET" ]; then
    convert_file "$TARGET"
    echo -e "${GREEN}󰄬 Done!${NC}"
elif [ -d "$TARGET" ]; then
    echo -e "${YELLOW}$ICON_DIR Processing directory:${NC} $TARGET"
    find "$TARGET" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) | while read -r img; do
        convert_file "$img"
    done
    echo -e "${GREEN}󰄬 All images in folder converted!${NC}"
else
    echo -e "${RED}✘ Error: Path not found.${NC}"
fi
