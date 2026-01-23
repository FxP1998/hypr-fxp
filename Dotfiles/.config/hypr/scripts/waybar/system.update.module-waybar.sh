#!/usr/bin/env bash
# ============================================================================
# FxP's Professional Dotfiles Update Manager
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998/hypr-fxp
# VERSION: 3.0 - Professional Edition
# ============================================================================

# ----------------------------------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------------------------------
readonly REPO_DIR="$HOME/FxP1998"
readonly DOTFILES_DIR="$REPO_DIR/Dotfiles"
readonly UPDATE_BACKUP_DIR="$HOME/.update-backups"
readonly LOG_FILE="/tmp/fxp-update-$(date +%Y%m%d_%H%M%S).log"

# Icons (Original from your design)
readonly I_ARCH=""
readonly I_AUR=""
readonly I_GIT=""
readonly I_PKG="󰚰"

# Status Symbols
readonly SYM_OK="(✓)"
readonly SYM_WARN="(⚠)"
readonly SYM_ERR="(✗)"
readonly SYM_INFO="(ℹ)"
readonly SYM_PROGRESS="(⟳)"

# Colors
readonly RESET="\033[0m"
readonly BOLD="\033[1m"
readonly RED="\033[1;31m"
readonly GREEN="\033[1;32m"
readonly YELLOW="\033[1;33m"
readonly BLUE="\033[1;34m"
readonly CYAN="\033[1;36m"
readonly WHITE="\033[1;37m"

# Waybar Colors
readonly HEX_RED="#eb6f92"
readonly HEX_GOLD="#f6c177"
readonly HEX_BLUE="#9ccfd8"
readonly HEX_GREEN="#31748f"

# ----------------------------------------------------------------------------
# GLOBAL VARIABLES
# ----------------------------------------------------------------------------
OFFICIAL_COUNT=0
AUR_COUNT=0
DOT_COUNT=0
TOTAL=0
BATCH_MODE=false
BATCH_CHOICE=""
CONFLICT_COUNT=0
UPDATED_FILES=0
SKIPPED_FILES=0

# ----------------------------------------------------------------------------
# UTILITY FUNCTIONS
# ----------------------------------------------------------------------------

log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Print to terminal with colors
    case "$level" in
        "ERROR") echo -e "${RED}${SYM_ERR} $message${RESET}" ;;
        "WARN")  echo -e "${YELLOW}${SYM_WARN} $message${RESET}" ;;
        "INFO")  echo -e "${CYAN}${SYM_INFO} $message${RESET}" ;;
        "OK")    echo -e "${GREEN}${SYM_OK} $message${RESET}" ;;
        "PROGRESS") echo -e "${BLUE}${SYM_PROGRESS} $message${RESET}" ;;
        *)       echo -e "$message" ;;
    esac
}

