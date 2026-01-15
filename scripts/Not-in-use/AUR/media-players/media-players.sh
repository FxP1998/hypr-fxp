#!/bin/bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${BLUE}▶ STARTING MEDIA PLAYER SETUP (By FxP)...${NC}"
echo -e "${BLUE}:: Goal: Fix H.264 codec errors & Install Players${NC}"

# 1. Resolve conflicts
if pacman -Qs jack2 > /dev/null; then
    echo -e "${BLUE}:: Removing conflicting jack2...${NC}"
    sudo pacman -Rdd --noconfirm jack2 &> /dev/null
fi

# 2. Install plugins
echo -e "${BLUE}:: Installing VLC, MPV, and FFmpeg codecs...${NC}"
PACKAGES=(
    obs-studio
    vlc
    vlc-plugin-ffmpeg
    vlc-plugins-extra
    vlc-plugins-all
    mpv
    intel-media-driver
    libva-intel-driver
    pipewire-jack
)

if sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"; then
    echo -e "${GREEN}✔ Success! H.264 plugins installed.${NC}"
    echo -e "${BLUE}▶ Restart VLC/MPV to see changes.${NC}"
else
    echo -e "${RED}[ERROR] Installation failed. Check internet connection.${NC}"
    exit 1
fi
