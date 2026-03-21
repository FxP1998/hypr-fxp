#!/usr/bin/env bash

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (Standard ASCII)
    I_CHECK="[OK]"; I_INFO="[i]"; I_BACKUP="[B]"; I_COPY="[C]"; I_GEAR="[*]"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE (Nerd Fonts)
    I_CHECK="󰄬"; I_INFO="󰋽"; I_BACKUP="󰁯"; I_COPY="󰆏"; I_GEAR="󰒓"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
SOURCE_DIR="$HOME/FxP1998/dotfiles"
BACKUP_ROOT="$HOME/.FxP1998_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${I_COPY}  ${C_BOLD}Surgical Dotfile Sync & Backup${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

print_step() { echo -e "  ${C_BLUE}${C_BOLD}[${C_RESET}${I_GEAR}${C_BLUE}${C_BOLD}]${C_RESET} $1"; }
print_success() { echo -e "  ${C_GREEN}${C_BOLD}[${C_RESET}${I_CHECK}${C_GREEN}${C_BOLD}]${C_RESET} $1"; }

# Function to safely sync an item
sync_item() {
    local src_item="$1"
    local rel_path="${src_item#$SOURCE_DIR/}"
    local target_item="$HOME/$rel_path"

    # Ensure parent directory exists in $HOME
    mkdir -p "$(dirname "$target_item")"

    # If target already exists, back it up
    if [ -e "$target_item" ] || [ -L "$target_item" ]; then
        local backup_path="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        
        # Check if it's already a symlink or file/dir
        mv "$target_item" "$backup_path"
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

print_step "Initializing backup environment..."
mkdir -p "$BACKUP_DIR"
echo -e "      Backup destination: ${C_YELLOW}$BACKUP_DIR${C_RESET}\n"

print_step "Starting surgical synchronization..."

# 1. Handle everything in dotfiles root (except .config)
for item in "$SOURCE_DIR"/{*,.[!.]*}; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    if [ "$name" != ".config" ]; then
        sync_item "$item"
    fi
done

# 2. Handle items inside .config specifically to avoid touching unrelated files like dconf
if [ -d "$SOURCE_DIR/.config" ]; then
    for item in "$SOURCE_DIR/.config"/{*,.[!.]*}; do
        [ -e "$item" ] || continue
        sync_item "$item"
    done
fi

echo -e "\n${C_GREEN}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
print_success "Synchronization complete!"
echo -e "  ${I_INFO} All original files are safe in: $BACKUP_DIR"
echo -e "${C_GREEN}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
