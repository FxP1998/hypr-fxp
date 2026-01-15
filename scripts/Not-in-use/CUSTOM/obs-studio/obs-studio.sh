#!/bin/bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${BLUE}▶ STARTING OBS STUDIO SETUP (By FxP)...${NC}"

# Update system first
echo -e "${BLUE}:: Updating system package database...${NC}"
sudo pacman -Syu --noconfirm &> /dev/null

# Resolve the JACK conflict forcefully
echo -e "${BLUE}:: Resolving jack2/pipewire-jack conflict...${NC}"
if pacman -Qs jack2 > /dev/null; then
    sudo pacman -Rdd --noconfirm jack2 &> /dev/null
    echo -e "${GREEN}✔ Removed conflicting jack2.${NC}"
fi

# Install OBS and Intel drivers
echo -e "${BLUE}:: Installing OBS Studio and Intel drivers...${NC}"
if sudo pacman -S --needed --noconfirm obs-studio intel-media-driver libva-intel-driver pipewire-jack; then
    echo -e "${GREEN}✔ Installation complete! OBS is ready.${NC}"
else
    echo -e "${RED}[ERROR] Something went wrong during installation.${NC}"
    exit 1
fi
