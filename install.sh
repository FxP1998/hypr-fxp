#!/usr/bin/env bash

# === COLORS ===
# Basic ANSI escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m' # Reset
BOLD='\033[1m'

# Bright colors
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'

# === SCRIPT STARTS FROM HERE ===
echo -e "${GREEN}===================================================="
echo -e "${GREEN}==                                                =="
echo -e "${GREEN}==   Starting hypr-FxP dotfiles installation...   =="
echo -e "${GREEN}==                                                =="
echo -e "${GREEN}===================================================="

# Sleep 1 Second
sleep 1

# Clear Screen
clear

# === Installing git and base-devel ===
~/hypr-fxp_dotfiles/helper/install_pre-reqrements.sh

# Sleep 1 Second
sleep 1

# Clear Screen
clear

# === Installing Pakages ===
~/hypr-fxp_dotfiles/helper/install_pre-reqrements.sh

# Sleep 1 Second
sleep 1

# Clear Screen
clear
