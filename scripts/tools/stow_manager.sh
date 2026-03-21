#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: stow_manager.sh
#  󰁔  Description: Advanced GNU Stow orchestrator with Surgical .config sync.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_STOW="[STOW]"; I_OK="[OK]"; I_INFO="->"; I_BACKUP="[B]"; I_GEAR="[*]"; LINE="----------------------------------------------------"
else
    I_STOW="󰒓"; I_OK="󰄬"; I_INFO="󰁔"; I_BACKUP="󰁯"; I_GEAR="󰒓"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Check Environment (TTY Enforcement) ---
if [[ $(tty) == /dev/pts/* ]]; then
    clear
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  [✘]  ${C_BOLD}TERMINAL EMULATOR DETECTED${C_RESET}"
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}\n"
    echo -e "  ${I_INFO} This script manages critical system symlinks and"
    echo -e "      MUST be run from a pure TTY (Virtual Console)."
    echo -e "\n  ${C_YELLOW}Please switch to a TTY (Ctrl+Alt+F3) and run again.${C_RESET}"
    echo -e "\n${C_RED}${C_BOLD}${LINE}${C_RESET}"
    exit 1
fi

# --- Configuration ---
REPO_ROOT="$HOME/FxP1998"
DOT_DIR="$REPO_ROOT/dotfiles"
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.FxP1998_backups/stow_$(date +%Y%m%d_%H%M%S)"

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_STOW}  ${C_BOLD}FxP1998 SURGICAL STOW MANAGER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

print_step() { echo -e "  ${C_BLUE}${C_BOLD}[${C_RESET}${I_GEAR}${C_BLUE}${C_BOLD}]${C_RESET} Phase $1: $2"; }

# Function to handle conflicts surgically
# This handles both root-level dotfiles AND sub-folders inside .config
prepare_stow_target() {
    local rel_path="$1" # e.g. ".zshrc" or ".config/hypr"
    local target="$TARGET_DIR/$rel_path"

    if [ -L "$target" ]; then
        # It's a symlink - check if it points to our repo
        local link_target=$(readlink -f "$target")
        if [[ "$link_target" == "$DOT_DIR/"* ]]; then
            echo -e "      ${C_GREEN}${I_OK}${C_RESET} Already linked: $rel_path"
        else
            echo -e "      ${C_YELLOW}${I_INFO}${C_RESET} Foreign symlink found. Removing: $rel_path"
            rm "$target"
        fi
    elif [ -e "$target" ]; then
        # It's a real file/dir - back it up
        mkdir -p "$BACKUP_DIR"
        local backup_dest="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_dest")"
        echo -e "      ${C_YELLOW}${I_BACKUP}${C_RESET} Conflicting file found. Moving to backup: $rel_path"
        mv "$target" "$backup_dest"
    fi
}

# --- Main Execution ---
print_header

if [ ! -d "$DOT_DIR" ]; then
    echo -e "  ${C_RED}[✘] Error: Dotfiles directory not found!${C_RESET}"
    exit 1
fi

# Ensure target directories exist so stow doesn't try to link the parent
mkdir -p "$TARGET_DIR/.config"

# PHASE 1: SURGICAL SYNC (Core Configs)
print_step "1" "Surgical App Configurations"

# 1.1 Handle root dotfiles (except .config, .fonts, etc.)
for item in "$DOT_DIR"/{*,.[!.]*}; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    if [[ "$name" != ".config" && "$name" != ".fonts" && "$name" != ".themes" && "$name" != ".icons" && "$name" != ".git" ]]; then
        prepare_stow_target "$name"
    fi
done

# 1.2 Handle items INSIDE .config surgically
if [ -d "$DOT_DIR/.config" ]; then
    echo -e "      ${I_INFO} Scanning .config sub-folders..."
    for cfg in "$DOT_DIR/.config"/*; do
        [ -e "$cfg" ] || continue
        cfg_name=$(basename "$cfg")
        prepare_stow_target ".config/$cfg_name"
    done
fi

# Execute main stow (GNU Stow handles the merging once conflicts are cleared)
stow -d "$REPO_ROOT" -t "$TARGET_DIR" -R --ignore=".fonts" --ignore=".themes" --ignore=".icons" dotfiles
echo -e "      ${C_GREEN}${I_OK}${C_RESET} System & App configs deployed.\n"

# PHASE 2: Custom Fonts
print_step "2" "User Fonts Deployment"
if [ -d "$DOT_DIR/.fonts" ]; then
    prepare_stow_target ".fonts"
    stow -d "$REPO_ROOT" -t "$TARGET_DIR" -R --ignore='^(\.themes|\.icons|[^.].*|(\.(?!fonts).*))$' dotfiles
    fc-cache -f >/dev/null 2>&1
    echo -e "      ${C_GREEN}${I_OK}${C_RESET} Fonts linked and cache updated.\n"
fi

# PHASE 3: Custom Icons
print_step "3" "UI Icon Themes"
if [ -d "$DOT_DIR/.icons" ]; then
    prepare_stow_target ".icons"
    stow -d "$REPO_ROOT" -t "$TARGET_DIR" -R --ignore='^(\.fonts|\.themes|[^.].*|(\.(?!icons).*))$' dotfiles
    echo -e "      ${C_GREEN}${I_OK}${C_RESET} Icons deployed.\n"
fi

# PHASE 4: GTK & App Themes
print_step "4" "GTK & Environment Themes"
if [ -d "$DOT_DIR/.themes" ]; then
    prepare_stow_target ".themes"
    stow -d "$REPO_ROOT" -t "$TARGET_DIR" -R --ignore='^(\.fonts|\.icons|[^.].*|(\.(?!themes).*))$' dotfiles
    echo -e "      ${C_GREEN}${I_OK}${C_RESET} Themes deployed.\n"
fi

echo -e "${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
echo -e "  ${I_OK}  ${C_BOLD}DOTFILES SURGICALLY STOWED!${C_RESET}"
[ -d "$BACKUP_DIR" ] && echo -e "  ${I_INFO}  Backups saved in: ${C_YELLOW}$BACKUP_DIR${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
