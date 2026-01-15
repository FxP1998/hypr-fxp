#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Master Installer - Orchestrates the entire setup.

# --- VISUAL & COMPATIBILITY ENGINE ---
if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (No Emojis/Nerd Fonts)
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_ROCKET="[*]"; IC_GEAR="[*]"; IC_OK="[OK]"; IC_FAIL="[!!]"; IC_WARN="[!]"
    IC_INFO="->"; IC_ARROW=">"; LINE_DBL="==============================================="
    LINE_SNG="-----------------------------------------------"
else
    # GUI CANDY MODE
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_ROCKET="🚀"; IC_GEAR="⚙️ "; IC_OK="✔"; IC_FAIL="✖"; IC_WARN="⚠"
    IC_INFO="➜"; IC_ARROW="➥"; LINE_DBL="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    LINE_SNG="───────────────────────────────────────────────"
fi

# --- 1. DYNAMIC PATH DETECTION ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$REPO_ROOT/scripts"
SUDO_SCRIPT="$SCRIPTS_DIR/sudo-setup.sh"
SERVICE_SCRIPT="$SCRIPTS_DIR/services.sh"
USER_SCRIPT="$SCRIPTS_DIR/user-setup.sh"

clear
echo -e "${C_BLUE}${LINE_DBL}${C_RESET}"
echo -e "${C_BLUE}   ${IC_ROCKET}  FxP1998 MASTER INSTALLER       ${C_RESET}"       
echo -e "${C_BLUE}${LINE_DBL}${C_RESET}"

# Check: Do NOT run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${C_RED}${IC_FAIL} Error: Please run this script as your NORMAL user (do not use sudo).${C_RESET}"
    exit 1
fi

# Check: Verify sub-scripts exist
MISSING=0
for script in "$SUDO_SCRIPT" "$USER_SCRIPT" "$SERVICE_SCRIPT"; do
    if [ ! -f "$script" ]; then
        echo -e "${C_RED}${IC_FAIL} Missing script: $script${C_RESET}"
        MISSING=1
    fi
done
if [ "$MISSING" -eq 1 ]; then
    echo -e "${C_YELL}Please ensure all scripts are in the 'scripts/' folder.${C_RESET}"
    exit 1
fi

# PHASE 1: SYSTEM (Root)
echo -e "\n${C_BLUE}${LINE_SNG}${C_RESET}"
echo -e "   ${IC_GEAR} PHASE 1: System Packages & Drivers"
echo -e "${C_BLUE}${LINE_SNG}${C_RESET}"
chmod +x "$SUDO_SCRIPT"
# We pass the user explicitly to the sudo script
if sudo bash "$SUDO_SCRIPT" "$USER"; then
    echo -e "${C_GREEN}${IC_OK} Phase 1 Complete.${C_RESET}"
else
    echo -e "${C_RED}${IC_FAIL} Phase 1 failed. Aborting.${C_RESET}"
    exit 1
fi

# PHASE 2: SERVICES (Network/Audio)
echo -e "\n${C_BLUE}${LINE_SNG}${C_RESET}"
echo -e "   ${IC_GEAR} PHASE 2: Service Health Check"
echo -e "${C_BLUE}${LINE_SNG}${C_RESET}"
chmod +x "$SERVICE_SCRIPT"
bash "$SERVICE_SCRIPT"

# PHASE 3: USER (Dotfiles/Themes)
echo -e "\n${C_BLUE}${LINE_SNG}${C_RESET}"
echo -e "   ${IC_GEAR} PHASE 3: User Configs & Theming"
echo -e "${C_BLUE}${LINE_SNG}${C_RESET}"
chmod +x "$USER_SCRIPT"
if bash "$USER_SCRIPT"; then
    echo -e "${C_GREEN}${IC_OK} Phase 3 Complete.${C_RESET}"
else
    echo -e "${C_RED}${IC_FAIL} Phase 3 failed.${C_RESET}"
    exit 1
fi

echo -e "\n${C_GREEN}${LINE_DBL}${C_RESET}"
echo -e "${C_GREEN}   ${IC_OK} INSTALLATION SUCCESSFUL!   ${C_RESET}"
echo -e "   Please reboot your system to apply all changes."
echo -e "${C_GREEN}${LINE_DBL}${C_RESET}"