center_text() {
    local text="$1"
    local width=40
    local text_length=${#text}
    local padding=$(( (width - text_length) / 2 ))
    
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}

draw_separator() {
    local char="${1:-=}"
    printf '%*s\n' 40 | tr ' ' "$char"
}

cleanup() {
    # Cleanup on exit
    if [ -f "/tmp/.fxp-update-lock" ]; then
        rm -f "/tmp/.fxp-update-lock"
    fi
    log_message "INFO" "Update session ended"
}

check_lock() {
    if [ -f "/tmp/.fxp-update-lock" ]; then
        log_message "ERROR" "Another update is already running"
        exit 1
    fi
    touch "/tmp/.fxp-update-lock"
    trap cleanup EXIT
}

# ----------------------------------------------------------------------------
# VALIDATION FUNCTIONS
# ----------------------------------------------------------------------------

validate_repo() {
    if [ ! -d "$REPO_DIR" ]; then
        log_message "WARN" "Repository directory not found: $REPO_DIR"
        return 1
    fi
    
    if [ ! -d "$REPO_DIR/.git" ]; then
        log_message "ERROR" "Not a git repository: $REPO_DIR"
        return 1
    fi
    
    if ! cd "$REPO_DIR" 2>/dev/null; then
        log_message "ERROR" "Cannot access repository directory"
        return 1
    fi
    
    return 0
}

check_dependencies() {
    local missing=()
    
    # Check for git
    if ! command -v git &>/dev/null; then
        missing+=("git")
    fi
    
    # Check for package managers
    if ! command -v checkupdates &>/dev/null; then
        log_message "WARN" "'checkupdates' not found (install: pacman-contrib)"
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_message "ERROR" "Missing dependencies: ${missing[*]}"
        return 1
    fi
    
    return 0
}

# ----------------------------------------------------------------------------
# UPDATE DETECTION
# ----------------------------------------------------------------------------

get_package_updates() {
    log_message "PROGRESS" "Checking package updates..."
    
    # Official Arch updates
    if command -v checkupdates &>/dev/null; then
        OFFICIAL_COUNT=$(checkupdates 2>/dev/null | wc -l)
        [ -z "$OFFICIAL_COUNT" ] && OFFICIAL_COUNT=0
    fi
    
    # AUR updates
    if command -v yay &>/dev/null; then
        AUR_COUNT=$(yay -Qua 2>/dev/null | wc -l)
        [ -z "$AUR_COUNT" ] && AUR_COUNT=0
    elif command -v paru &>/dev/null; then
        AUR_COUNT=$(paru -Qua 2>/dev/null | wc -l)
        [ -z "$AUR_COUNT" ] && AUR_COUNT=0
    fi
}

get_git_updates() {
    if ! validate_repo; then
        DOT_COUNT=0
        return
    fi
    
    log_message "PROGRESS" "Checking git repository..."
    
    # Fetch updates
    if ! git fetch origin 2>>"$LOG_FILE"; then
        log_message "WARN" "Failed to fetch git updates"
        DOT_COUNT=0
        return
    fi
    
    # Check if behind
    LOCAL_HASH=$(git rev-parse @ 2>/dev/null)
    REMOTE_HASH=$(git rev-parse @{u} 2>/dev/null)
    
    if [ -n "$LOCAL_HASH" ] && [ -n "$REMOTE_HASH" ] && [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        DOT_COUNT=$(git rev-list --count HEAD..@{u} 2>/dev/null)
        [ -z "$DOT_COUNT" ] && DOT_COUNT=1
    else
        DOT_COUNT=0
    fi
}

get_updates() {
    check_lock
    check_dependencies
    
    get_package_updates
    get_git_updates
    
    TOTAL=$((OFFICIAL_COUNT + AUR_COUNT + DOT_COUNT))
    
    log_message "INFO" "Updates found: Arch=$OFFICIAL_COUNT, AUR=$AUR_COUNT, Dotfiles=$DOT_COUNT"
}

# ----------------------------------------------------------------------------
# FILE MANAGEMENT
# ----------------------------------------------------------------------------

backup_file() {
    local src_file="$1"
    local relative_path="${src_file#$HOME/}"
    local backup_path="$UPDATE_BACKUP_DIR/$(date +%Y%m%d_%H%M%S)/$relative_path"
    
    mkdir -p "$(dirname "$backup_path")"
    
    if cp -r "$src_file" "$backup_path" 2>/dev/null; then
        log_message "INFO" "Backup created: $relative_path"
        return 0
    else
        log_message "WARN" "Failed to backup: $relative_path"
        return 1
    fi
}

is_template_file() {
    local file="$1"
    
    # Safe check without exposing content
    if [ ! -f "$file" ]; then
        return 1
    fi
    
    # Check for template patterns
    if grep -q -E "(YOUR_|CHANGE_|PLACEHOLDER|REPLACE_|EXAMPLE_)" "$file" 2>/dev/null; then
        return 0
    fi
    
    return 1
}

files_different() {
    local file1="$1"
    local file2="$2"
    
    if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
        return 0  # Different if one doesn't exist
    fi
    
    if cmp -s "$file1" "$file2" 2>/dev/null; then
        return 1  # Same
    else
        return 0  # Different
    fi
}

handle_conflict() {
    local repo_file="$1"
    local user_file="$2"
    local relative_path="$3"
    
    CONFLICT_COUNT=$((CONFLICT_COUNT + 1))
    
    # If batch mode is active, apply batch choice
    if [ "$BATCH_MODE" = true ] && [ -n "$BATCH_CHOICE" ]; then
        case "$BATCH_CHOICE" in
            1) 
                log_message "INFO" "Keeping (batch): $relative_path"
                SKIPPED_FILES=$((SKIPPED_FILES + 1))
                return
                ;;
            2)
                if backup_file "$user_file"; then
                    cp -r "$repo_file" "$user_file"
                    log_message "INFO" "Updated (batch): $relative_path"
                    UPDATED_FILES=$((UPDATED_FILES + 1))
                fi
                return
                ;;
        esac
    fi
    
    # Show conflict menu
    echo -e "\n${RED}${SYM_ERR} Conflict: $relative_path${RESET}"
    echo -e "${YELLOW}1. Keep my version${RESET}"
    echo -e "${YELLOW}2. Use updated version${RESET}"
    echo -e "${YELLOW}3. Skip this file${RESET}"
    
    if [ $CONFLICT_COUNT -gt 1 ]; then
        echo -e "${CYAN}4. Apply choice to all remaining conflicts${RESET}"
    fi
    
    while true; do
        read -p "Choice (1-${[ $CONFLICT_COUNT -gt 1 ] && echo 4 || echo 3}): " choice
        
        case "$choice" in
            1)
                log_message "INFO" "Keeping: $relative_path"
                SKIPPED_FILES=$((SKIPPED_FILES + 1))
                break
                ;;
            2)
                if backup_file "$user_file"; then
                    cp -r "$repo_file" "$user_file"
                    log_message "OK" "Updated: $relative_path"
                    UPDATED_FILES=$((UPDATED_FILES + 1))
                fi
                break
                ;;
            3)
                log_message "INFO" "Skipped: $relative_path"
                SKIPPED_FILES=$((SKIPPED_FILES + 1))
                break
                ;;
            4)
                if [ $CONFLICT_COUNT -gt 1 ]; then
                    echo -e "${CYAN}Apply to all remaining conflicts?${RESET}"
                    echo -e "${CYAN}a) Keep all my versions${RESET}"
                    echo -e "${CYAN}b) Use all updated versions${RESET}"
                    echo -e "${CYAN}c) Skip all conflicts${RESET}"
                    
                    read -p "Choice (a/b/c): " batch_choice
                    
                    case "$batch_choice" in
                        a) BATCH_MODE=true; BATCH_CHOICE=1 ;;
                        b) BATCH_MODE=true; BATCH_CHOICE=2 ;;
                        c) BATCH_MODE=true; BATCH_CHOICE=3 ;;
                        *) echo "Invalid choice"; continue ;;
                    esac
                    
                    # Apply batch choice to current file
                    handle_conflict "$repo_file" "$user_file" "$relative_path"
                    break
                fi
                ;;
            *)
                echo "Invalid choice"
                ;;
        esac
    done
}

