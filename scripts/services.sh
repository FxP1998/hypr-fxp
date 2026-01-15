#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Self-healing script for System Services

# --- VISUAL & COMPATIBILITY ENGINE ---
if [[ "$TERM" == "linux" ]]; then
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_OK="[OK]"; IC_FAIL="[!!]"; IC_FIX="[FIX]"; IC_INFO="->"
else
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_OK="✔"; IC_FAIL="✖"; IC_FIX="🔧"; IC_INFO="➜"
fi

SYSTEM_SERVICES=("NetworkManager" "bluetooth")
USER_SERVICES=("pipewire" "pipewire-pulse" "wireplumber")

echo -e "${C_BLUE}${IC_INFO} Checking Service Health...${C_RESET}"

# System Services
for service in "${SYSTEM_SERVICES[@]}"; do
    if ! systemctl is-active --quiet "$service"; then
        echo -e "   ${C_RED}${IC_FIX} Starting $service...${C_RESET}"
        sudo systemctl enable --now "$service"
    else
        echo -e "   ${C_GREEN}${IC_OK} $service is running.${C_RESET}"
    fi
done

# User Services
for service in "${USER_SERVICES[@]}"; do
    if ! systemctl --user is-active --quiet "$service"; then
        echo -e "   ${C_RED}${IC_FIX} Starting user service $service...${C_RESET}"
        systemctl --user enable --now "$service"
    else
        echo -e "   ${C_GREEN}${IC_OK} $service is running.${C_RESET}"
    fi
done

# --- SERVICE PERMISSIONS FIX ---
echo -e "\n${C_BLUE}${IC_INFO} Fixing service permissions...${C_RESET}"

# Ensure user service directory exists and has correct permissions
USER_SERVICE_DIR="$HOME/.config/systemd/user"
if [ ! -d "$USER_SERVICE_DIR" ]; then
    mkdir -p "$USER_SERVICE_DIR"
    echo -e "   ${C_GREEN}${IC_OK} Created user service directory.${C_RESET}"
fi

# Reload user daemon to pick up changes
systemctl --user daemon-reload
echo -e "   ${C_GREEN}${IC_OK} User daemon reloaded.${C_RESET}"

echo -e "${C_GREEN}${IC_OK} All Services Checked.${C_RESET}"
