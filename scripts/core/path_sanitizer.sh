#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: path_sanitizer.sh
#  󰁔  Description: Surgically corrects hardcoded paths in INSTALLED files.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_FIX="[FIX]"; I_OK="[OK]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    I_FIX="󰒓"; I_OK="󰄬"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
# Use the repo as a MAP but target $HOME
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_SOURCE="$REPO_ROOT/dotfiles"
OLD_HOME="/home/broken"
NEW_HOME="$HOME"

print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_FIX}  ${C_BOLD}SURGICAL USER PATH SANITIZER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

# --- Execution ---
print_header

if [ "$OLD_HOME" == "$NEW_HOME" ]; then
    echo -e "  ${I_INFO} Paths already match system user (${C_YELLOW}$USER${C_RESET})."
    echo -e "  ${I_OK} Skipping sanitization."
    exit 0
fi

echo -e "  ${I_INFO} Scanning installed files in: ${C_GREEN}$HOME/${C_RESET}"
echo -e "  ${I_INFO} Correcting paths for: ${C_YELLOW}$USER${C_RESET}"
echo -e "  ${C_RED}[!] NOTE: Source files in $REPO_ROOT will remain untouched.${C_RESET}\n"

# 1. We use the dotfiles directory as a "Map"
# 2. For every file found in the repo, we look for the copy in $HOME
find "$DOTFILES_SOURCE" -type f -not -path '*/.git/*' | while read -r source_file; do
    
    # Get the relative path (e.g. .config/hypr/hyprland.conf)
    rel_path="${source_file#$DOTFILES_SOURCE/}"
    target_file="$HOME/$rel_path"

    # Fix the file in $HOME, NOT the one in the repo
    if [ -f "$target_file" ]; then
        if grep -q "$OLD_HOME" "$target_file"; then
            sed -i "s|$OLD_HOME|$NEW_HOME|g" "$target_file"
            echo -e "      ${C_GREEN}󰄬${C_RESET} Sanitized: ~/$rel_path"
        fi
    fi
done

echo -e "\n${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
echo -e "  ${I_OK}  ${C_BOLD}SURGICAL SANITIZATION COMPLETE!${C_RESET}"
echo -e "  ${I_INFO} Active system paths are corrected. Source repository is safe."
echo -e "${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
