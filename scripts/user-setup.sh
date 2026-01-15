#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# MERGED USER SETUP: Shell, Dotfiles, Themes, Tools

# --- 1. DYNAMIC PATH DETECTION (CRITICAL FIX) ---
# Get the directory where THIS script is running (e.g., ~/FxP1998/scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Go up one level to find the Repo Root (e.g., ~/FxP1998)
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Define the Source of the dotfiles (e.g., ~/FxP1998/Dotfiles)
SOURCE_DIR="$REPO_ROOT/Dotfiles"

TARGET_USER=$USER
USER_HOME="/home/$TARGET_USER"
BACKUP_DIR="$USER_HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

BLUE="\033[1;34m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"; RESET="\033[0m"
BOLD="\033[1m"

# --- OWNERSHIP FIX FUNCTION ---
fix_ownership() {
    local target="$1"
    if [ -d "$target" ] || [ -f "$target" ]; then
        sudo chown -R "$TARGET_USER:$TARGET_USER" "$target"
    fi
}

YAY_PACKAGES=("pfetch" "wlogout" "kew" "python-pywalfox" "adw-gtk-theme-git" "vim-plug") 

echo -e "${BLUE}=====================================================${RESET}"
echo -e "${BOLD}          PHASE 1: AUR TOOLS & SHELL                 ${RESET}"
echo -e "${BLUE}=====================================================${RESET}"

# 1. Install Yay
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}:: Installing Yay (AUR Helper)...${RESET}"
    sudo pacman -S --needed --noconfirm git base-devel &> /dev/null
    rm -rf /tmp/yay-bin && git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd - &> /dev/null
    echo -e "${GREEN}✔ Yay installed successfully.${RESET}"
else
    echo -e "${GREEN}✔ Yay is already installed.${RESET}"
fi

# 2. Shell Setup
echo -e "${YELLOW}:: Setting up Zsh...${RESET}"
sudo pacman -S --needed --noconfirm zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-autocomplete &> /dev/null
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo usermod --shell /usr/bin/zsh "$TARGET_USER"
    echo -e "${GREEN}✔ Shell changed to Zsh.${RESET}"
fi

# 3. Install AUR Packages
echo -e "${YELLOW}:: Installing AUR Packages...${RESET}"
yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"

# 4. Extractor Deps
sudo pacman -S --needed --noconfirm xdg-user-dirs unzip unrar p7zip zstd xz gzip bzip2 tar &> /dev/null
xdg-user-dirs-update

# Yazi Shell Integration
if ! grep -q "yazi-cwd" "$USER_HOME/.zshrc" 2>/dev/null; then
    echo 'function y() { local tmp="$(mktemp)"; yazi "$@" --cwd-file="$tmp"; [ -f "$tmp" ] && cd "$(cat "$tmp")"; rm -f "$tmp"; }' >> "$USER_HOME/.zshrc"
fi


echo -e "\n${BLUE}=====================================================${RESET}"
echo -e "${BOLD}          PHASE 2: DOTFILES SYNC (UNIVERSAL)         ${RESET}"
echo -e "${BLUE}=====================================================${RESET}"

# --- VERIFICATION ---
echo -e "   Repo Root:  $REPO_ROOT"
echo -e "   Source Dir: $SOURCE_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}[ERROR] Source directory not found at: $SOURCE_DIR${RESET}"
    echo -e "Please make sure the 'Dotfiles' folder exists inside '$REPO_ROOT'."
    exit 1
fi

echo -e "${YELLOW}:: Dotfiles detected.${RESET}"
echo -e "   [B]ackup existing files (Recommended)"
echo -e "   [D]elete existing files (Fresh Install)"
echo -e "   [S]kip copying"
read -p "Select option [B/D/S]: " COPY_CHOICE

