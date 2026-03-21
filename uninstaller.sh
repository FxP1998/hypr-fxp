#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Official Smart Uninstaller & System Restorer (Eyecandy & Robust)

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (Standard ASCII)
    I_TRASH="[#]"; I_RESTORE="[R]"; I_CLEAN="[*]"; I_WARN="[!]"; I_OK="[OK]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE (Nerd Fonts)
    I_TRASH="󰩹"; I_RESTORE="󰁯"; I_CLEAN="󰃢"; I_WARN="󰀦"; I_OK="󰄬"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_DIR="$REPO_ROOT/dotfiles"
BACKUP_ROOT="$HOME/.FxP1998_backups"
PERM_BACKUP="$BACKUP_ROOT/PERMANENT_BACKUP"

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_TRASH}  ${C_BOLD}FxP1998 HYPRLAND RICE UNINSTALLER${C_RESET}"
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}\n"
}

print_step() { echo -e "  ${C_BLUE}${C_BOLD}[${C_RESET}${I_CLEAN}${C_BLUE}${C_BOLD}]${C_RESET} $1"; }
print_success() { echo -e "  ${C_GREEN}${C_BOLD}[${C_RESET}${I_OK}${C_GREEN}${C_BOLD}]${C_RESET} $1"; }
print_warning() { echo -e "  ${C_YELLOW}${C_BOLD}[${C_RESET}${I_WARN}${C_YELLOW}${C_BOLD}]${C_RESET} $1"; }
print_info() { echo -e "      ${I_INFO} $1"; }

