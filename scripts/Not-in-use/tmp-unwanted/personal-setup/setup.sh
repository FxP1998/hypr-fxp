#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998
# DESCRIPTION: Universal System Base Installer (Multi-WM, Drivers, Utilities)
# VERSION: 2.2 (TTY Safe Edition)

# --- 1. SETUP & LOGGING ---
TARGET_USER="$1"
USER_HOME="/home/$TARGET_USER"
LOG_FILE="/var/log/fxp_install_$(date +%Y%m%d_%H%M%S).log"

# Safe ASCII Colors (Bold/High Intensity for visibility in TTY)
BLUE="\033[1;34m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"; RESET="\033[0m"
BOLD="\033[1m"

# TTY Safe Indicators
OK="[OK]"
FAIL="[FAIL]"
WARN="[!!]"
INFO=">>"

# Pre-flight Checks
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}$FAIL This script requires root privileges.${RESET}"
    exit 1
fi

if [ -z "$TARGET_USER" ]; then
    echo -e "${RED}$FAIL Target user not specified.${RESET}"
    echo -e "Usage: sudo ./sudo-setup.sh <username>"
    exit 1
fi

# Enable Logging
exec > >(tee -i "$LOG_FILE") 2>&1

echo -e "${BLUE}==============================================================${RESET}"
echo -e "${BOLD}   FXP UNIVERSAL BASE INSTALLER v2.2 (TTY SAFE)   ${RESET}"
echo -e "   $INFO Author: M. H. IMAM (FxP1998)"
echo -e "   $INFO User:   $TARGET_USER"
echo -e "   $INFO Log:    $LOG_FILE"
echo -e "${BLUE}==============================================================${RESET}"

# --- HELPER FUNCTIONS ---
run_as_user() {
    sudo -u "$TARGET_USER" bash -c "$1"
}

# --- 2. PACKAGE DEFINITIONS ---

# Official Repository Packages
OFFICIAL_PACKAGES=(
    # SYSTEM CORE
    "base-devel" "git" "wget" "curl" "vim" "neovim" "nano"
    "btop" "htop" "fastfetch" "onefetch" "fzf" "ripgrep" "fd" "jq" "eza" "bat" "zoxide"
    "wl-clipboard" "xclip" "cliphist" "brightnessctl" "playerctl" "pamixer" "awww" "nwg-look"

    # ARCHIVE TOOLS
    "unzip" "unrar" "p7zip" "tar" "gzip" "bzip2" "xz" "zstd" "lz4" "cpio"

    # XORG & WAYLAND UTILITIES
    "xorg-server" "xorg-xinit" "xorg-xwayland" "xorg-xhost" "xorg-xinput" "xorg-xrender"
    "qt5-wayland" "qt6-wayland"

    # DRIVERS & FIRMWARE
    "mesa" "vulkan-intel" "vulkan-radeon" "intel-ucode" "amd-ucode" "libva-mesa-driver"

    # WINDOW MANAGERS
    "hyprland" "hyprlock" "hypridle" "hyprpaper" "xdg-desktop-portal-hyprland"
    "sway" "swaybg" "swaylock" "swayidle" "xdg-desktop-portal-wlr"
    "niri" "xwayland-satellite" "fuzzel"
    "i3-wm" "i3status" "i3lock" "dmenu" "picom" "feh" "arandr"
    "bspwm" "sxhkd" "polybar" "dunst"

    # SHARED GUI TOOLS
    "waybar" "rofi-wayland" "mako" "swayosd" "wlogout"
    "polkit-gnome" "gnome-keyring" "libsecret" "grim" "slurp" "flameshot"

    # TERMINALS
    "zsh" "starship" "kitty" "alacritty" "foot"

    # FILE MANAGEMENT (Full GVFS)
    "thunar" "thunar-volman" "thunar-archive-plugin" "tumbler" "ffmpegthumbnailer"
    "nautilus" "file-roller" "ranger" "yazi"
    "gvfs" "gvfs-mtp" "gvfs-smb" "gvfs-afc" "gvfs-gphoto2" "gvfs-nfs" "gvfs-google"
    "udiskie" "ntfs-3g" "dosfstools" "exfat-utils"

    # NETWORK & AUDIO
    "networkmanager" "network-manager-applet" "bluez" "bluez-utils" "blueman"
    "pipewire" "pipewire-pulse" "pipewire-alsa" "pipewire-jack" "wireplumber" "pavucontrol"

    # APPS
    "firefox" "libreoffice-fresh" "obs-studio" "gimp" "inkscape"
    "vlc" "mpv" "imv" "zathura" "zathura-pdf-mupdf"
    
    # FONTS
    "ttf-jetbrains-mono-nerd" "ttf-font-awesome" "noto-fonts" "noto-fonts-emoji" "noto-fonts-cjk" "ttf-firacode-nerd"
)

# AUR Packages
AUR_PACKAGES=(
    "auto-cpufreq-git" 
    "kew" 
    "matugen-bin" 
    "sddm-astronaut-theme"
)

# --- PHASE 1: SYSTEM REPOSITORIES ---
echo -e "${BLUE}--------------------------------------------------------------${RESET}"
echo -e "${BOLD} PHASE 1: SYSTEM UPDATE & CORE PACKAGES ${RESET}"
echo -e "${BLUE}--------------------------------------------------------------${RESET}"

echo -e "${YELLOW}$INFO Refreshing keys...${RESET}"
pacman -Sy --noconfirm archlinux-keyring

echo -e "${YELLOW}$INFO Installing Official Packages...${RESET}"
pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"

