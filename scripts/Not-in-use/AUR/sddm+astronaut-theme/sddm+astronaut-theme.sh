#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"
BOLD="\033[1m"

echo -e "${BLUE}▶ STARTING SDDM + ASTRONAUT THEME SETUP (By FxP)...${RESET}"

set -e

# Checks
[[ -f /etc/arch-release ]] || { echo -e "${RED}[ERROR] This script only supports Arch Linux.${RESET}"; exit 1; }
command -v sudo >/dev/null || { echo -e "${RED}[ERROR] sudo is required.${RESET}"; exit 1; }

# Install SDDM
echo -e "${BLUE}:: Installing SDDM & Dependencies...${RESET}"
sudo pacman -Sy --needed --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg &> /dev/null

# Install Astronaut Theme
echo -e "${BLUE}:: Downloading Astronaut Theme Installer...${RESET}"
echo -e "${YELLOW}➤ You will be prompted to choose a theme interactively.${RESET}"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

# Enable SDDM
echo -e "${BLUE}:: Enabling SDDM service...${RESET}"
sudo systemctl enable sddm.service

echo -e "${GREEN}✔ SDDM SETUP COMPLETE!${RESET}"
echo -e "${BLUE}▶ Reboot to see your new login screen.${RESET}"
