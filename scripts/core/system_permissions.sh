#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: system_permissions.sh
#  󰁔  Description: Manages user groups and hardware permissions (SwayOSD fix).
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_LOCK="[SEC]"; I_OK="[OK]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    I_LOCK="󰒓"; I_OK="󰄬"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
# Required groups for a healthy Hyprland/SwayOSD/Virt environment
REQUIRED_GROUPS=("input" "video" "render" "storage" "libvirt" "kvm")

print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_LOCK}  ${C_BOLD}SYSTEM PERMISSIONS & GROUPS${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

# --- Execution ---
print_header

echo -e "  ${I_INFO} Configuring user groups for hardware access..."
for grp in "${REQUIRED_GROUPS[@]}"; do
    if ! groups "$USER" | grep -q "\b$grp\b"; then
        echo -ne "      ${I_INFO} Adding $USER to group: ${C_YELLOW}$grp${C_RESET}..."
        sudo usermod -aG "$grp" "$USER"
        echo -e " ${C_GREEN}${I_OK}${C_RESET}"
    else
        echo -e "      ${C_GREEN}${I_OK}${C_RESET} User already in group: $grp"
    fi
done

echo -e "\n  ${I_INFO} Applying hardware rules (SwayOSD/udev)..."
if [ -f "/usr/lib/udev/rules.d/99-swayosd.rules" ] || [ -f "/etc/udev/rules.d/99-swayosd.rules" ]; then
    sudo udevadm control --reload-rules && sudo udevadm trigger
    echo -e "      ${C_GREEN}${I_OK}${C_RESET} Udev rules reloaded and triggered."
else
    echo -e "      ${C_YELLOW}[!]${C_RESET} SwayOSD rules not found. Skipping udev trigger."
fi

echo -e "\n${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
echo -e "  ${I_OK}  ${C_BOLD}SYSTEM PERMISSIONS CONFIGURED!${C_RESET}"
echo -e "  ${I_INFO} Note: Group changes require a reboot to take full effect."
echo -e "${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
