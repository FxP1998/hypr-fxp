#!/usr/bin/env bash

# Installing Required Packages for my ultimate zip extractor
# Required packages are: unzip unrar p7zip zstd xz gzip bzip2 tar

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    Ultimate ZIP Extractor Installer    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}Installing required packages...${NC}"
echo -e "${YELLOW}Packages: unzip unrar p7zip zstd xz gzip bzip2 tar${NC}"
echo ""

sudo pacman -S --needed --noconfirm unzip unrar p7zip zstd xz gzip bzip2 tar

echo ""
echo -e "${GREEN}✓ Packages installed successfully!${NC}"
echo ""
echo -e "${YELLOW}╔════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║             IMPORTANT NOTE             ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "To use the extractor, copy the alias from:"
echo -e "${BLUE}~/.config/Fxp-Hyprland/Scripts/post-install/ultimate-zip-extractor/alias-ultimate-extractor${NC}"
echo -e "to your shell configuration file (${YELLOW}.bashrc${NC} or ${YELLOW}.zshrc${NC})"
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
