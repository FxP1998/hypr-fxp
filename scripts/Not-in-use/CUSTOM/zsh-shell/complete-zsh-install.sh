#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${BLUE}▶ STARTING ZSH & PLUGINS INSTALLER (By FxP)...${RESET}"

echo -e "${BLUE}:: Installing ZSH and essential plugins...${RESET}"
if sudo pacman -S --needed --noconfirm zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-autocomplete; then
    echo -e "${GREEN}✔ ZSH installation complete!${RESET}"
    echo -e "${BLUE}▶ NOTE: Plugins installed for user: $USER${RESET}"
else
    echo -e "${RED}[ERROR] Installation failed.${RESET}"
    exit 1
fi