# GPU Specific
echo -e "${YELLOW}$INFO Checking GPU...${RESET}"
if lspci | grep -i "NVIDIA" &> /dev/null; then
    echo -e "   $INFO NVIDIA Detected. Installing drivers..."
    pacman -S --needed --noconfirm nvidia-dkms nvidia-utils libva-vdpau-driver egl-wayland
elif lspci | grep -i "AMD" &> /dev/null; then
    echo -e "   $INFO AMD Detected. Installing drivers..."
    pacman -S --needed --noconfirm xf86-video-amdgpu
else
    echo -e "   $INFO Integrated/Intel graphics assumed."
fi

echo -e "${GREEN}$OK Core Installation Complete.${RESET}"


# --- PHASE 2: AUR SETUP ---
echo -e "\n${BLUE}--------------------------------------------------------------${RESET}"
echo -e "${BOLD} PHASE 2: AUR HELPER (YAY) ${RESET}"
echo -e "${BLUE}--------------------------------------------------------------${RESET}"

if ! run_as_user "command -v yay &> /dev/null"; then
    echo -e "${YELLOW}$INFO Building 'yay'...${RESET}"
    run_as_user "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin"
    run_as_user "cd /tmp/yay-bin && makepkg -si --noconfirm"
    run_as_user "rm -rf /tmp/yay-bin"
else
    echo -e "${GREEN}$OK Yay is already installed.${RESET}"
fi

echo -e "${YELLOW}$INFO Installing AUR Packages...${RESET}"
run_as_user "yay -S --needed --noconfirm ${AUR_PACKAGES[*]}"
echo -e "${GREEN}$OK AUR Complete.${RESET}"


# --- PHASE 3: CONFIGURATION ---
echo -e "\n${BLUE}---------------------------------------${RESET}"
echo -e "${BOLD} PHASE 3: POWER & SERVICES ${RESET}"
echo -e "${BLUE}-----------------------------------------${RESET}"

echo -e "${YELLOW}$INFO Configuring Auto-CPUFreq...${RESET}"
CPU_CONFIG="[charger]
governor = performance
energy_performance_preference = performance
turbo = auto

[battery]
governor = powersave
energy_performance_preference = power
energy_perf_bias = power
platform_profile = low-power
turbo = never"
echo "$CPU_CONFIG" > /etc/auto-cpufreq.conf

check_service() {
    if ! systemctl is-enabled --quiet "$1"; then
        echo -e "   $INFO Enabling $1..."
        systemctl enable --now "$1"
    else
        echo -e "   $OK $1 is enabled."
    fi
}

echo -e "${YELLOW}$INFO Checking Services...${RESET}"
check_service "NetworkManager"
check_service "bluetooth"
check_service "auto-cpufreq"
check_service "avahi-daemon"
check_service "fstrim.timer"


# --- PHASE 4: DISPLAY MANAGER (Smart Failover) ---
echo -e "\n${BLUE}--------------------------------------------------${RESET}"
echo -e "${BOLD} PHASE 4: DISPLAY MANAGER (SDDM/GDM) ${RESET}"
echo -e "${BLUE}----------------------------------------------------${RESET}"

# Read from TTY directly
echo -e "Select Display Manager:"
echo -e "1) ${BOLD}SDDM${RESET} (Astronaut Theme)"
echo -e "2) ${BOLD}GDM${RESET}"
echo -e "3) ${BOLD}Skip${RESET}"
read -p "Enter Choice [1-3]: " DM_CHOICE < /dev/tty

# Clean up old DMs
systemctl disable --now gdm sddm lightdm lxdm &> /dev/null

case $DM_CHOICE in
    1)
        echo -e "${YELLOW}$INFO Installing SDDM...${RESET}"
        pacman -S --needed --noconfirm sddm
        
        # SMART FAILOVER LOGIC FOR THEME
        echo -e "${YELLOW}$INFO Installing Astronaut Theme...${RESET}"
        THEME_CMD="curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh | bash"
        
        # Try 1: Run as User (Safer)
        if run_as_user "$THEME_CMD"; then
            echo -e "${GREEN}$OK Theme installed as User.${RESET}"
        else
            echo -e "${WARN} User install failed. Retrying as ROOT..."
            # Try 2: Run as Root (Force)
            if bash -c "$THEME_CMD"; then
                 echo -e "${GREEN}$OK Theme installed as Root.${RESET}"
            else
                 echo -e "${RED}$FAIL Theme installation failed completely.${RESET}"
            fi
        fi

        # Force Config
        mkdir -p /etc/sddm.conf.d
        echo "[Theme]
Current=sddm-astronaut-theme" > /etc/sddm.conf.d/theme.conf
        
        systemctl enable sddm
        echo -e "${GREEN}$OK SDDM Enabled.${RESET}"
        ;;
    2)
        echo -e "${YELLOW}$INFO Installing GDM...${RESET}"
        pacman -S --needed --noconfirm gdm
        systemctl enable gdm
        echo -e "${GREEN}$OK GDM Enabled.${RESET}"
        ;;
    3)
        echo -e "${YELLOW}$INFO Skipping Display Manager.${RESET}"
        ;;
    *)
        echo -e "${RED}$FAIL Invalid choice.${RESET}"
        ;;
esac

echo -e "\n${GREEN}=====================================${RESET}"
echo -e "${BOLD}  INSTALLATION COMPLETE ${RESET}"
echo -e "  $INFO Log saved to: $LOG_FILE"
echo -e "${GREEN}=======================================${RESET}"
