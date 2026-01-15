#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

set -e

# --- Colors ---
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

echo -e "${BLUE}▶ CHECKING & INSTALLING YAY (AUR HELPER)...${RESET}"

REQUIRED_PKGS=("git" "base-devel" "yay")
MISSING_PKGS=()

# Check packages
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -eq 0 ]; then
    echo -e "${GREEN}✔ git, base-devel, and yay are already installed.${RESET}"
    exit 0
fi

echo -e "${YELLOW}➤ Missing packages: ${MISSING_PKGS[*]}${RESET}"

# Install deps
for pkg in git base-devel; do
    if [[ " ${MISSING_PKGS[*]} " == *" $pkg "* ]]; then
        echo -e "${BLUE}:: Installing ${pkg}...${RESET}"
        sudo pacman -S --needed --noconfirm "$pkg"
    fi
done

# Install yay-bin
if [[ " ${MISSING_PKGS[*]} " == *" yay "* ]]; then
    echo -e "${BLUE}:: Installing yay (yay-bin)...${RESET}"
    rm -rf /tmp/yay-bin &> /dev/null
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
fi

echo -e "${GREEN}✔ INSTALLATION COMPLETED SUCCESSFULLY!${RESET}"