if [[ "$COPY_CHOICE" =~ ^[BbDd]$ ]]; then
    
    echo -e "${YELLOW}:: Syncing ALL configurations...${RESET}"
    
    # Enable dotglob to copy hidden files (.config, .zshrc)
    shopt -s dotglob
    
    for item in "$SOURCE_DIR"/*; do
        name=$(basename "$item")
        
        # Skip git metadata and the script itself
        if [[ "$name" == ".git" || "$name" == "install.sh" || "$name" == "." || "$name" == ".." ]]; then
            continue
        fi

        DEST="$USER_HOME/$name"
        
        # HANDLE EXISTING FILES
        if [ -e "$DEST" ]; then
            if [[ "$COPY_CHOICE" =~ ^[Bb]$ ]]; then
                sudo mkdir -p "$BACKUP_DIR"
                echo -e "   [BACKUP] $name -> .dotfiles-backup/"
                sudo mv "$DEST" "$BACKUP_DIR/"
            else
                echo -e "   [DELETE] $name"
                sudo rm -rf "$DEST"
            fi
        fi
        
        # COPY NEW FILES
        echo -e "   [COPY]   $name"
        sudo cp -r "$item" "$USER_HOME/"
        
        # FIX OWNERSHIP OF COPIED FILES
        fix_ownership "$DEST"
    done
    
    shopt -u dotglob
    
    echo -e "${GREEN}✔ All Dotfiles Synced Successfully.${RESET}"
else
    echo -e "Skipping Copy."
fi


echo -e "\n${BLUE}==============================================${RESET}"
echo -e "${BOLD}          PHASE 3: GTK & THEMES          ${RESET}"
echo -e "${BLUE}==============================================${RESET}"

echo -e "${YELLOW}:: Applying Theme Settings...${RESET}"
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface icon-theme 'BeautySolar'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Create Matugen Source Template
MATUGEN_DIR="$USER_HOME/.config/matugen"
mkdir -p "$MATUGEN_DIR/templates"
if [ ! -f "$MATUGEN_DIR/templates/gtk-colors.css" ]; then
    cat << 'EOF' > "$MATUGEN_DIR/templates/gtk-colors.css"
@define-color accent_color {{colors.primary.default.hex}};
@define-color accent_bg_color {{colors.primary.default.hex}};
@define-color accent_fg_color {{colors.on_primary.default.hex}};
@define-color window_bg_color {{colors.background.default.hex}};
@define-color window_fg_color {{colors.on_surface.default.hex}};
@define-color view_bg_color {{colors.surface.default.hex}};
@define-color view_fg_color {{colors.on_surface.default.hex}};
EOF
    fix_ownership "$MATUGEN_DIR"
fi

echo -e "\n${BLUE}==============================================================${RESET}"
echo -e "${BOLD}          PHASE 4: EDITORS (VIM, NEOVIM, ZED)          ${RESET}"
echo -e "${BLUE}==============================================================${RESET}"

# 1. ZED Setup
sudo pacman -S --needed --noconfirm zed jq &> /dev/null
ZED_CONFIG="$USER_HOME/.config/zed"
sudo mkdir -p "$ZED_CONFIG/themes"
fix_ownership "$ZED_CONFIG"

if [ ! -f "$ZED_CONFIG/settings.json" ]; then
    echo '{"theme": "Matugen Dark", "vim_mode": false}' > "$ZED_CONFIG/settings.json"
    fix_ownership "$ZED_CONFIG/settings.json"
fi

# 2. Neovim Setup
NVIM_CONFIG="$USER_HOME/.config/nvim"
sudo mkdir -p "$NVIM_CONFIG"
fix_ownership "$NVIM_CONFIG"
if [ ! -f "$NVIM_CONFIG/init.lua" ]; then
    cat << 'EOF' > "$NVIM_CONFIG/init.lua"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
require("lazy").setup({{ "RRethy/base16-nvim", priority = 1000 }, { "typicode/bg.nvim", lazy = false }})
local function load_matugen()
  local theme = vim.fn.stdpath("config") .. "/lua/matugen_theme.lua"
  if vim.fn.filereadable(theme) == 1 then pcall(dofile, theme) end
end
vim.api.nvim_create_autocmd("Signal", { pattern = "SIGUSR1", callback = function() vim.schedule(load_matugen) end })
load_matugen()
EOF
    fix_ownership "$NVIM_CONFIG/init.lua"
fi

# 3. vim plugin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 4. Nano Syntex highlighter
sudo curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

echo -e "\n${BLUE}=========================================================${RESET}"
echo -e "${BOLD}          PHASE 5: FILE MANAGER (YAZI)          ${RESET}"
echo -e "${BLUE}=========================================================${RESET}"

sudo pacman -S --needed --noconfirm yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick wl-clipboard &> /dev/null
YAZI_CONFIG="$USER_HOME/.config/yazi"
sudo mkdir -p "$YAZI_CONFIG/plugins"
fix_ownership "$YAZI_CONFIG"
if [ ! -f "$YAZI_CONFIG/yazi.toml" ]; then
    cat << 'EOF' > "$YAZI_CONFIG/yazi.toml"
[manager]
show_hidden = true
[opener]
edit = [ { run = '${EDITOR:-nvim} "$@"', block = true, for = "unix" } ]
open = [ { run = 'xdg-open "$1"', desc = "Open", for = "linux" } ]
EOF
    fix_ownership "$YAZI_CONFIG/yazi.toml"
fi

# Final Matugen Link
if [ ! -f "$MATUGEN_DIR/config.toml" ]; then
    sudo touch "$MATUGEN_DIR/config.toml"
    fix_ownership "$MATUGEN_DIR/config.toml"
fi

append_template() {
    local name=$1; local content=$2
    if ! grep -q "\[templates.$name\]" "$MATUGEN_DIR/config.toml"; then
        echo -e "$content" >> "$MATUGEN_DIR/config.toml"
        fix_ownership "$MATUGEN_DIR/config.toml"
    fi
}
append_template "gtk3" "\n[templates.gtk3]\ninput_path = '~/.config/matugen/templates/gtk-colors.css'\noutput_path = '~/.config/gtk-3.0/colors.css'\npost_hook = \"gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'\""
append_template "gtk4" "\n[templates.gtk4]\ninput_path = '~/.config/matugen/templates/gtk-colors.css'\noutput_path = '~/.config/gtk-4.0/colors.css'"
append_template "zed" "\n[templates.zed]\ninput_path = '~/.config/matugen/templates/zed-colors.json'\noutput_path = '~/.config/zed/themes/matugen.json'"
append_template "neovim" "\n[templates.neovim]\ninput_path = '~/.config/matugen/templates/neovim/template.lua'\noutput_path = '~/.config/nvim/lua/matugen_theme.lua'\npost_hook = 'pkill -SIGUSR1 nvim'"

echo -e "\n${GREEN}✔ USER SETUP COMPLETE!${RESET}"
echo -e "${BLUE}=================================================${RESET}\n"
