#!/usr/bin/env bash

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (Standard ASCII)
    I_CHECK="[OK]"; I_INFO="[i]"; I_WIZARD="[*]"; I_GEAR="[*]"; I_ARROW="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE (Nerd Fonts)
    I_CHECK="󰄬"; I_INFO="󰋽"; I_WIZARD="󱄛"; I_GEAR="󰒓"; I_ARROW="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${I_WIZARD}  ${C_BOLD}Display Manager & Theme Setup${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

print_step() { echo -e "  ${C_BLUE}${C_BOLD}[${C_RESET}${I_GEAR}${C_BLUE}${C_BOLD}]${C_RESET} $1"; }
print_success() { echo -e "  ${C_GREEN}${C_BOLD}[${C_RESET}${I_CHECK}${C_GREEN}${C_BOLD}]${C_RESET} $1\n"; }
print_error() { echo -e "  ${C_RED}${C_BOLD}[✘]${C_RESET} $1\n"; }

disable_active_dms() {
    local dms=("sddm" "gdm" "lightdm" "ly" "lxdm" "slim")
    print_step "Detecting active display managers..."
    for dm in "${dms[@]}"; do
        if systemctl is-enabled "$dm.service" &>/dev/null; then
            echo -e "      ${I_ARROW} Found $dm.service. Disabling..."
            sudo systemctl disable "$dm.service" &>/dev/null
        fi
        # Also stop the service if it's currently running
        if systemctl is-active "$dm.service" &>/dev/null; then
             sudo systemctl stop "$dm.service" &>/dev/null
        fi
    done
}

# --- Installation Functions ---
install_sddm_astronaut() {
    print_step "Checking for SDDM base package..."
    if ! command -v sddm &> /dev/null; then
        echo -e "      ${I_ARROW} SDDM not found. Installing..."
        sudo pacman -S --needed --noconfirm sddm
    fi

    disable_active_dms()
    
    print_step "Executing Astronaut Theme installer..."
    # Running as NORMAL user (installer blocks root)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
    
    print_step "Enabling SDDM service..."
    sudo systemctl enable sddm.service
    print_success "SDDM Astronaut Theme is now active!"
}

install_ly() {
    print_step "Checking for Ly Display Manager..."
    if ! command -v ly &> /dev/null; then
        echo -e "      ${I_ARROW} Ly not found. Installing via yay..."
        if command -v yay &> /dev/null; then
            yay -S --needed --noconfirm ly
        else
            sudo pacman -S --needed --noconfirm ly
        fi
    fi

    disable_active_dms

    print_step "Configuring Ly for TTY2..."
    if [ -f /etc/ly/config.ini ]; then
        sudo sed -i 's/^#tty = 2/tty = 2/' /etc/ly/config.ini 2>/dev/null
        sudo sed -i 's/^tty = [0-9]*/tty = 2/' /etc/ly/config.ini 2>/dev/null
    else
        echo -e "      ${I_ARROW} Creating default config at /etc/ly/config.ini..."
        sudo mkdir -p /etc/ly
        echo "tty = 2" | sudo tee /etc/ly/config.ini > /dev/null
    fi

    print_step "Enabling Ly service..."
    sudo systemctl enable ly.service
    print_success "Ly is configured and enabled on TTY2!"
}

# --- Main Interface ---
print_header

echo -e "\n  ${C_BOLD}Please select your preference:${C_RESET}"
echo -e "  ${C_BLUE}1)${C_RESET} SDDM Astronaut Theme ${C_YELLOW}(Modern & Graphic)${C_RESET}"
echo -e "  ${C_BLUE}2)${C_RESET} Ly Display Manager    ${C_YELLOW}(Minimalist TTY)${C_RESET}"
echo -e "  ${C_BLUE}3)${C_RESET} Exit Wizard\n"

echo ""
read -p "  Selection [1-3]: " choice

case $choice in
    1) install_sddm_astronaut ;;
    2) install_ly ;;
    3) echo -e "\n  See you later!"; exit 0 ;;
    *) print_error "Invalid selection." ; exit 1 ;;
esac
