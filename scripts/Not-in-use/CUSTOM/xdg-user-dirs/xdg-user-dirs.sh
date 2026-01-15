#!/bin/bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}▶ SETTING UP XDG USER DIRECTORIES (By FxP)...${NC}"

# Detect package manager
if ! command -v pacman >/dev/null; then
    echo -e "${RED}[ERROR] No supported package manager found.${NC}"
    exit 1
fi

# Install
echo -e "${BLUE}:: Installing xdg-user-dirs...${NC}"
sudo pacman -S --needed --noconfirm xdg-user-dirs &> /dev/null

# Update directories
echo -e "${BLUE}:: Creating standard folders (Music, Downloads, etc.)...${NC}"
xdg-user-dirs-update

echo -e "${GREEN}✔ Done! Your home folders are ready.${NC}"
