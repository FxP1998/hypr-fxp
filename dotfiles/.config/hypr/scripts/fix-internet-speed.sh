#!/bin/bash

echo "󰓦  Turbocharging pacman speed..."

# Nerd Font icons
ICON_SUCCESS="󰄴"
ICON_WARNING="󰀧"
ICON_ERROR="󰚌"
ICON_SPEED="󰓅"
ICON_NETWORK="󰤨"
ICON_MIRROR="󰉼"
ICON_CLEAN="󰃢"
ICON_DOWNLOAD="󰇚"
ICON_TIME="󰥔"
ICON_ROCKET="󰓅"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}${ICON_SUCCESS}${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}${ICON_WARNING}${NC} $1"
}

print_error() {
    echo -e "${RED}${ICON_ERROR}${NC} $1"
}

print_info() {
    echo -e "${BLUE}󰋼${NC} $1"
}

print_network() {
    echo -e "${CYAN}${ICON_NETWORK}${NC} $1"
}

print_mirror() {
    echo -e "${PURPLE}${ICON_MIRROR}${NC} $1"
}

# Header
echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           󰣇  Pacman Speed Booster      ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Stop reflector service
print_network "Stopping reflector service..."
sudo systemctl stop reflector.service 2>/dev/null

# Generate fast Indian mirrors
print_mirror "Generating fast Indian mirrors 󰍛..."
sudo reflector --country India --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Add parallel downloads to pacman.conf if not exists
if ! grep -q "ParallelDownloads" /etc/pacman.conf; then
    print_info "Enabling parallel downloads 󰧑..."
    echo 'ParallelDownloads = 5' | sudo tee -a /etc/pacman.conf
fi

# Update package database
print_network "Updating package database 󰑬..."
sudo pacman -Syy

# Clean package caches
print_info "Cleaning package caches ${ICON_CLEAN}..."
sudo pacman -Scc --noconfirm

# Test speed with a small package
print_info "Testing download speed ${ICON_DOWNLOAD}..."
echo -e "${CYAN}────────────────────────────────────────${NC}"
START_TIME=$(date +%s)
sudo pacman -S --noconfirm neofetch 2>&1 | grep -E '(Downloading|Total Size)' | head -5
END_TIME=$(date +%s)

TIME_TAKEN=$((END_TIME - START_TIME))
echo -e "${CYAN}────────────────────────────────────────${NC}"

if [ $TIME_TAKEN -lt 10 ]; then
    echo -e "${GREEN}${ICON_ROCKET} SUCCESS! Pacman is now running at lightning speed! ⚡${NC}"
    echo -e "${GREEN}${ICON_TIME} Download completed in ${TIME_TAKEN} seconds${NC}"
else
    print_warning "Speed is acceptable but let me try one more optimization..."
    
    # Try with Singapore mirrors as backup
    print_mirror "Trying Singapore mirrors as backup 󰍞..."
    sudo reflector --country India,Singapore --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -Syy
    
    echo -e "${GREEN}${ICON_SUCCESS} Mirrors optimized with Singapore backup${NC}"
fi

# Final success message
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    󰄴  Pacman speed fix complete! 󰄴     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}󰌶  Usage tips:${NC}"
echo -e "  ${CYAN}󰅂${NC} Run: ${GREEN}fix-pacman-speed${NC}"
echo -e "  ${CYAN}󰅂${NC} Or use: ${GREEN}fixnet${NC}"
echo -e "  ${CYAN}󰅂${NC} Keybind: ${YELLOW}Super+Alt+S${NC} (if configured)"
echo ""