# --- Check Environment ---
if [[ $(tty) == /dev/pts/* ]]; then
    clear
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_FAIL}  ${C_BOLD}TERMINAL EMULATOR DETECTED${C_RESET}"
    echo -e "${C_RED}${C_BOLD}${LINE}${C_RESET}\n"
    echo -e "  ${I_INFO} For a safe and perfect restoration, this script"
    echo -e "      MUST be run from a pure TTY (Virtual Console)."
    echo -e "\n  ${C_YELLOW}Please switch to a TTY (Ctrl+Alt+F3) and run again.${C_RESET}"
    echo -e "\n${C_RED}${C_BOLD}${LINE}${C_RESET}"
    exit 1
fi

# --- Execution ---
print_header

print_warning "This will remove the FxP1998 configurations and attempt to restore your system."
read -p "    Are you sure you want to proceed? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "\n  ${I_INFO} Uninstallation cancelled."
    exit 0
fi

# --- Phase 1: Restore Backups ---
echo -e "\n${C_BOLD}Phase 1: Configuration Restoration${C_RESET}"
echo -e "${C_BLUE}${LINE}${C_RESET}"

# Priority: PERMANENT_BACKUP -> Latest Timestamped
RESTORATION_SOURCE=""
if [ -d "$PERM_BACKUP" ]; then
    RESTORATION_SOURCE="$PERM_BACKUP"
    print_success "Found INITIAL PERMANENT BACKUP."
else
    LATEST=$(ls -td "$BACKUP_ROOT"/20* 2>/dev/null | head -1)
    if [ -n "$LATEST" ]; then
        RESTORATION_SOURCE="$LATEST"
        print_success "Found latest timestamped backup."
    fi
fi

if [ -n "$RESTORATION_SOURCE" ]; then
    echo -e "      Source: ${C_YELLOW}$(basename "$RESTORATION_SOURCE")${C_RESET}"
    read -p "    Restore this backup to your $HOME? [y/N]: " restore_confirm
    
    if [[ "$restore_confirm" =~ ^[Yy]$ ]]; then
        print_step "Surgically restoring original files..."
        # Use cp -a to preserve permissions and recursive folders
        cp -af "$RESTORATION_SOURCE"/.?* "$HOME/" 2>/dev/null
        cp -af "$RESTORATION_SOURCE"/* "$HOME/" 2>/dev/null
        print_success "Restoration complete."
    else
        print_warning "Skipping restoration. Proceeding to surgical cleanup."
    fi
else
    print_warning "No usable backups found in $BACKUP_ROOT."
fi

# --- Phase 2: Surgical Cleanup ---
echo -e "\n${C_BOLD}Phase 2: Removing FxP1998 dotfiles${C_RESET}"
echo -e "${C_BLUE}${LINE}${C_RESET}"

if [ -d "$dotfiles_DIR" ]; then
    print_step "Scanning dotfiles for cleanup..."
    
    # 1. Clean root dotfiles
    for item in "$dotfiles_DIR"/{*,.[!.]*}; do
        [ -e "$item" ] || continue
        name=$(basename "$item")
        if [[ "$name" != ".config" && "$name" != ".git" ]]; then
            if [ -e "$HOME/$name" ] && [ ! -L "$HOME/$name" ]; then
                # If it's a real file we just installed, remove it
                rm -rf "$HOME/$name"
                echo -e "      ${C_RED}${I_TRASH}${C_RESET} Removed: ~/$name"
            elif [ -L "$HOME/$name" ]; then
                # If it's a symlink, remove the link
                rm "$HOME/$name"
                echo -e "      ${C_RED}${I_TRASH}${C_RESET} Unlinked: ~/$name"
            fi
        fi
    done

    # 2. Clean .config items
    if [ -d "$dotfiles_DIR/.config" ]; then
        for item in "$dotfiles_DIR/.config"/*; do
            [ -e "$item" ] || continue
            name=$(basename "$item")
            if [ -e "$HOME/.config/$name" ]; then
                rm -rf "$HOME/.config/$name"
                echo -e "      ${C_RED}${I_TRASH}${C_RESET} Removed: ~/.config/$name"
            fi
        done
    fi
    print_success "Surgical cleanup finished."
fi

# --- Phase 3: Shell & Environment ---
echo -e "\n${C_BOLD}Phase 3: Shell & Environment Reset${C_RESET}"
echo -e "${C_BLUE}${LINE}${C_RESET}"

# Reset Shell
if [ "$SHELL" == "/usr/bin/zsh" ]; then
    read -p "    Switch default shell back to Bash? [y/N]: " shell_revert
    if [[ "$shell_revert" =~ ^[Yy]$ ]]; then
        sudo usermod --shell /bin/bash "$USER"
        print_success "Shell reverted to Bash."
    fi
fi

# Cleanup shell files from dynamic injections
for rc in ".zshrc" ".bashrc"; do
    if [ -f "$HOME/$rc" ]; then
        sed -i '/yazi-cwd/d' "$HOME/$rc"
        echo -e "      ${I_INFO} Sanitized ~/$rc"
    fi
done

# --- Phase 4: Service Cleanup ---
echo -e "\n${C_BOLD}Phase 4: Service Cleanup${C_RESET}"
echo -e "${C_BLUE}${LINE}${C_RESET}"

read -p "    Disable 'auto-cpufreq' service? [y/N]: " service_disable
if [[ "$service_disable" =~ ^[Yy]$ ]]; then
    sudo systemctl disable --now auto-cpufreq.service &>/dev/null
    print_success "auto-cpufreq service disabled."
fi

# --- Phase 5: Package Removal (Optional) ---
echo -e "\n${C_BOLD}Phase 5: Package Removal (Optional)${C_RESET}"
echo -e "${C_BLUE}${LINE}${C_RESET}"

TRACKER_FILE="$HOME/.config/FxP1998/installed_packages.txt"

if [ -f "$TRACKER_FILE" ]; then
    # Read packages into a space-separated string for pacman
    PKGS_TO_REMOVE=$(cat "$TRACKER_FILE" | tr '\n' ' ')
    print_warning "The following packages were installed by FxP1998 and will be removed:"
    echo -e "      ${C_YELLOW}$PKGS_TO_REMOVE${C_RESET}\n"
    
    read -p "    Uninstall these tracked packages? [y/N]: " pkg_remove

    if [[ "$pkg_remove" =~ ^[Yy]$ ]]; then
        print_step "Uninstalling Rice packages..."
        # Use sudo and REMOVE --noconfirm so the user can see the progress
        # and we remove the silence (2>/dev/null) to debug failures
        sudo pacman -Rns $PKGS_TO_REMOVE
        
        if [ $? -eq 0 ]; then
            rm -rf "$HOME/.config/FxP1998"
            print_success "Tracked packages removed."
        else
            print_error "Pacman failed to remove some packages."
        fi
    else
        print_success "Packages kept on system."
    fi
else
    print_warning "No package tracker found. Automatic removal skipped for safety."
fi

# --- Final Completion ---
print_header
echo -e "  ${C_GREEN}${C_BOLD}${I_OK} UNINSTALLATION COMPLETE!${C_RESET}"
echo -e "  ${I_INFO} System has been cleaned and backups restored (if selected)."
echo -e "  ${I_INFO} Please ${C_RED}${C_BOLD}reboot${C_RESET} your system for a clean start."
echo -e "\n${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
