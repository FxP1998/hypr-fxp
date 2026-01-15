#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${BLUE}▶ STARTING AUTO-CPUFREQ INSTALLER (By FxP)...${RESET}"

set -e

# Checks
[[ -f /etc/arch-release ]] || { echo -e "${RED}[ERROR] This script only supports Arch Linux.${RESET}"; exit 1; }
command -v sudo >/dev/null || { echo -e "${RED}[ERROR] sudo is required.${RESET}"; exit 1; }

# Install dependencies
echo -e "${BLUE}:: Installing dependencies (git, base-devel)...${RESET}"
sudo pacman -Sy --needed --noconfirm git base-devel &> /dev/null

# Build & install
WORKDIR="/tmp/auto-cpufreq-build"
if ! command -v auto-cpufreq &> /dev/null; then
    echo -e "${BLUE}:: Preparing build directory at $WORKDIR...${RESET}"
    rm -rf "$WORKDIR"
    mkdir -p "$WORKDIR"
    cd "$WORKDIR"

    echo -e "${BLUE}:: Cloning auto-cpufreq AUR repo...${RESET}"
    git clone https://aur.archlinux.org/auto-cpufreq.git &> /dev/null
    cd auto-cpufreq

    echo -e "${BLUE}:: Building package...${RESET}"
    makepkg -si --noconfirm &> /dev/null
else
    echo -e "${GREEN}:: auto-cpufreq is already installed. Skipping build.${RESET}"
fi

# Config Setup
# We look for auto-cpufreq.conf in the same folder as this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_CONFIG="$SCRIPT_DIR/auto-cpufreq.conf"
SYSTEM_CONFIG="/etc/auto-cpufreq.conf"

echo -e "${BLUE}:: Setting up configuration...${RESET}"

if [[ -f "$LOCAL_CONFIG" ]]; then
  echo -e "${GREEN}➤ Found custom config. Installing to $SYSTEM_CONFIG...${RESET}"
  
  # Backup existing
  if [[ -f "$SYSTEM_CONFIG" ]]; then
      sudo mv "$SYSTEM_CONFIG" "${SYSTEM_CONFIG}.bak.$(date +%s)"
      echo -e "${YELLOW}➤ Backed up existing global config.${RESET}"
  fi
  
  # Install new config
  sudo cp "$LOCAL_CONFIG" "$SYSTEM_CONFIG"
else
  echo -e "${RED}[ERROR] auto-cpufreq.conf not found in script directory!${RESET}"
  echo -e "${YELLOW}Please place the config file next to this script.${RESET}"
  exit 1
fi

# Enable service
echo -e "${BLUE}:: Enabling auto-cpufreq service...${RESET}"
# Stop first to force reload of config
sudo systemctl stop auto-cpufreq.service 2>/dev/null || true
sudo systemctl enable --now auto-cpufreq.service

# Restart to ensure config is picked up
sudo systemctl restart auto-cpufreq.service

echo -e "${GREEN}✔ AUTO-CPUFREQ INSTALLED & CONFIGURED!${RESET}"
echo -e "${BLUE}▶ Battery: Powersave (Turbo OFF) | Charger: Performance (Turbo ON)${RESET}"
echo -e "${BLUE}▶ Check status with: sudo auto-cpufreq --stats${RESET}"cho -e "${BLUE}▶ Mode: Performance | Check status with 'auto-cpufreq --stats'${RESET}"
