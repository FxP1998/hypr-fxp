#!/usr/bin/env bash

# --- Colors & Icons ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_GEAR="[*]"; I_OK="[OK]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    I_GEAR="󰒓"; I_OK="󰄬"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_GEAR}  ${C_BOLD}SYSTEM UPDATE MANAGER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

# 1. Fetch current package count
PRE_PKGS=$(pacman -Qq | wc -l)

print_header
echo -e "  ${I_INFO} Starting full system upgrade (Arch + AUR)..."
echo -e "  ${I_INFO} Pre-update package count: ${C_YELLOW}$PRE_PKGS${C_RESET}\n"

# 2. Run update
# We use yay to handle both official and AUR
if yay -Syu; then
    echo -e "\n${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_OK} UPDATE COMPLETED SUCCESSFULLY!${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD}${LINE}${C_RESET}\n"
    
    # 3. Post-update stats
    POST_PKGS=$(pacman -Qq | wc -l)
    DIFF=$((POST_PKGS - PRE_PKGS))
    
    echo -e "  ${C_BOLD}Summary Report:${C_RESET}"
    echo -e "  ${I_INFO} New package count: ${C_YELLOW}$POST_PKGS${C_RESET}"
    
    if [ $DIFF -gt 0 ]; then
        echo -e "  ${I_INFO} Installed: ${C_GREEN}+$DIFF${C_RESET} packages"
    elif [ $DIFF -lt 0 ]; then
        echo -e "  ${I_INFO} Removed: ${C_RED}$DIFF${C_RESET} packages"
    else
        echo -e "  ${I_INFO} Upgraded: ${C_BLUE}All existing packages are current.${C_RESET}"
    fi
else
    echo -e "\n${C_RED}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${C_RED}[!] Error: Update process failed or was cancelled.${C_RESET}"
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}"
fi

echo -e "\n  ${I_INFO} Press any key to close this window..."
read -n 1 -s
