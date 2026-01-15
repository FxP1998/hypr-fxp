#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Configuration ---
# REPO_DIR: The root folder containing .git (e.g., ~/FxP1998)
REPO_DIR="$HOME/FxP1998"

# DOTFILES_DIR: The actual config folder to sync (e.g., ~/FxP1998/Dotfiles)
DOTFILES_DIR="$REPO_DIR/Dotfiles"

I_ARCH=""
I_AUR=""
I_GIT=""
I_PKG="󰚰"
I_CHECK=""
I_WARN=""
I_ERR=""

# Waybar Colors (Rose Pine)
HEX_RED="#eb6f92"
HEX_GOLD="#f6c177"
HEX_BLUE="#9ccfd8"

# Terminal Colors
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
WHITE="\033[1;37m"

# --- Functions ---

check_dependencies() {
    if [ -t 1 ]; then
        if ! command -v checkupdates &>/dev/null; then
             echo -e "${YELLOW}${I_WARN} 'checkupdates' not found. Installing 'pacman-contrib'...${RESET}"
             sudo pacman -S --noconfirm pacman-contrib
        fi
    fi
}

get_updates() {
    check_dependencies
    
    # 1. Check Official (Arch)
    if command -v checkupdates &>/dev/null; then
        OFFICIAL_COUNT=$(checkupdates 2>/dev/null | wc -l)
    else
        OFFICIAL_COUNT=0
    fi

    # 2. Check AUR
    if command -v yay &>/dev/null; then
        AUR_COUNT=$(yay -Qua 2>/dev/null | wc -l)
    elif command -v paru &>/dev/null; then
        AUR_COUNT=$(paru -Qua 2>/dev/null | wc -l)
    else
        AUR_COUNT=0
    fi

    # 3. Check Dotfiles (Git)
    if [ -d "$REPO_DIR/.git" ]; then
        cd "$REPO_DIR" || DOT_COUNT=0
        timeout 5s git fetch -q origin 2>/dev/null
        DOT_COUNT=$(git rev-list --count HEAD..@{u} 2>/dev/null)
        if [ -z "$DOT_COUNT" ]; then DOT_COUNT=0; fi
    else
        DOT_COUNT=0
    fi

    TOTAL=$((OFFICIAL_COUNT + AUR_COUNT + DOT_COUNT))
}

# --- SMART APPLY FUNCTION (Differential Update) ---
apply_updates() {
    echo -e "\n${BLUE}========================================${RESET}"
    echo -e "${BOLD}   📂 SMART SYNC: DOTFILES UPDATE       ${RESET}"
    echo -e "${BLUE}========================================${RESET}"
    
    # 1. Identify the folder name (e.g., Dotfiles)
    REPO_SUBFOLDER=$(basename "$DOTFILES_DIR")
    
    # 2. Get list of changed files relative to the repo root
    # ORIG_HEAD is the state BEFORE the pull. HEAD is NOW.
    CHANGES=$(git diff --name-status ORIG_HEAD HEAD -- "$REPO_SUBFOLDER")
    
    if [ -z "$CHANGES" ]; then
        echo -e "${GREEN}:: No configuration files were changed in this update.${RESET}"
        return
    fi

    echo -e "${YELLOW}:: The following changes were detected:${RESET}"
    echo "$CHANGES"
    echo ""
    
    read -p "Apply these specific changes? [y/N]: " APPLY
    if [[ ! "$APPLY" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}:: Update skipped. New files are in $DOTFILES_DIR${RESET}"
        return
    fi

    BACKUP_DIR="$HOME/.dotfiles-backup/update_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    echo -e "${YELLOW}:: Applying Changes...${RESET}"

    # 3. Iterate through changes
    while read -r status file_path; do
        # 'file_path' includes 'Dotfiles/'. We strip it to get the HOME relative path.
        # e.g., "Dotfiles/.config/hypr/hyprland.conf" -> ".config/hypr/hyprland.conf"
        relative_path="${file_path#$REPO_SUBFOLDER/}"
        dest_path="$HOME/$relative_path"
        
        case "$status" in
            D) # DELETED FILE
                if [ -e "$dest_path" ]; then
                    # Backup before deleting
                    mkdir -p "$(dirname "$BACKUP_DIR/$relative_path")"
                    mv "$dest_path" "$BACKUP_DIR/$relative_path"
                    echo -e "   [DELETED] $relative_path (Backed up)"
                fi
                ;;
                
            *) # ADDED (A) or MODIFIED (M)
                # Ensure destination folder exists
                mkdir -p "$(dirname "$dest_path")"
                
                # Backup existing file
                if [ -e "$dest_path" ]; then
                    mkdir -p "$(dirname "$BACKUP_DIR/$relative_path")"
                    cp -r "$dest_path" "$BACKUP_DIR/$relative_path"
                fi
                
                # Copy new file from repo
                cp -r "$REPO_DIR/$file_path" "$dest_path"
                echo -e "   [UPDATED] $relative_path"
                ;;
        esac
    done <<< "$CHANGES"

    echo -e "${GREEN}✔ Smart Sync Complete.${RESET}"
    
    # Reload Waybar if likely affected
    if pgrep -x "waybar" > /dev/null; then
        echo -e "${BLUE}:: Reloading Waybar...${RESET}"
        pkill waybar && hyprctl dispatch exec waybar > /dev/null
    fi
}

