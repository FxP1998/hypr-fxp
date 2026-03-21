#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Official Master Installer for Hyprland Rice (Eyecandy & Robust)

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (Standard ASCII)
    I_ROCKET="[*]"; I_OK="[OK]"; I_FAIL="[!!]"; I_GEAR="[*]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE (Nerd Fonts)
    I_ROCKET="󰓅"; I_OK="󰄬"; I_FAIL="󰅖"; I_GEAR="󰒓"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Path Configuration ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$REPO_ROOT/scripts"

# Define the sequence of specialized scripts
PHASES=(
    "core/package_list.sh"       # Phase 1: Core System & Packages
    "core/system_permissions.sh" # Phase 2: User Groups & Hardware Rules
    "tuning/media_tuning.sh"     # Phase 3: Hardware & Media Optimization
    "install/copy_files.sh"      # Phase 4: Surgical Dotfile Sync
    "core/path_sanitizer.sh"     # Phase 5: Global User Path Correction
    "install/shell_themes.sh"    # Phase 6: Shell, Themes & Editors
    "install/displaymanager.sh"  # Phase 7: Display Manager Wizard
    "install/services.sh"        # Phase 8: Service Health & Finalization
)

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_ROCKET}  ${C_BOLD}FxP1998 HYPRLAND RICE MASTER INSTALLER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

# --- Check Environment ---
# 1. TTY Enforcement (Only run in pure TTY, not emulators)
if [[ $(tty) == /dev/pts/* ]]; then
    clear
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_FAIL}  ${C_BOLD}TERMINAL EMULATOR DETECTED${C_RESET}"
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}\n"
    echo -e "  ${I_INFO} For a safe and perfect installation, this script"
    echo -e "      MUST be run from a pure TTY (Virtual Console)."
    echo -e "\n  ${C_YELLOW}Please switch to a TTY (Ctrl+Alt+F3) and run again.${C_RESET}"
    echo -e "\n${C_RED}${C_BOLD}${LINE}${C_RESET}"
    exit 1
fi

# 2. Root Check (Must run as normal user)
if [ "$EUID" -eq 0 ]; then
    echo -e "${C_RED}${I_FAIL} Error: Please run this script as your NORMAL user (not root).${C_RESET}"
    exit 1
fi

# 3. Sudo Handler (Ask once, keep alive)
print_header
echo -e "  ${I_INFO} This installer requires administrative privileges for system tasks."
echo -e "  ${I_INFO} Please enter your password when prompted.\n"

# Prompt for sudo password up front
if ! sudo -v; then
    echo -e "\n${C_RED}${I_FAIL} Sudo authentication failed. Aborting.${C_RESET}"
    exit 1
fi

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- Execution ---
print_header

echo -e "  ${I_INFO} Welcome, ${C_YELLOW}${USER}${C_RESET}! Preparing to install the perfect Hyprland environment."
echo -e "  ${I_INFO} Total Phases: ${C_BLUE}${#PHASES[@]}${C_RESET}\n"

# Verify all scripts exist before starting
for script in "${PHASES[@]}"; do
    if [ ! -f "$SCRIPTS_DIR/$script" ]; then
        echo -e "${C_RED}${I_FAIL} Critical Error: Script '$script' not found in $SCRIPTS_DIR!${C_RESET}"
        exit 1
    fi
    chmod +x "$SCRIPTS_DIR/$script"
done

# Run each phase
count=1
for script in "${PHASES[@]}"; do
    echo -e "${C_BLUE}${C_BOLD}Phase $count/${#PHASES[@]}: Executing $script...${C_RESET}"
    echo -e "${C_BLUE}${LINE}${C_RESET}"
    
    # Run the script
    if ! bash "$SCRIPTS_DIR/$script"; then
        echo -e "\n${C_RED}${I_FAIL} Phase $count ($script) failed! Aborting installation.${C_RESET}"
        exit 1
    fi
    
    echo -e "\n"
    ((count++))
done

# --- Final Completion ---
print_header
echo -e "  ${C_GREEN}${C_BOLD}${I_OK} INSTALLATION SUCCESSFUL!${C_RESET}"
echo -e "  ${I_INFO} Your Hyprland environment is now fully tuned and ready."
echo -e "  ${I_INFO} Please ${C_RED}${C_BOLD}reboot${C_RESET} your system to apply all changes."
echo -e "\n${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
