#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

MATUGEN_DIR="$HOME/.config/matugen"
TEMPLATE_DIR="$MATUGEN_DIR/templates"
THEMES_DIR="$HOME/.local/share/themes"
GTK3_DIR="$HOME/.config/gtk-3.0"
GTK4_DIR="$HOME/.config/gtk-4.0"

echo -e "${BLUE}▶ STARTING GTK THEME SETUP (Import Strategy)...${RESET}"

# -----------------------------------------------------
# 1. INSTALL ADW-GTK3 (The Base)
# -----------------------------------------------------
INSTALLED=false

# Method A: Try installing 'adw-gtk-theme-git' via AUR
if command -v yay &> /dev/null; then
    echo -e "${BLUE}:: Installing 'adw-gtk-theme-git' via AUR...${RESET}"
    if yay -S --needed --noconfirm adw-gtk-theme-git; then
        echo -e "${GREEN}✔ adw-gtk-theme-git installed successfully.${RESET}"
        INSTALLED=true
    else
        echo -e "${RED}[WARN] AUR install failed. Switching to manual fallback.${RESET}"
    fi
fi

# Method B: Manual Download (Fallback)
if [ "$INSTALLED" = false ]; then
    echo -e "${BLUE}:: Downloading adw-gtk3 binaries manually...${RESET}"
    mkdir -p "$THEMES_DIR"
    
    # Robust download
    curl -L -A "Mozilla/5.0" -o /tmp/adw-gtk3.tar.xz "https://github.com/lassekongo83/adw-gtk3/releases/download/v5.3/adw-gtk3v5-3.tar.xz"
    
    FILE_SIZE=$(du -k "/tmp/adw-gtk3.tar.xz" | cut -f1)
    if [ "$FILE_SIZE" -lt 10 ]; then
        echo -e "${RED}[ERROR] Download failed. Please check your internet.${RESET}"
        exit 1
    fi

    # Extract
    tar -xf /tmp/adw-gtk3.tar.xz -C "$THEMES_DIR"
    echo -e "${GREEN}✔ adw-gtk3 installed to ~/.local/share/themes${RESET}"
fi

# -----------------------------------------------------
# 2. SETUP DIRECTORIES
# -----------------------------------------------------
echo -e "${BLUE}:: Creating Config Directories...${RESET}"
mkdir -p "$GTK3_DIR"
mkdir -p "$GTK4_DIR"

# -----------------------------------------------------
# 3. CREATE DEFAULT COLORS.CSS (Your Static Defaults)
# -----------------------------------------------------
echo -e "${BLUE}:: Creating Default colors.css...${RESET}"

DEFAULT_COLORS=$(cat << 'EOF'
/* GTK 3/4 COLOR PALETTE | Default by FxP */

/* --- MAIN ACCENTS --- */
@define-color accent_color #ffb597;
@define-color accent_bg_color #ffb597;
@define-color accent_fg_color #552107;

/* --- WINDOW & SURFACES --- */
@define-color window_bg_color #1a110e;
@define-color window_fg_color #f1dfd9;
@define-color view_bg_color #140c09;
@define-color view_fg_color #f1dfd9;

@define-color headerbar_bg_color #1a110e;
@define-color headerbar_fg_color #f1dfd9;
@define-color headerbar_border_color #53443e;
@define-color headerbar_backdrop_color @window_bg_color;
@define-color headerbar_shade_color rgba(0, 0, 0, 0.07);

@define-color card_bg_color #231a16;
@define-color card_fg_color #f1dfd9;
@define-color card_shade_color rgba(0, 0, 0, 0.07);

@define-color popover_bg_color #322824;
@define-color popover_fg_color #f1dfd9;

@define-color dialog_bg_color #271e1a;
@define-color dialog_fg_color #f1dfd9;

/* --- SIDEBARS --- */
@define-color sidebar_bg_color #231a16;
@define-color sidebar_fg_color #f1dfd9;
@define-color sidebar_border_color #53443e;
@define-color sidebar_backdrop_color @window_bg_color;

/* --- SEMANTIC --- */
@define-color destructive_color #ffb4ab;
@define-color destructive_bg_color #ffb4ab;
@define-color destructive_fg_color #690005;
@define-color success_color #d3c78f;
@define-color success_bg_color #d3c78f;
@define-color success_fg_color #373106;
@define-color warning_color #e7beae;
@define-color warning_bg_color #e7beae;
@define-color warning_fg_color #442a1f;
@define-color error_color #ffb4ab;
@define-color error_bg_color #ffb4ab;
@define-color error_fg_color #690005;

/* --- MISC --- */
@define-color scrollbar_outline_color #a08d86;
@define-color osd_bg_color #f1dfd9;
@define-color osd_fg_color #382e2a;
@define-color osd_backdrop_bg_color #000000;
EOF
)

# Write to both directories
echo "$DEFAULT_COLORS" > "$GTK3_DIR/colors.css"
echo "$DEFAULT_COLORS" > "$GTK4_DIR/colors.css"

# -----------------------------------------------------
# 4. CREATE GTK.CSS (The Import Logic)
# -----------------------------------------------------
echo -e "${BLUE}:: Creating gtk.css with Import Logic...${RESET}"

IMPORT_LINE="@import 'colors.css';"

echo "$IMPORT_LINE" > "$GTK3_DIR/gtk.css"
echo "$IMPORT_LINE" > "$GTK4_DIR/gtk.css"

# -----------------------------------------------------
# 5. CREATE SETTINGS.INI (Fonts, Icons, Cursors)
# -----------------------------------------------------
echo -e "${BLUE}:: Creating settings.ini...${RESET}"

cat << 'EOF' > "$GTK3_DIR/settings.ini"
[Settings]
gtk-icon-theme-name=BeautySolar
gtk-theme-name=adw-gtk3
gtk-font-name=Maple Mono NF 11
gtk-cursor-theme-name=Future-cursors
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

# -----------------------------------------------------
# 6. UPDATE MATUGEN CONFIG (To Target colors.css)
# -----------------------------------------------------
echo -e "${BLUE}:: Updating Matugen Config...${RESET}"
mkdir -p "$TEMPLATE_DIR"

# Ensure config.toml points to colors.css, NOT gtk.css
# This is crucial so we don't overwrite the @import line
if ! grep -q "output_path = '~/.config/gtk-3.0/colors.css'" "$MATUGEN_DIR/config.toml"; then
    # We remove old GTK blocks if they exist to avoid duplicates (simple method: append new ones)
    cat << 'EOF' >> "$MATUGEN_DIR/config.toml"

[templates.gtk3]
input_path = "~/.config/matugen/templates/gtk-colors.css"
output_path = "~/.config/gtk-3.0/colors.css"
post_hook = "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'"

[templates.gtk4]
input_path = "~/.config/matugen/templates/gtk-colors.css"
output_path = "~/.config/gtk-4.0/colors.css"
EOF
    echo -e "${GREEN}✔ Matugen config updated to target colors.css.${RESET}"
else
    echo -e "${GREEN}✔ Matugen already correctly configured.${RESET}"
fi

# -----------------------------------------------------
# 7. APPLY GSETTINGS (For Immediate Effect)
# -----------------------------------------------------
echo -e "${BLUE}:: Applying GSettings...${RESET}"

gsettings set org.gnome.desktop.interface icon-theme 'BeautySolar'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface font-name 'Maple Mono NF 11'
gsettings set org.gnome.desktop.interface cursor-theme 'Future-cursors'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo -e "${GREEN}✔ DONE! GTK Import Strategy Applied.${RESET}"