process_file_change() {
    local status="$1"
    local file_path="$2"
    local relative_path="${file_path#Dotfiles/}"
    local repo_file="$REPO_DIR/$file_path"
    local user_file="$HOME/$relative_path"
    
    case "$status" in
        "A") # Added
            if [ ! -e "$user_file" ]; then
                mkdir -p "$(dirname "$user_file")"
                cp -r "$repo_file" "$user_file"
                log_message "OK" "Added: $relative_path"
                UPDATED_FILES=$((UPDATED_FILES + 1))
            fi
            ;;
            
        "M") # Modified
            if [ ! -e "$user_file" ]; then
                # File doesn't exist locally, just copy
                mkdir -p "$(dirname "$user_file")"
                cp -r "$repo_file" "$user_file"
                log_message "OK" "Created: $relative_path"
                UPDATED_FILES=$((UPDATED_FILES + 1))
            elif files_different "$user_file" "$repo_file"; then
                if is_template_file "$user_file"; then
                    # Template file - auto update
                    backup_file "$user_file"
                    cp -r "$repo_file" "$user_file"
                    log_message "OK" "Template updated: $relative_path"
                    UPDATED_FILES=$((UPDATED_FILES + 1))
                else
                    # Non-template - handle conflict
                    handle_conflict "$repo_file" "$user_file" "$relative_path"
                fi
            else
                log_message "INFO" "No changes: $relative_path"
            fi
            ;;
            
        "D") # Deleted
            if [ -e "$user_file" ]; then
                backup_file "$user_file"
                log_message "WARN" "File marked for deletion: $relative_path (backed up)"
                SKIPPED_FILES=$((SKIPPED_FILES + 1))
            fi
            ;;
            
        "R"*) # Renamed
            local old_file=$(echo "$file_path" | awk '{print $2}')
            local new_file=$(echo "$file_path" | awk '{print $3}')
            local old_relative="${old_file#Dotfiles/}"
            local new_relative="${new_file#Dotfiles/}"
            
            if [ -e "$HOME/$old_relative" ]; then
                backup_file "$HOME/$old_relative"
                log_message "INFO" "Renamed: $old_relative → $new_relative"
            fi
            ;;
    esac
}

