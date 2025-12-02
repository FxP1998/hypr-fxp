#!/usr/bin/env bash

# === COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'
BOLD='\033[1m'

BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'

# Print fancy header
print_header() {
  clear
  echo -e "${BRIGHT_GREEN}"
  echo "╔══════════════════════════════════════════════════╗"
  echo "║           hypr-FxP Dotfiles Installer            ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

# === SCRIPT STARTS FROM HERE ===
print_header

echo -e "${CYAN}Starting installation process...${RESET}"
echo ""
sleep 1

# === Installing git and base-devel ===
echo -e "${BLUE}══════════════════════════════════════════════════${RESET}"
echo -e "${BLUE}         Step 1: Installing Prerequisites         ${RESET}"
echo -e "${BLUE}══════════════════════════════════════════════════${RESET}"
echo ""
~/hypr-fxp_dotfiles/helper/install_prerequisites.sh
sleep 1

print_header
echo -e "${GREEN}✓ Prerequisites installed${RESET}"
echo ""
sleep 0.5

# === Installing Pakages ===
echo -e "${BLUE}══════════════════════════════════════════════════${RESET}"
echo -e "${BLUE}           Step 2: Installing Packages            ${RESET}"
echo -e "${BLUE}══════════════════════════════════════════════════${RESET}"
echo ""
~/hypr-fxp_dotfiles/helper/install-pakages.sh
sleep 1

print_header
echo -e "${GREEN}✓ Packages installed${RESET}"
echo ""
sleep 0.5

# === Installing Dotfiles ===
echo -e "${BLUE}══════════════════════════════════════════════════${RESET}"
echo -e "${BLUE}          Step 3: Installing Dotfiles             ${RESET}"
echo -e "${BLUE}══════════════════════════════════════════════════${RESET}"
echo ""
~/hypr-fxp_dotfiles/helper/install-dotfiles.sh
sleep 1

print_header
echo -e "${BRIGHT_GREEN}══════════════════════════════════════════════════${RESET}"
echo -e "${BRIGHT_GREEN}            Installation Complete!                ${RESET}"
echo -e "${BRIGHT_GREEN}══════════════════════════════════════════════════${RESET}"
echo ""
echo -e "${GREEN}✅ All components installed successfully!${RESET}"
echo ""
echo -e "${YELLOW}Note: Restart your session for changes to take effect.${RESET}"
echo ""
