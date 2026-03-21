#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# DESCRIPTION: Shell, GTK Themes & Editor Environment Setup (Official)

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE (Standard ASCII)
    I_CHECK="[OK]"; I_SHELL="[S]"; I_THEME="[T]"; I_GEAR="[*]"; I_INFO="->"; LINE="----------------------------------------------------"
else
    # GUI CANDY MODE (Nerd Fonts)
    I_CHECK="󰄬"; I_SHELL="󱆃"; I_THEME="󰸉"; I_GEAR="󰒓"; I_INFO="󰁔"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Helper Functions ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${I_THEME}  ${C_BOLD}Shell, Themes & Editor Environment${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

print_step() { echo -e "  ${C_BLUE}${C_BOLD}[${C_RESET}${I_GEAR}${C_BLUE}${C_BOLD}]${C_RESET} $1"; }
print_success() { echo -e "  ${C_GREEN}${C_BOLD}[${C_RESET}${I_CHECK}${C_GREEN}${C_BOLD}]${C_RESET} $1"; }

# --- 1. Shell & User Dirs ---
setup_shell() {
    print_step "Configuring Zsh & User Directories..."
    
    # Change shell
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        sudo usermod --shell /usr/bin/zsh "$USER"
        echo -e "      ${I_INFO} Default shell set to Zsh."
    fi

    # User dirs
    xdg-user-dirs-update &>/dev/null
    
    # Yazi integration in .zshrc
    if ! grep -q "yazi-cwd" "$HOME/.zshrc" 2>/dev/null; then
        echo 'function y() { local tmp="$(mktemp)"; yazi "$@" --cwd-file="$tmp"; [ -f "$tmp" ] && cd "$(cat "$tmp")"; rm -f "$tmp"; }' >> "$HOME/.zshrc"
        echo -e "      ${I_INFO} Yazi integration added to .zshrc."
    fi
    print_success "Shell environment ready."
}

# --- 2. GTK & Matugen ---
setup_themes() {
    print_step "Applying GTK & Matugen Templates..."
    
    # Portability Fix for .gtkrc-2.0
    if [ -f "$HOME/.gtkrc-2.0" ]; then
        sed -i "s|include \".*/.gtkrc-2.0.mine\"|include \"$HOME/.gtkrc-2.0.mine\"|g" "$HOME/.gtkrc-2.0"
        echo -e "      ${I_INFO} Portability fix applied to .gtkrc-2.0"
    fi

    # Trigger Matugen to generate initial configs
    if command -v matugen &>/dev/null; then
        echo -e "      ${I_INFO} Generating Material You configurations..."
        matugen -c "$HOME/.config/matugen/config.toml" image "$HOME/.config/hypr/assets/current-wallpaper.png" --source-color-index 0 --type scheme-rainbow >/dev/null 2>&1
    fi

    # GTK settings
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' &>/dev/null
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' &>/dev/null

    # Matugen Templates
    mkdir -p "$HOME/.config/matugen/templates"
    local GTK_TMPL="$HOME/.config/matugen/templates/gtk-colors.css"
    if [ ! -f "$GTK_TMPL" ]; then
        cat << 'EOF' > "$GTK_TMPL"
@define-color accent_color {{colors.primary.default.hex}};
@define-color accent_bg_color {{colors.primary.default.hex}};
@define-color accent_fg_color {{colors.on_primary.default.hex}};
@define-color window_bg_color {{colors.background.default.hex}};
@define-color window_fg_color {{colors.on_surface.default.hex}};
@define-color view_bg_color {{colors.surface.default.hex}};
@define-color view_fg_color {{colors.on_surface.default.hex}};
EOF
    fi
    print_success "Themes & Matugen templates applied."
}

# --- 3. Editor Setup (Vim, Neovim, Zed) ---
setup_editors() {
    print_step "Initializing Editor Configs (Vim/Nvim/Zed)..."

    # Zed
    mkdir -p "$HOME/.config/zed/themes"
    [ ! -f "$HOME/.config/zed/settings.json" ] && echo '{"theme": "Matugen Dark", "vim_mode": false}' > "$HOME/.config/zed/settings.json"

    # Neovim (Lazy.nvim setup)
    mkdir -p "$HOME/.config/nvim"
    if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        cat << 'EOF' > "$HOME/.config/nvim/init.lua"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
require("lazy").setup({{ "RRethy/base16-nvim", priority = 1000 }, { "typicode/bg.nvim", lazy = false }})
EOF
    fi

    # Vim-Plug
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null
    fi

    # Nano Syntax Highlighting
    if [ ! -d "$HOME/.nano" ]; then
        sudo curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh &>/dev/null
    fi

    print_success "Editors initialized successfully."
}

# --- Execution ---
print_header

setup_shell
echo ""
setup_themes
echo ""
setup_editors

echo -e "\n${C_GREEN}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
print_success "Shell & Environment Tuning Complete!"
echo -e "  ${I_INFO} Please restart your shell to apply all changes."
echo -e "${C_GREEN}${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