# ----------------------------------------------------------------------------
# UPDATE OPERATIONS
# ----------------------------------------------------------------------------

apply_dotfiles_update() {
    echo -e "\n${BLUE}$(draw_separator "=")${RESET}"
    center_text "DOTFILES UPDATE"
    echo -e "${BLUE}$(draw_separator "=")${RESET}"
    
    if ! validate_repo; then
        log_message "ERROR" "Cannot access repository"
        return 1
    fi
    
    # Reset counters
    CONFLICT_COUNT=0
    UPDATED_FILES=0
    SKIPPED_FILES=0
    BATCH_MODE=false
    BATCH_CHOICE=""
    
    # Get changes
    local changes=$(git diff --name-status HEAD..@{u} -- Dotfiles 2>/dev/null)
    
    if [ -z "$changes" ]; then
        log_message "OK" "No dotfiles changes to apply"
        return 0
    fi
    
    # Show summary
    local change_count=$(echo "$changes" | wc -l)
    log_message "INFO" "Found $change_count file changes"
    
    # Preview changes
    echo -e "\n${CYAN}Changes to apply:${RESET}"
    echo "$changes" | while read -r status file; do
        local relative="${file#Dotfiles/}"
        case "$status" in
            "A") echo -e "  ${GREEN}+${RESET} $relative" ;;
            "M") echo -e "  ${YELLOW}~${RESET} $relative" ;;
            "D") echo -e "  ${RED}-${RESET} $relative" ;;
            "R"*) echo -e "  ${CYAN}→${RESET} $relative (renamed)" ;;
        esac
    done
    
    # Confirmation
    echo -e "\n${YELLOW}${SYM_WARN} Backups will be saved to: $UPDATE_BACKUP_DIR${RESET}"
    read -p "Apply these changes? [y/N]: " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_message "WARN" "Update cancelled by user"
        return 0
    fi
    
    # Apply changes
    log_message "PROGRESS" "Applying changes..."
    
    while read -r status file_path; do
        process_file_change "$status" "$file_path"
    done <<< "$changes"
    
    # Summary
    echo -e "\n${GREEN}$(draw_separator "-")${RESET}"
    center_text "UPDATE SUMMARY"
    echo -e "${GREEN}$(draw_separator "-")${RESET}"
    log_message "OK" "Updated files: $UPDATED_FILES"
    log_message "INFO" "Skipped files: $SKIPPED_FILES"
    log_message "INFO" "Backups: $UPDATE_BACKUP_DIR"
    
    # Service reload
    if [ $UPDATED_FILES -gt 0 ]; then
        ask_service_reload
    fi
    
    return 0
}

