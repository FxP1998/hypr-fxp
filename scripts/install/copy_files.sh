#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: copy_files.sh
#  󰁔  Description: Surgical Dotfile Sync with Intelligent 3-Level Backup.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_CHECK="[OK]"; I_INFO="->"; I_BACKUP="[B]"; I_COPY="[C]"; I_GEAR="[*]"; LINE="----------------------------------------------------"
else
    I_CHECK="󰄬"; I_INFO="󰋽"; I_BACKUP="󰁯"; I_COPY="󰆏"; I_GEAR="󰒓"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
SOURCE_DIR="$HOME/FxP1998/dotfiles"
BACKUP_ROOT="$HOME/.FxP1998_backups"
PERM_BACKUP="$BACKUP_ROOT/PERMANENT_BACKUP"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CURRENT_BACKUP="$BACKUP_ROOT/$TIMESTAMP"

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_COPY}  ${C_BOLD}Surgical Dotfile Sync & Backup${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

print_step() { echo -e "  ${C_BLUE}${C_BOLD}[${C_RESET}${I_GEAR}${C_BLUE}${C_BOLD}]${C_RESET} $1"; }
print_success() { echo -e "  ${C_GREEN}${C_BOLD}[${C_RESET}${I_CHECK}${C_GREEN}${C_BOLD}]${C_RESET} $1"; }

# Manage rotation (Keep 1 Permanent + 2 Latest)
rotate_backups() {
    print_step "Performing backup rotation maintenance..."
    
    # Get all timestamped backups (directories starting with 20)
    local backups=($(ls -d $BACKUP_ROOT/20* 2>/dev/null | sort -r))
    
    # If more than 2, delete the older ones
    if [ ${#backups[@]} -gt 2 ]; then
        for ((i=2; i<${#backups[@]}; i++)); do
            echo -e "      ${C_RED}󰆴${C_RESET} Removing old backup: $(basename ${backups[$i]})"
            rm -rf "${backups[$i]}"
        done
    fi
}

# Function to safely sync an item
sync_item() {
    local src_item="$1"
    local rel_path="${src_item#$SOURCE_DIR/}"
    local target_item="$HOME/$rel_path"

    # Ensure parent directory exists in $HOME
    mkdir -p "$(dirname "$target_item")"

    # If target already exists, back it up
    if [ -e "$target_item" ] || [ -L "$target_item" ]; then
        # 1. Check for Permanent Backup first
        if [ ! -d "$PERM_BACKUP" ]; then
            local backup_path="$PERM_BACKUP/$rel_path"
        else
            local backup_path="$CURRENT_BACKUP/$rel_path"
        fi
        
        mkdir -p "$(dirname "$backup_path")"
        cp -rf "$target_item" "$backup_path" 2>/dev/null
        echo -e "      ${C_YELLOW}${I_BACKUP}${C_RESET} Backed up: $rel_path"
    fi

    # Copy the new item
    cp -rf "$src_item" "$target_item"
    echo -e "      ${C_GREEN}${I_COPY}${C_RESET} Installed: $rel_path"
}

# --- Main Logic ---
print_header

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${C_RED}Error: Source directory $SOURCE_DIR not found!${C_RESET}"
    exit 1
fi

# Determine if this is the very first run (Permanent Backup)
if [ ! -d "$PERM_BACKUP" ]; then
    print_step "Creating INITIAL PERMANENT BACKUP..."
    mkdir -p "$PERM_BACKUP"
    echo -e "      Location: ${C_GREEN}$PERM_BACKUP${C_RESET}\n"
else
    print_step "Initializing timestamped backup..."
    mkdir -p "$CURRENT_BACKUP"
    echo -e "      Location: ${C_YELLOW}$CURRENT_BACKUP${C_RESET}\n"
fi

print_step "Starting surgical synchronization..."

# 1. Handle everything in dotfiles root (except .config)
for item in "$SOURCE_DIR"/{*,.[!.]*}; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    if [[ "$name" != ".config" && "$name" != ".git" ]]; then
        sync_item "$item"
    fi
done

# 2. Handle items inside .config specifically
if [ -d "$SOURCE_DIR/.config" ]; then
    for item in "$SOURCE_DIR/.config"/*; do
        [ -e "$item" ] || continue
        sync_item "$item"
    done
fi

# 3. Clean up old backups
rotate_backups

echo -e "\n${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
print_success "Synchronization complete!"
echo -e "  ${I_INFO} All original files are protected in $BACKUP_ROOT"
echo -e "${C_GREEN}${C_BOLD}${LINE}${C_RESET}"
