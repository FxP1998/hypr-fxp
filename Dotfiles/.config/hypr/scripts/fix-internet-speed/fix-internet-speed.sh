#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998/hypr-fxp

# --- TTY DETECTION & VISUALS ---
if [[ "$TERM" == "linux" || "$TERM" == "dumb" ]]; then
    # TTY Mode (Safe Text)
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
    I_NET="[NET]" I_PAC="[PAC]" I_SPD="[SPD]" I_FIX="[FIX]"
    I_OK="[OK]" I_NO="[!!]" I_ASK="[??]" I_WAIT="..."
else
    # GUI Mode (Professional Octicons)
    RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[0;33m' BLUE='\033[0;34m' NC='\033[0m'
    
    # Octicons (Consistent with Dot-Manager)
    I_NET=""      # Wifi (fa)
    I_PAC=""      # Package
    I_SPD=""      # Rocket/Upload
    I_FIX=""      # Tools
    I_OK=""       # Check
    I_NO=""       # X
    I_ASK=""      # Question
    I_WAIT=""     # Sync/Spin
fi

# --- UI HELPERS ---
header() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "         ${I_NET}   FxP NETWORK & PACMAN SUITE"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

msg_info() { echo -e "   ${YELLOW}${I_WAIT}  $1${NC}"; }
msg_success() { echo -e "   ${GREEN}${I_OK}  $1${NC}"; }
msg_error() { echo -e "   ${RED}${I_NO}  $1${NC}"; }
msg_ask() { echo -e "   ${BLUE}${I_ASK}  $1${NC}"; }

# --- 1. MIRROR OPTIMIZER ---
optimize_mirrors() {
    header
    echo -e "${YELLOW}   :: OPTIMIZE DOWNLOAD SPEED${NC}"
    echo ""

    # Check Reflector
    if ! command -v reflector &> /dev/null; then
        msg_info "Installing 'reflector' tool..."
        sudo pacman -S --noconfirm reflector >/dev/null
    fi

    # Location Logic
    msg_ask "Are you located in INDIA? (y/n)"
    read -p "      > " loc_choice

    if [[ "${loc_choice,,}" == "y" ]]; then
        COUNTRY="India"
        REGION_TXT="INDIA"
    else
        echo ""
        msg_ask "Enter Country Name (Leave empty for GLOBAL):"
        read -p "      > " custom_country
        if [[ -z "$custom_country" ]]; then
            COUNTRY=""
            REGION_TXT="GLOBAL (Fastest)"
        else
            COUNTRY="$custom_country"
            REGION_TXT="$custom_country"
        fi
    fi

    echo ""
    msg_info "Generating mirrorlist for: $REGION_TXT"
    echo "      (Timeout: 5s | Protocol: HTTPS | Sort: Rate)"
    
    # Build Command
    CMD="sudo reflector --protocol https --latest 10 --sort rate --download-timeout 5 --save /etc/pacman.d/mirrorlist"
    [[ -n "$COUNTRY" ]] && CMD="$CMD --country '$COUNTRY'"

    # Run
    if eval "$CMD"; then
        echo ""
        msg_success "Mirrors updated successfully!"
    else
        echo ""
        msg_error "Failed. Check your internet connection."
    fi
    
    read -p ""
}

# --- 2. PACMAN BOOST ---
boost_pacman() {
    header
    echo -e "${YELLOW}   :: BOOST PACMAN CONFIGURATION${NC}"
    echo ""
    
    CONF="/etc/pacman.conf"
    
    msg_info "Applying visual & performance tweaks..."
    echo ""

    # ILoveCandy
    if grep -q "ILoveCandy" "$CONF"; then
        echo -e "      ${GREEN}•${NC} ILoveCandy is active."
    else
        sudo sed -i '/^\[options\]/a ILoveCandy' "$CONF"
        echo -e "      ${GREEN}+${NC} Enabled ILoveCandy (Animation)."
    fi

    # Parallel Downloads
    sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' "$CONF"
    sudo sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 8/' "$CONF"
    echo -e "      ${GREEN}+${NC} Set Parallel Downloads to 8."

    echo ""
    msg_success "Configuration optimized."
    sleep 2
}

# --- 3. NETWORK REPAIR ---
repair_net() {
    header
    echo -e "${YELLOW}   :: NETWORK REPAIR TOOL${NC}"
    echo ""

    msg_info "Unblocking WiFi (rfkill)..."
    sudo rfkill unblock wifi
    sleep 1

    msg_info "Restarting Network Manager..."
    sudo systemctl restart NetworkManager
    
    echo ""
    msg_success "Services restarted. Please wait for reconnection."
    sleep 3
}

# --- MAIN MENU ---
while true; do
    header
    echo -e "   ${YELLOW}1)${NC}  ${I_SPD}   Optimize Mirrors (Speed Fix)"
    echo -e "        ${BLUE}└─ Auto-detect India or Custom Region${NC}"
    echo ""
    echo -e "   ${YELLOW}2)${NC}  ${I_PAC}   Boost Pacman Config"
    echo -e "        ${BLUE}└─ Enable 8x Parallel & Candy Animation${NC}"
    echo ""
    echo -e "   ${YELLOW}3)${NC}  ${I_FIX}   Restart Network Stack"
    echo -e "        ${BLUE}└─ Fix stuck WiFi or DNS issues${NC}"
    echo ""
    echo -e "   ${YELLOW}4)${NC}  Exit"
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "   Select Option: " opt

    case $opt in
        1) optimize_mirrors ;;
        2) boost_pacman ;;
        3) repair_net ;;
        4) clear; exit 0 ;;
        *) ;;
    esac
done