ask_service_reload() {
    echo -e "\n${YELLOW}${SYM_WARN} Some config files were updated${RESET}"
    read -p "Reload affected services? [y/N]: " reload
    
    if [[ "$reload" =~ ^[Yy]$ ]]; then
        # Waybar
        if pgrep -x "waybar" >/dev/null; then
            log_message "PROGRESS" "Reloading Waybar..."
            pkill -HUP waybar 2>/dev/null || pkill -x waybar && waybar >/dev/null 2>&1 &
            sleep 0.5
        fi
        
        # Hyprland
        if command -v hyprctl &>/dev/null; then
            log_message "PROGRESS" "Reloading Hyprland config..."
            hyprctl reload 2>/dev/null
        fi
        
        log_message "OK" "Services reloaded"
    fi
}

perform_package_update() {
    echo -e "\n${BLUE}$(draw_separator "=")${RESET}"
    center_text "PACKAGE UPDATE"
    echo -e "${BLUE}$(draw_separator "=")${RESET}"
    
    # Arch packages
    if [ "$OFFICIAL_COUNT" -gt 0 ]; then
        log_message "PROGRESS" "Updating Arch packages ($OFFICIAL_COUNT)..."
        sudo pacman -Syu --noconfirm
        [ $? -eq 0 ] && log_message "OK" "Arch packages updated" || log_message "ERROR" "Arch update failed"
    else
        log_message "OK" "Arch packages are current"
    fi
    
    # AUR packages
    if [ "$AUR_COUNT" -gt 0 ]; then
        log_message "PROGRESS" "Updating AUR packages ($AUR_COUNT)..."
        if command -v yay &>/dev/null; then
            yay -Sua --noconfirm
        elif command -v paru &>/dev/null; then
            paru -Sua --noconfirm
        else
            log_message "WARN" "No AUR helper found"
        fi
        [ $? -eq 0 ] && log_message "OK" "AUR packages updated" || log_message "ERROR" "AUR update failed"
    else
        log_message "OK" "AUR packages are current"
    fi
}

perform_git_update() {
    echo -e "\n${BLUE}$(draw_separator "=")${RESET}"
    center_text "REPOSITORY UPDATE"
    echo -e "${BLUE}$(draw_separator "=")${RESET}"
    
    if ! validate_repo; then
        return 1
    fi
    
    # Check for local changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        log_message "PROGRESS" "Stashing local changes..."
        git stash push -m "fxp-auto-stash-$(date +%s)"
        local stashed=true
    fi
    
    # Pull updates
    log_message "PROGRESS" "Pulling updates from repository..."
    if git pull --autostash; then
        log_message "OK" "Repository updated successfully"
        
        # Apply dotfiles if there were updates
        if [ "$DOT_COUNT" -gt 0 ]; then
            apply_dotfiles_update
        fi
        
        # Restore stash if we created one
        if [ "$stashed" = true ] && git stash list | grep -q "fxp-auto-stash"; then
            log_message "PROGRESS" "Restoring local changes..."
            if ! git stash pop; then
                log_message "WARN" "Stash restore had conflicts. Resolve manually."
            fi
        fi
    else
        log_message "ERROR" "Failed to pull updates"
        [ "$stashed" = true ] && git stash pop
        return 1
    fi
    
    return 0
}

# ----------------------------------------------------------------------------
# MAIN INTERFACE
# ----------------------------------------------------------------------------

