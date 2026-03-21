#!/usr/bin/env bash


CORE_PACK=(
	hyprland hypridle hyprlock \
	kitty alacritty pfetch starship pacman-contrib \
	waybar rofi-wayland dunst libnotify libreoffice-fresh meld matugen swww nwg-look imagemagick obs-studio swayosd \
	git base-devel vim vim-plug neovim nano stow \
	nautilus thunar yazi yt-dlp wf-recorder timeshift trash-cli tree wlogout zed zoxide \
	bluez bluez-utils blueman networkmanager network-manager-applet \
	pavucontrol pipewire-alsa pipewire-jack pipewire-pulse pipewire wireplumber pipewire-session-manager \
	intel-ucode intel-media-driver vulkan-intel libva-intel-driver \
	vulkan-radeon mesa xf86-video-vesa xorg xorg-server xorg-xhost \
	xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-gnome xdg-desktop-portal-hyprland \
	vlc vlc-plugins-all vlc-plugin-ffmpeg vlc-plugins-extra mpv mediainfo zathura zathura-pdf-mupdf zathura-cb zathura-djvu zathura-ps \
	polkit-gnome auto-cpufreq udiskie slurp ripgrep unrar unzip wget 7zip reflector \
	bat less jq brightnessctl pamixer btop htop chafa cliphist wl-clipboard eza fd eog fzf amberol kew geany \
	pciutils nvidia-utils libva-vdpau-driver libva-mesa-driver \
	ffmpeg ffmpegthumbnailer gnome-calculator gnome-calendar \
	grim gum gnome-disk-utility gvfs gvfs-mtp gvfs-afc gvfs-google \
	qemu-full virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libvirt ovmf \
	ntfs-3g fuse2 os-prober efibootmgr grub firefox python-pywalfox adw-gtk-theme-git \
	sddm qt5-quickcontrols2 qt5-graphicaleffects qt6-virtualkeyboard qt6-multimedia-ffmpeg \
	zsh zsh-autocomplete zsh-autosuggestions zsh-completions zsh-syntax-highlighting \
	python-pywalfox adw-gtk-theme-git xdg-user-dirs \
	ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-firacode-nerd ttf-jetbrains-mono-nerd
)

# --- 1. Bootstrap Yay ---
if ! command -v yay &> /dev/null; then
    echo ":: Installing Yay (AUR Helper)..."
    sudo pacman -S --needed --noconfirm git base-devel
    rm -rf /tmp/yay-bin && git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd -
fi

# --- 2. Track & Install Packages ---
# Create state directory for surgical uninstallation
STATE_DIR="$HOME/.config/FxP1998"
TRACKER_FILE="$STATE_DIR/installed_packages.txt"
mkdir -p "$STATE_DIR"

echo ":: Identifying new packages to track..."
NEW_PACKAGES=()
for pkg in "${CORE_PACK[@]}"; do
    if ! pacman -Qq "$pkg" &>/dev/null; then
        echo "$pkg" >> "$TRACKER_FILE"
        NEW_PACKAGES+=("$pkg")
    fi
done

# Sort and make the tracker unique
if [ -f "$TRACKER_FILE" ]; then
    sort -u "$TRACKER_FILE" -o "$TRACKER_FILE"
fi

# Using 'yes |' to force 'Yes' on conflicts (e.g., git vs repo versions)
yes | yay -S --needed --noconfirm --answerdiff None --answerclean None "${CORE_PACK[@]}"