perform_update() {
    echo -e "\n${BLUE}========================================${RESET}"
    echo -e "${BOLD}   🚀 STARTING SYSTEM UPDATE SEQUENCE   ${RESET}"
    echo -e "${BLUE}========================================${RESET}"

    # Step 1: System Updates
    echo -e "\n${YELLOW}:: [1/3] Updating System (Official Repos)...${RESET}"
    sudo pacman -Syu
    
    # Step 2: AUR Updates
    echo -e "\n${YELLOW}:: [2/3] Updating AUR Packages...${RESET}"
    if command -v yay &> /dev/null; then
        yay -Sua --noconfirm
    elif command -v paru &> /dev/null; then
        paru -Sua --noconfirm
    fi

    # Step 3: Dotfiles
    if [ "$DOT_COUNT" -gt 0 ]; then
        echo -e "\n${YELLOW}:: [3/3] Updating Dotfiles ($REPO_DIR)...${RESET}"
        cd "$REPO_DIR" || exit
        echo -e "${BLUE}   Pulling changes from GitHub...${RESET}"
        
        if git pull; then
            echo -e "${GREEN}✔ Repository updated.${RESET}"
            apply_updates
        else
            echo -e "${RED}✘ Git pull failed.${RESET}"
        fi
    else
        echo -e "\n${GREEN}:: [3/3] Dotfiles are already up to date.${RESET}"
    fi

    echo -e "\n${GREEN}✔ Update Sequence Complete!${RESET}"
    read -p "Press Enter to exit..."
}

# --- Main Logic ---

get_updates

# Color Logic
if [ "$TOTAL" -gt 20 ]; then
    WAYBAR_COLOR="$HEX_RED"
    TERM_COLOR="$RED"
elif [ "$TOTAL" -gt 10 ]; then
    WAYBAR_COLOR="$HEX_GOLD"
    TERM_COLOR="$YELLOW"
else
    WAYBAR_COLOR="$HEX_BLUE"
    TERM_COLOR="$BLUE"
fi

# --- Output Modes ---

if [ -t 1 ]; then
    clear
    echo -e "${BLUE}▶ SYSTEM UPDATE CHECKER (By FxP)${RESET}"
    echo -e "${BLUE}:: Checking repositories...${RESET}"
    echo ""
    echo -e " ${I_ARCH}  Official Arch : ${WHITE}$OFFICIAL_COUNT${RESET}"
    echo -e " ${I_AUR}  AUR Packages  : ${WHITE}$AUR_COUNT${RESET}"
    echo -e " ${I_GIT}  Dotfiles      : ${WHITE}$DOT_COUNT${RESET}"
    echo -e " -------------------------"
    echo -e " ${I_PKG}  Total Updates : ${TERM_COLOR}${BOLD}$TOTAL${RESET}"
    echo ""
    
    if [ "$TOTAL" -eq 0 ]; then
        echo -e "${GREEN}✔ System is up to date!${RESET}"
        exit 0
    else
        echo -e "${YELLOW}Updates are available.${RESET}"
        read -p "Do you want to update now? [y/N]: " CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            perform_update
        else
            echo "Cancelled."
        fi
    fi
else
    if [ "$TOTAL" -eq 0 ]; then
        echo '{"text": "", "alt": "", "tooltip": ""}'
        exit 0
    fi
    TOOLTIP="$TOTAL Updates Pending\r$I_ARCH Official: $OFFICIAL_COUNT\r$I_AUR AUR: $AUR_COUNT\r$I_GIT Dotfiles: $DOT_COUNT"
    echo "{\"text\": \"<span foreground='$WAYBAR_COLOR'>$I_PKG $TOTAL</span>\", \"alt\": \"$TOTAL\", \"tooltip\": \"$TOOLTIP\"}"
fi
