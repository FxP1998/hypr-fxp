#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: fix-internet-speed.sh
#  󰁔  Description: Network repair and Pacman download speed optimization suite.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE
    I_NET="[NET]"; I_PAC="[PAC]"; I_SPD="[SPD]"; I_FIX="[FIX]"; I_OK="[OK]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE
    I_NET="󰖩"; I_PAC="󰏖"; I_SPD="󰓅"; I_FIX="󰒓"; I_OK="󰄬"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- UI Helpers ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_NET}  ${C_BOLD}FxP NETWORK & PACMAN OPTIMIZER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

msg_info() { echo -e "  ${C_BLUE}${I_INFO}${C_RESET} $1"; }
msg_success() { echo -e "  ${C_GREEN}${I_OK}${C_RESET} $1"; }
msg_error() { echo -e "  ${C_RED}[✘]${C_RESET} $1"; }

# --- 1. Mirror Optimizer ---
optimize_mirrors() {
    print_header
    echo -e "  ${C_BOLD}${I_SPD} OPTIMIZE DOWNLOAD SPEED${C_RESET}\n"

    if ! command -v reflector &> /dev/null; then
        msg_info "Installing 'reflector'..."
        sudo pacman -S --needed --noconfirm reflector
        echo "" 
    fi

    echo -e "\n  ${C_YELLOW}Please select your region:${C_RESET}"
    echo -e "  1) India (Fastest for you)"
    echo -e "  2) Global (World-wide mirrors)"
    echo -e "  3) Custom Country"
    echo ""
    read -p "  Selection [1-3]: " loc_choice

    case $loc_choice in
        1) COUNTRY="India"; REGION="INDIA" ;;
        2) COUNTRY=""; REGION="GLOBAL" ;;
        3) echo "" ; read -p "  Enter Country Name: " COUNTRY; REGION="$COUNTRY" ;;
        *) msg_error "Invalid selection."; sleep 2; return ;;
    esac

    echo ""
    msg_info "Generating fastest mirrors for: $REGION..."
    
    local CMD="sudo reflector --protocol https --latest 15 --sort rate --download-timeout 5 --save /etc/pacman.d/mirrorlist"
    [[ -n "$COUNTRY" ]] && CMD="$CMD --country '$COUNTRY'"

    if eval "$CMD"; then
        msg_success "Mirrors updated successfully!"
    else
        msg_error "Failed to update mirrors. Check your connection."
    fi
    echo -e "\n  Press any key to return to menu..."
    read -n 1 -s
}

# --- 2. Pacman Boost ---
boost_pacman() {
    print_header
    echo -e "  ${C_BOLD}${I_PAC} BOOST PACMAN CONFIGURATION${C_RESET}\n"
    
    local CONF="/etc/pacman.conf"
    msg_info "Applying visual & performance tweaks..."

    # ILoveCandy
    if ! grep -q "ILoveCandy" "$CONF"; then
        sudo sed -i '/^\[options\]/a ILoveCandy' "$CONF"
        echo -e "      ${C_GREEN}+${C_RESET} Enabled ILoveCandy animation."
    fi

    # Parallel Downloads
    sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' "$CONF"
    sudo sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 8/' "$CONF"
    echo -e "      ${C_GREEN}+${C_RESET} Set Parallel Downloads to 8."

    msg_success "Configuration optimized."
    sleep 2
}

# --- 3. Network Repair ---
repair_net() {
    print_header
    echo -e "  ${C_BOLD}${I_FIX} NETWORK REPAIR TOOL${C_RESET}\n"

    msg_info "Unblocking hardware (rfkill)..."
    sudo rfkill unblock all
    
    msg_info "Restarting Network Manager..."
    sudo systemctl restart NetworkManager
    
    msg_success "Stack restarted. Reconnecting in a few seconds..."
    sleep 3
}

# --- MAIN MENU ---
while true; do
    print_header
    echo -e "  ${C_YELLOW}1)${C_RESET}  ${I_SPD} Optimize Mirrors (Speed Fix)"
    echo -e "  ${C_YELLOW}2)${C_RESET}  ${I_PAC} Boost Pacman Config (Performance)"
    echo -e "  ${C_YELLOW}3)${C_RESET}  ${I_FIX} Restart Network Stack (Repair)"
    echo -e "  ${C_YELLOW}4)${C_RESET}  Exit Suite\n"
    
    read -p "  Select Option [1-4]: " opt

    case $opt in
        1) optimize_mirrors ;;
        2) boost_pacman ;;
        3) repair_net ;;
        4) clear; exit 0 ;;
        *) ;;
    esac
done
