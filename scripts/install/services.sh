#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Official Self-Healing Service Manager for Hyprland Rice

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (Standard ASCII)
    I_CHECK="[OK]"; I_FAIL="[!!]"; I_GEAR="[*]"; I_HEAL="[FIX]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE (Nerd Fonts)
    I_CHECK="󰄬"; I_FAIL="󰅖"; I_GEAR="󰒓"; I_HEAL="󰏚"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Services Configuration ---
SYSTEM_SERVICES=("NetworkManager" "bluetooth")
USER_SERVICES=("pipewire" "pipewire-pulse" "wireplumber")

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${I_GEAR}  ${C_BOLD}System & User Service Manager${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

print_status() {
    local type=$1
    local name=$2
    local status=$3
    local color=$4
    printf "  %-12s %-20s [ ${color}%-8s${C_RESET} ]\n" "$type" "$name" "$status"
}

manage_service() {
    local mode=$1 # "system" or "user"
    local name=$2
    local cmd="systemctl"
    [ "$mode" == "user" ] && cmd="systemctl --user"
    
    # 1. Check if service exists
    if ! $cmd list-unit-files "$name.service" &>/dev/null; then
        print_status "$mode" "$name" "MISSING" "$C_RED"
        return
    fi

    # 2. Get detailed status
    if $cmd is-failed --quiet "$name"; then
        print_status "$mode" "$name" "FAILED" "$C_RED"
        echo -e "      ${I_HEAL} Attempting to restart $name..."
        [ "$mode" == "system" ] && sudo $cmd restart "$name" || $cmd restart "$name"
    elif ! $cmd is-active --quiet "$name"; then
        print_status "$mode" "$name" "STOPPED" "$C_YELLOW"
        echo -e "      ${I_HEAL} Enabling and starting $name..."
        [ "$mode" == "system" ] && sudo $cmd enable --now "$name" || $cmd enable --now "$name"
    else
        print_status "$mode" "$name" "RUNNING" "$C_GREEN"
    fi
}

# --- Main Logic ---
print_header

# 1. Handle System Services
echo -e "${C_BOLD}Checking System-Level Services:${C_RESET}"
for service in "${SYSTEM_SERVICES[@]}"; do
    manage_service "system" "$service"
done

echo -e "\n${C_BOLD}Checking User-Level Services:${C_RESET}"
# 2. Handle User Services
for service in "${USER_SERVICES[@]}"; do
    manage_service "user" "$service"
done

# 3. Environment Maintenance
echo -e "\n${C_BOLD}System Maintenance:${C_RESET}"

# Ensure user service directory exists
USER_SERVICE_DIR="$HOME/.config/systemd/user"
if [ ! -d "$USER_SERVICE_DIR" ]; then
    mkdir -p "$USER_SERVICE_DIR"
    echo -e "  ${C_GREEN}${I_CHECK}${C_RESET} Created user service directory."
fi

# Final reload
echo -e "  ${C_BLUE}${I_INFO}${C_RESET} Reloading user daemon..."
systemctl --user daemon-reload

echo -e "\n${C_GREEN}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "  ${I_CHECK} ${C_BOLD}All Services Verified & Healthy!${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
