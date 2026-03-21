#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  FxP1998 GLOBAL UPDATE SYSTEM
#  󰀻  File: update.sh
#  󰁔  Description: Safe orchestrator that tracks repo changes and syncs to HOME.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_UP="[UP]"; I_OK="[OK]"; I_INFO="->"; I_BACKUP="[B]"; LINE="----------------------------------------------------"
else
    I_UP="󰓦"; I_OK="󰄬"; I_INFO="󰁔"; I_BACKUP="󰁯"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOT_SOURCE="$REPO_ROOT/dotfiles"
BACKUP_ROOT="$HOME/.FxP1998_backups/updates/$(date +%Y%m%d_%H%M%S)"

# --- UI Helpers ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_UP}  ${C_BOLD}FxP1998 SMART UPDATE ENGINE${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

msg_info() { echo -e "  ${C_BLUE}${I_INFO}${C_RESET} $1"; }
msg_success() { echo -e "  ${C_GREEN}${I_OK}${C_RESET} $1"; }
msg_warn() { echo -e "  ${C_YELLOW}${I_INFO}${C_RESET} $1"; }

# --- Pre-Flight Sanity Check ---
# This ensures a 100% clean state so git pull NEVER fails for end users
sanitize_repo() {
    msg_info "Performing Pre-Flight Repository Sanity Check..."
    cd "$REPO_ROOT" || exit 1
    
    # Abort any stuck rebases or merges
    git rebase --abort > /dev/null 2>&1
    git merge --abort > /dev/null 2>&1
    
    # Aggressively reset all local changes to match the last known commit
    git reset --hard HEAD > /dev/null 2>&1
    
    # Remove any untracked files or directories that might cause conflicts
    git clean -fd > /dev/null 2>&1
}

# --- Execution ---
print_header

sanitize_repo

msg_info "Step 1: Fetching updates from GitHub..."

# Capture the current state before pulling
PRE_UPDATE_HASH=$(git rev-parse HEAD)

if git pull origin $(git branch --show-current) --rebase; then
    POST_UPDATE_HASH=$(git rev-parse HEAD)
else
    echo -e "\n${C_RED}[✘] Error: Pull failed. Check your internet/SSH.${C_RESET}"
    exit 1
fi

# Check if anything actually changed
if [ "$PRE_UPDATE_HASH" == "$POST_UPDATE_HASH" ]; then
    msg_success "System is already up to date. No changes found."
    exit 0
fi

echo ""
msg_info "Step 2: Tracking and applying surgical changes..."

# Get the list of changed files specifically in the dotfiles/ directory
# A = Added, M = Modified, D = Deleted
mapfile -t CHANGED_FILES < <(git diff --name-only "$PRE_UPDATE_HASH" "$POST_UPDATE_HASH" -- dotfiles/)

if [ ${#CHANGED_FILES[@]} -eq 0 ]; then
    msg_success "No dotfile changes detected in this update."
else
    mkdir -p "$BACKUP_ROOT"
    
    for rel_file in "${CHANGED_FILES[@]}"; do
        # rel_file looks like: dotfiles/.config/hypr/hyprland.conf
        # internal_path looks like: .config/hypr/hyprland.conf
        internal_path="${rel_file#dotfiles/}"
        target_file="$HOME/$internal_path"
        source_file="$REPO_ROOT/$rel_file"

        # Case 1: File was DELETED in repo
        if [ ! -f "$source_file" ] && [ ! -d "$source_file" ]; then
            if [ -e "$target_file" ]; then
                msg_warn "Removing local file (deleted in repo): $internal_path"
                rm -rf "$target_file"
            fi
        
        # Case 2: File was ADDED or MODIFIED
        else
            # Ensure target parent directory exists
            mkdir -p "$(dirname "$target_file")"

            # If it already exists locally, back it up before overwriting
            if [ -e "$target_file" ] || [ -L "$target_file" ]; then
                backup_path="$BACKUP_ROOT/$internal_path"
                mkdir -p "$(dirname "$backup_path")"
                mv "$target_file" "$backup_path"
                echo -e "      ${C_YELLOW}${I_BACKUP}${C_RESET} Backed up: $internal_path"
            fi

            # Copy new version
            cp -rf "$source_file" "$target_file"
            echo -e "      ${C_GREEN}󰄬${C_RESET} Updated:   $internal_path"
        fi
    done
    msg_success "Surgical sync complete. ${#CHANGED_FILES[@]} items processed."
fi

echo ""
msg_info "Step 3: Refreshing system state..."

# Run path sanitizer to ensure new files have the correct username
if [ -f "$REPO_ROOT/scripts/core/path_sanitizer.sh" ]; then
    bash "$REPO_ROOT/scripts/core/path_sanitizer.sh"
fi

# Re-apply themes
if [ -f "$REPO_ROOT/scripts/install/shell_themes.sh" ]; then
    bash "$REPO_ROOT/scripts/install/shell_themes.sh"
fi

# Final Cleanup & Notification
print_header
echo -e "  ${C_GREEN}${C_BOLD}${I_OK} UPDATE CYCLE FINISHED!${C_RESET}"
echo -e "  ${I_INFO} All changes from the repo have been mirrored to your home."
[ -d "$BACKUP_ROOT" ] && echo -e "  ${I_INFO} Original versions saved in: ${C_YELLOW}$BACKUP_ROOT${C_RESET}"
echo -e "\n${C_BLUE}${C_BOLD}${LINE}${C_RESET}"

echo -e "\n  ${I_INFO} Press any key to exit..."
read -n 1 -s