show_update_summary() {
    echo -e "${CYAN}$(draw_separator "=")${RESET}"
    center_text "SYSTEM UPDATE SUMMARY"
    echo -e "${CYAN}$(draw_separator "=")${RESET}"
    echo ""
    echo -e "  ${I_ARCH}  Arch Packages   ${WHITE}: ${OFFICIAL_COUNT}${RESET}"
    echo -e "  ${I_AUR}   AUR Packages    ${WHITE}: ${AUR_COUNT}${RESET}"
    echo -e "  ${I_GIT}   Dotfiles        ${WHITE}: ${DOT_COUNT}${RESET}"
    echo -e "  $(draw_separator "-")"
    echo -e "  ${I_PKG}   Total Updates   ${WHITE}: ${TOTAL}${RESET}"
    echo ""
}

show_main_menu() {
    echo -e "${CYAN}Update Options:${RESET}"
    echo -e "  ${GREEN}1${RESET}. Update everything"
    echo -e "  ${GREEN}2${RESET}. System packages only"
    echo -e "  ${GREEN}3${RESET}. Dotfiles only"
    echo -e "  ${GREEN}4${RESET}. View detailed log"
    echo -e "  ${GREEN}5${RESET}. Exit"
    echo ""
}

interactive_mode() {
    clear
    
    # Header
    echo -e "${BLUE}$(draw_separator "=")${RESET}"
    center_text "FxP's UPDATE MANAGER"
    echo -e "${BLUE}$(draw_separator "=")${RESET}"
    
    # Summary
    show_update_summary
    
    if [ "$TOTAL" -eq 0 ]; then
        log_message "OK" "System is up to date"
        echo ""
        read -p "Press Enter to exit..."
        exit 0
    fi
    
    # Menu
    show_main_menu
    
    while true; do
        read -p "Select option (1-5): " choice
        
        case "$choice" in
            1)
                perform_package_update
                perform_git_update
                break
                ;;
            2)
                perform_package_update
                break
                ;;
            3)
                perform_git_update
                break
                ;;
            4)
                echo -e "\n${CYAN}Update log:${RESET}"
                tail -20 "$LOG_FILE" 2>/dev/null || echo "No log available"
                echo ""
                read -p "Press Enter to continue..."
                interactive_mode
                return
                ;;
            5)
                log_message "INFO" "Update cancelled"
                exit 0
                ;;
            *)
                echo "Invalid option. Please choose 1-5."
                ;;
        esac
    done
    
    # Completion
    echo -e "\n${GREEN}$(draw_separator "=")${RESET}"
    center_text "UPDATE COMPLETE"
    echo -e "${GREEN}$(draw_separator "=")${RESET}"
    echo ""
    read -p "Press Enter to exit..."
}

waybar_mode() {
    if [ "$TOTAL" -eq 0 ]; then
        echo '{"text": "", "alt": "", "tooltip": "System up to date"}'
    else
        local color
        if [ "$TOTAL" -gt 20 ]; then
            color="$HEX_RED"
        elif [ "$TOTAL" -gt 10 ]; then
            color="$HEX_GOLD"
        elif [ "$TOTAL" -gt 0 ]; then
            color="$HEX_BLUE"
        else
            color="$HEX_GREEN"
        fi
        
        local tooltip="Updates: $TOTAL\n$I_ARCH Arch: $OFFICIAL_COUNT\n$I_AUR AUR: $AUR_COUNT\n$I_GIT Dotfiles: $DOT_COUNT\n\nClick to update"
        echo "{\"text\": \"<span foreground='$color'>$I_PKG $TOTAL</span>\", \"alt\": \"$TOTAL\", \"tooltip\": \"$tooltip\", \"class\": \"updates-available\"}"
    fi
}

# ----------------------------------------------------------------------------
# MAIN EXECUTION
# ----------------------------------------------------------------------------

main() {
    # Get updates
    get_updates
    
    # Determine output mode
    if [ -t 1 ]; then
        interactive_mode
    else
        waybar_mode
    fi
}

# Run main function
main "$@"
