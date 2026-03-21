#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  FxP1998 VIRTUALIZATION SUITE
#  󰀻  File: virt_setup.sh
#  󰁔  Description: Surgical setup for Libvirt and Virt-Manager GUI.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_VM="[VIRT]"; I_OK="[OK]"; I_INFO="->"; I_GEAR="[*]"; LINE="----------------------------------------------------"
else
    I_VM="󰐿"; I_OK="󰄬"; I_INFO="󰁔"; I_GEAR="󰒓"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- UI Helpers ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_VM}  ${C_BOLD}FxP1998 VIRT-MANAGER SETUP SUITE${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

msg_info() { echo -e "  ${C_BLUE}${I_INFO}${C_RESET} $1"; }
msg_success() { echo -e "  ${C_GREEN}${I_OK}${C_RESET} $1"; }
msg_error() { echo -e "  ${C_RED}[✘]${C_RESET} $1"; }

# --- Phase 1: Installation & Groups ---
setup_environment() {
    print_header
    msg_info "Step 1: Configuring user permissions..."
    
    # Add to groups
    for grp in "libvirt" "kvm"; do
        if ! groups "$USER" | grep -q "\b$grp\b"; then
            echo -ne "      ${I_INFO} Adding $USER to group: ${C_YELLOW}$grp${C_RESET}..."
            sudo usermod -aG "$grp" "$USER"
            echo -e " ${C_GREEN}${I_OK}${C_RESET}"
        else
            echo -e "      ${C_GREEN}${I_OK}${C_RESET} User already in group: $grp"
        fi
    done

    msg_info "Step 2: Starting background services..."
    sudo systemctl enable --now libvirtd &>/dev/null
    sudo systemctl start libvirtd &>/dev/null
    msg_success "Libvirt daemon is active."

    msg_info "Step 3: Initializing default network stack..."
    sudo virsh net-define /etc/libvirt/qemu/networks/default.xml 2>/dev/null
    sudo virsh net-start default 2>/dev/null
    sudo virsh net-autostart default 2>/dev/null
    msg_success "Network 'default' (NAT) is ready."

    echo -e "\n  ${C_YELLOW}${I_INFO} Note: Reboot is highly recommended for group changes.${C_RESET}"
    read -p "  Press any key to return to menu..." -n 1 -s
}

# --- Phase 2: GUI Launch ---
launch_gui() {
    print_header
    msg_info "Launching Virt-Manager GUI..."
    nohup virt-manager > /dev/null 2>&1 &
    msg_success "GUI started. You can now setup your VMs manually."
    sleep 2
}

# --- MAIN MENU ---
while true; do
    print_header
    echo -e "  ${C_YELLOW}1)${C_RESET} ${I_GEAR}  Install Packages & Fix Permissions"
    echo -e "  ${C_YELLOW}2)${C_RESET} ${I_VM}    Launch Virt-Manager GUI"
    echo -e "  ${C_YELLOW}3)${C_RESET}  Exit\n"
    
    read -p "  Select Option [1-3]: " opt

    case $opt in
        1) setup_environment ;;
        2) launch_gui ;;
        3) clear; exit 0 ;;
        *) ;;
    esac
done
