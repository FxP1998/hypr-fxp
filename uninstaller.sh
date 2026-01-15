#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Smart Uninstaller & Cleaner for FxP-Hyprland

# --- VISUAL & COMPATIBILITY ENGINE ---
if [[ "$TERM" == "linux" ]]; then
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_TRASH="[#]"; IC_OK="[OK]"; IC_INFO="->"; LINE_DBL="========================================"
else
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_TRASH="🗑️ "; IC_OK="✔"; IC_INFO="➜"; LINE_DBL="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

APP_NAME="FxP-Hyprland"
BACKUP_DIR_ROOT="$HOME/.dotfiles-backup"

# Lists matching your installer
CONFIGS_TO_REMOVE=("alacritty" "auto-cpufreq" "btop" "FxP-Hyprland" "gtk-3.0" "gtk-4.0" "htop" "hypr" "kitty" "mako" "matugen" "nvim" "rofi" "swayosd" "waybar" "wlogout" "xsettingsd" "yazi" "zed" "starship.toml")
HOME_FILES_TO_REMOVE=(".alias" ".fonts" ".icons" ".themes" ".gtkrc-2.0" ".vimrc")

clear
echo -e "${C_RED}${LINE_DBL}${C_RESET}"
echo -e "${C_RED}   ${IC_TRASH} UNINSTALLING FxP-HYPRLAND       ${C_RESET}"
echo -e "${C_RED}${LINE_DBL}${C_RESET}"
echo -e "${C_YELL}Warning: This will remove configuration files installed by the script.${C_RESET}"
echo -e "You will be given options to restore backups or keep packages.\n"

read -p "Are you sure you want to proceed? [y/N]: " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${C_GREEN}Action cancelled.${C_RESET}"
    exit 0
fi

# ==============================================================================
# PHASE 1: RESTORE BACKUPS
# ==============================================================================
echo -e "\n${C_BLUE}${IC_INFO} Checking for backups...${C_RESET}"
if [ -d "$BACKUP_DIR_ROOT" ]; then
    LATEST_BACKUP=$(ls -td "$BACKUP_DIR_ROOT"/* | head -1)
    if [ -n "$LATEST_BACKUP" ]; then
        echo -e "${C_GREEN}${IC_OK} Found backup at: $LATEST_BACKUP${C_RESET}"
        read -p "Do you want to RESTORE this backup? (Overwrites current configs) [y/N]: " RESTORE_OPT
        if [[ "$RESTORE_OPT" =~ ^[Yy]$ ]]; then
            echo -e "${C_YELL}   Restoring configurations...${C_RESET}"
            if [ -d "$LATEST_BACKUP/.config" ]; then cp -rf "$LATEST_BACKUP/.config/"* "$HOME/.config/"; fi
            for file in "${HOME_FILES_TO_REMOVE[@]}"; do
                if [ -f "$LATEST_BACKUP/$file" ] || [ -d "$LATEST_BACKUP/$file" ]; then cp -rf "$LATEST_BACKUP/$file" "$HOME/"; fi
            done
            [ -f "$LATEST_BACKUP/.zshrc" ] && cp "$LATEST_BACKUP/.zshrc" "$HOME/.zshrc"
            [ -f "$LATEST_BACKUP/.bashrc" ] && cp "$LATEST_BACKUP/.bashrc" "$HOME/.bashrc"
            echo -e "${C_GREEN}${IC_OK} Backup restored successfully.${C_RESET}"
        else
            echo -e "   Skipping restore."
        fi
    else
        echo -e "${C_YELL}   Backup folder exists but looks empty.${C_RESET}"
    fi
else
    echo -e "${C_YELL}   No backups found at $BACKUP_DIR_ROOT.${C_RESET}"
fi

# ==============================================================================
# PHASE 2: REMOVE INSTALLED CONFIGS
# ==============================================================================
echo -e "\n${C_BLUE}${IC_INFO} Cleaning installed configurations...${C_RESET}"
for cfg in "${CONFIGS_TO_REMOVE[@]}"; do
    if [ -e "$HOME/.config/$cfg" ]; then
        rm -rf "$HOME/.config/$cfg"
        echo -e "   - Removed: ~/.config/$cfg"
    fi
done
for file in "${HOME_FILES_TO_REMOVE[@]}"; do
    if [ -e "$HOME/$file" ]; then
        rm -rf "$HOME/$file"
        echo -e "   - Removed: ~/$file"
    fi
done

# ==============================================================================
# PHASE 3: SANITIZE SHELL FILES (.zshrc / .bashrc)
# ==============================================================================
echo -e "\n${C_BLUE}${IC_INFO} Removing injected shell aliases...${C_RESET}"
sanitize_shell_file() {
    local file="$1"
    if [ -f "$file" ]; then
        grep -v "The Ultimate Extactor" "$file" | grep -v "Yazi CD on Exit" | grep -v "yazi-cwd" > "$file.tmp"
        mv "$file.tmp" "$file"
        echo -e "   - Sanitized: $file"
    fi
}
sanitize_shell_file "$HOME/.zshrc"
sanitize_shell_file "$HOME/.bashrc"

# ==============================================================================
# PHASE 4: SYSTEM SERVICES & PACKAGES
# ==============================================================================
echo -e "\n${C_BLUE}${IC_INFO} System Cleanup Options${C_RESET}"
# 1. Shell Revert
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" == "zsh" ]; then
    read -p "Do you want to switch default shell back to Bash? [y/N]: " SHELL_OPT
    if [[ "$SHELL_OPT" =~ ^[Yy]$ ]]; then
        sudo usermod --shell /bin/bash "$USER"
        echo -e "${C_GREEN}${IC_OK} Shell changed to Bash.${C_RESET}"
    fi
fi
# 2. Service Disable
read -p "Disable 'auto-cpufreq' service? [y/N]: " CPU_OPT
if [[ "$CPU_OPT" =~ ^[Yy]$ ]]; then
    sudo systemctl disable --now auto-cpufreq 2>/dev/null
    echo -e "${C_GREEN}${IC_OK} Service disabled.${C_RESET}"
fi
# 3. Package Removal
echo -e "\n${C_RED}[DANGER ZONE]${C_RESET}"
read -p "Do you want to uninstall the packages (Hyprland, Waybar, etc.)? [y/N]: " PKG_OPT
if [[ "$PKG_OPT" =~ ^[Yy]$ ]]; then
    echo -e "${C_YELL}Removing packages...${C_RESET}"
    PKGS_TO_REMOVE="hyprland hyprlock hypridle waybar rofi-wayland swayosd wlogout nwg-look mako matugen starship"
    sudo pacman -Rns --noconfirm $PKGS_TO_REMOVE 2>/dev/null
    echo -e "${C_GREEN}${IC_OK} Packages removed.${C_RESET}"
else
    echo -e "Skipping package removal."
fi

echo -e "\n${C_GREEN}${LINE_DBL}${C_RESET}"
echo -e "${C_GREEN}   ${IC_OK} UNINSTALLATION COMPLETE      ${C_RESET}"
echo -e "${C_GREEN}${LINE_DBL}${C_RESET}"
echo -e "Please restart your terminal or reboot for all changes to take effect."
