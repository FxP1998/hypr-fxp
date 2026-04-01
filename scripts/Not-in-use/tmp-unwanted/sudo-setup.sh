#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# MERGED SYSTEM SETUP: Packages, Performance, Drivers, Display

TARGET_USER="$1"
USER_HOME="/home/$TARGET_USER"

# --- VISUAL & COMPATIBILITY ENGINE ---
if [[ "$TERM" == "linux" ]]; then
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_GEAR="[*]"; IC_OK="[OK]"; IC_FAIL="[!!]"; IC_INFO="->"; LINE_SEC="---------------------------------------"
else
    C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELL='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'
    IC_GEAR="⚙️ "; IC_OK="✔"; IC_FAIL="✖"; IC_INFO="➜"; LINE_SEC="───────────────────────────────────────"
fi

if [ "$EUID" -ne 0 ]; then 
    echo -e "${C_RED}${IC_FAIL} This script MUST run as root.${C_RESET}"
    exit 1
fi

# --- SMART EXECUTION FUNCTION ---
run_as() {
    local user="$1"
    local cmd="$2"
    if [ "$user" == "root" ]; then
        bash -c "$cmd"
    else
        sudo -u "$user" bash -c "$cmd"
    fi
}

# --- OWNERSHIP FIX FUNCTION ---
fix_ownership() {
    local target="$1"
    if [ -d "$target" ] || [ -f "$target" ]; then
        chown -R "$TARGET_USER:$TARGET_USER" "$target"
    fi
}

# --- CORE PACKAGE LIST ---
OFFICIAL_PACKAGES=(
    "starship" "nautilus" "thunar" "firefox" "exa" "hyprland" "hyprlock" "hypridle" "waybar" "kitty" "alacritty" "rofi-wayland" 
    "vim" "neovim" "geany" "grub" "efibootmgr" "os-prober" "slurp" "grim" "network-manager-applet" "blueman" "bluez" "bluez-utils" 
    "swayosd" "cliphist" "udiskie" "mediainfo" "brightnessctl" "pavucontrol" "wireplumber" "pipewire" "pipewire-pulse" "pipewire-alsa"
    "pipewire-libcamera" "pipewire-session-manager" "base-devel" "git" "imagemagick" "jq" "xorg-xhost" "xorg-server" "xorg" "xorg-xinput"
    "xorg-xrandr" "intel-ucode" "vulkan-radeon" "vulkan-intel" "mesa" "zoxide" "polkit-gnome" "xdg-user-dirs" "xdg-desktop-portal"
    "xdg-desktop-portal-gtk" "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gnome" "gnome-disk-utility" "timeshift" "pacman-contrib"
    "stow" "wget" "trash-cli" "awww" "mako" "matugen" "nwg-look" "htop" "btop"
)

echo -e "${C_BLUE}${LINE_SEC}${C_RESET}"
echo -e "   ${IC_GEAR} STEP 1: CORE SYSTEM PACKAGES"
echo -e "${C_BLUE}${LINE_SEC}${C_RESET}"

echo -e "${C_YELL}${IC_INFO} Updating repositories...${C_RESET}"
pacman -Sy

echo -e "${C_YELL}${IC_INFO} Installing Official Packages...${C_RESET}"
pacman -S --needed g "${OFFICIAL_PACKAGES[@]}"
echo -e "${C_GREEN}${IC_OK} Core packages installed.${C_RESET}"

echo -e "\n${C_BLUE}${LINE_SEC}${C_RESET}"
echo -e "   ${IC_GEAR} STEP 2: PERFORMANCE (AUTO-CPUFREQ)"
echo -e "${C_BLUE}${LINE_SEC}${C_RESET}"

if ! command -v auto-cpufreq &> /dev/null; then
    echo -e "${C_YELL}${IC_INFO} Building auto-cpufreq...${C_RESET}"
    WORKDIR="/tmp/auto-cpufreq-build"
    rm -rf "$WORKDIR" && mkdir -p "$WORKDIR"
    chown -R "$TARGET_USER" "$WORKDIR"
    
    echo -e "   - Building as $TARGET_USER..."
    run_as "$TARGET_USER" "cd $WORKDIR && git clone https://aur.archlinux.org/auto-cpufreq.git && cd auto-cpufreq && makepkg -s g"
    
    echo -e "   - Installing as Root..."
    cd "$WORKDIR/auto-cpufreq" && pacman -U g *.pkg.tar.zst
fi

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
mkdir -p "$USER_HOME/.config/auto-cpufreq"
echo "$CPU_CONFIG" > "$USER_HOME/.config/auto-cpufreq/auto-cpufreq.conf"
fix_ownership "$USER_HOME/.config/auto-cpufreq"

systemctl enable --now auto-cpufreq.service &> /dev/null
echo -e "${C_GREEN}${IC_OK} Power Optimization Active.${C_RESET}"

echo -e "\n${C_BLUE}${LINE_SEC}${C_RESET}"
echo -e "   ${IC_GEAR} STEP 3: MEDIA & HARDWARE DRIVERS"
echo -e "${C_BLUE}${LINE_SEC}${C_RESET}"

if pacman -Qs jack2 > /dev/null; then
    pacman -Rdd g jack2 &> /dev/null
fi

echo -e "${C_YELL}${IC_INFO} Installing Drivers...${C_RESET}"
echo -e "${C_YELL}${IC_INFO} Please wait this may take a few minutes, It's depending on your internet speed...${C_RESET}"
MEDIA_PKGS=(obs-studio vlc vlc-plugin-ffmpeg vlc-plugins-extra vlc-plugins-all mpv intel-media-driver libva-intel-driver pipewire-jack pciutils mesa libva-mesa-driver)
pacman -S --needed g "${MEDIA_PKGS[@]}" &> /dev/null

echo -e "${C_YELL}${IC_INFO} Generating MPV Configuration...${C_RESET}"
MPV_DIR="$USER_HOME/.config/mpv"
mkdir -p "$MPV_DIR"

cat <<EOF > "$MPV_DIR/mpv.conf"
vo=gpu
gpu-api=opengl
hwdec=auto-safe
save-position-on-quit=yes
video-sync=display-resample
interpolation=yes
tscale=oversample
EOF

if lspci | grep -i "NVIDIA" &> /dev/null; then
    pacman -S --needed g nvidia-utils libva-vdpau-driver &> /dev/null
    echo "hwdec=nvdec" >> "$MPV_DIR/mpv.conf"
elif lspci | grep -i "AMD" &> /dev/null; then
    echo "hwdec=vaapi" >> "$MPV_DIR/mpv.conf"
fi
fix_ownership "$MPV_DIR"

echo -e "${C_GREEN}${IC_OK} Media Engine Ready.${C_RESET}"

echo -e "\n${C_BLUE}${LINE_SEC}${C_RESET}"
echo -e "   ${IC_GEAR} STEP 4: DISPLAY MANAGER (SDDM)"
echo -e "${C_BLUE}${LINE_SEC}${C_RESET}"

echo -e "${C_YELL}${IC_INFO} Installing SDDM Packages...${C_RESET}"
pacman -Sy --needed g sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg &> /dev/null

echo -e "${C_YELL}${IC_INFO} Launching Theme Installer (As User)...${C_RESET}"
run_as "$TARGET_USER" "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

systemctl enable sddm.service &> /dev/null
echo -e "${C_GREEN}${IC_OK} SDDM Setup Complete.${C_RESET}"
