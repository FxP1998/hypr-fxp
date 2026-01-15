#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998
# DESCRIPTION: Installs Yazi + Dependencies + Plugins + Perfect Configs

GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RESET="\033[0m"
YAZI_DIR="$HOME/.config/yazi"

echo -e "${BLUE}▶ STARTING YAZI SETUP (By FxP)...${RESET}"

# 1. INSTALL PACKAGES
echo -e "${BLUE}:: Installing System Packages & Dependencies...${RESET}"
PACKAGES="yazi neovim ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick \
mpv vlc eog libreoffice-still okular zathura firefox wl-clipboard ttf-jetbrains-mono-nerd"

if command -v yay &> /dev/null; then
    yay -S --needed --noconfirm $PACKAGES
elif command -v pacman &> /dev/null; then
    sudo pacman -S --needed --noconfirm $PACKAGES
else
    echo "Error: Package manager not found. Install manually."
    exit 1
fi

# 2. SETUP YAZI CONFIG
echo -e "${BLUE}:: Setting up Yazi configuration...${RESET}"
# Backup existing config
if [ -d "$YAZI_DIR" ]; then
    echo -e "${YELLOW}   Backing up existing config to $YAZI_DIR.backup...${RESET}"
    mv "$YAZI_DIR" "$YAZI_DIR.backup.$(date +%s)"
fi
mkdir -p "$YAZI_DIR/plugins"

# --- PLUGINS ---
echo -e "${BLUE}:: Downloading Plugins...${RESET}"
git clone --depth 1 https://github.com/yazi-rs/plugins.git "/tmp/yazi-plugins" &> /dev/null
cp -r "/tmp/yazi-plugins/full-border.yazi" "$YAZI_DIR/plugins/"
cp -r "/tmp/yazi-plugins/smart-enter.yazi" "$YAZI_DIR/plugins/"
rm -rf "/tmp/yazi-plugins"

# --- INIT.LUA ---
cat << 'EOF' > "$YAZI_DIR/init.lua"
require("full-border"):setup { type = ui.Border.ROUNDED }
require("smart-enter"):setup { open_multi = true }
EOF

# --- YAZI.TOML (Main Config) ---
# Updated [mgr] -> [manager] for compatibility
cat << 'EOF' > "$YAZI_DIR/yazi.toml"
"$schema" = "https://yazi-rs.github.io/schemas/yazi.json"

[manager]
ratio = [ 2, 3, 3 ]
show_hidden = true
show_symlink = true
scrolloff = 5
sort_by = "alphabetical"
title_format = "Yazi: {cwd}"

[opener]
edit = [ { run = '${EDITOR:-nvim} "$@"', desc = "$EDITOR", block = true, for = "unix" } ]
nvim = [ { run = 'nvim "$@"', desc = "NeoVim", block = true, for = "unix" } ]
open = [ { run = 'xdg-open "$1"', desc = "Open", for = "linux" } ]
reveal = [ { run = 'xdg-open "$(dirname "$1")"', desc = "Reveal", for = "linux" } ]
extract = [ { run = 'ya pub extract --list "$@"', desc = "Extract", for = "unix" } ]
libreoffice = [ { run = 'libreoffice "$@"', orphan = true, desc = "LibreOffice", for = "unix" } ]
okular = [ { run = 'okular "$@"', orphan = true, desc = "Okular", for = "unix" } ]
zathura = [ { run = 'zathura "$@"', orphan = true, desc = "Zathura", for = "unix" } ]
eog = [ { run = 'eog "$@"', orphan = true, desc = "Eye of GNOME", for = "unix" } ]
play = [ { run = 'mpv --force-window "$@"', orphan = true, desc = "MPV", for = "unix" } ]

[open]
rules = [
	{ name = "*/", use = [ "edit", "open", "reveal" ] },
    { mime = "inode/empty", use = [ "edit", "nvim", "reveal" ] },
    
    # Code -> NeoVim
    { name = "*.lua",  use = [ "edit", "nvim" ] },
    { name = "*.sh",   use = [ "edit", "nvim" ] },
    { name = "*.toml", use = [ "edit", "nvim" ] },
    { name = "*.conf", use = [ "edit", "nvim" ] },
    { name = "*.css",  use = [ "edit", "nvim" ] },
    { name = "*.js",   use = [ "edit", "nvim" ] },
    { name = "*.py",   use = [ "edit", "nvim" ] },
    { name = "*.md",   use = [ "edit", "nvim" ] },
    { name = "*.rs",   use = [ "edit", "nvim" ] },
    { name = "*.c",    use = [ "edit", "nvim" ] },
    { name = "*.cpp",  use = [ "edit", "nvim" ] },

    # Media & Docs
	{ mime = "image/*", use = [ "eog", "open" ] },
	{ mime = "application/pdf", use = [ "okular", "zathura", "open" ] },
	{ mime = "audio/*", use = [ "play", "open" ] },
	{ mime = "video/*", use = [ "play", "open" ] },
    { name = "*.docx", use = [ "libreoffice", "open" ] },
    { name = "*.xlsx", use = [ "libreoffice", "open" ] },
    
    # Archives
    { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", use = [ "extract", "reveal" ] },

	{ mime = "text/*", use = [ "edit", "nvim" ] },
	{ name = "*", use = [ "open", "edit" ] },
]
EOF

# --- KEYMAP.TOML (The Final Version) ---
cat << 'EOF' > "$YAZI_DIR/keymap.toml"
"$schema" = "https://yazi-rs.github.io/schemas/keymap.json"

[manager]
keymap = [
    # --- HELP & QUIT ---
    { on = "<F1>", run = "help", desc = "Help" },
    { on = "~",    run = "help", desc = "Help" },
    { on = "<Esc>", run = "escape",              desc = "Cancel" },
    { on = "q",     run = "quit",                desc = "Quit" },
    { on = "Q",     run = "quit --no-cwd-file",  desc = "Quit (no cwd)" },
    { on = "<C-c>", run = "close",               desc = "Close Tab/Quit" },

    # --- NAVIGATION ---
    { on = "k", run = "arrow -1", desc = "Up" },
    { on = "j", run = "arrow 1",  desc = "Down" },
    { on = "h", run = "leave",    desc = "Parent" },
    { on = "l", run = "open",     desc = "Enter/Open" },

    { on = "<Up>",    run = "arrow -1", desc = "Up" },
    { on = "<Down>",  run = "arrow 1",  desc = "Down" },
    { on = "<Left>",  run = "leave",    desc = "Parent" },
    { on = "<Right>", run = "open",     desc = "Enter/Open" },
    { on = "<Enter>", run = "open",     desc = "Enter/Open" },
    { on = "O",       run = "open --interactive", desc = "Open With..." },

    # --- FILE OPS ---
    { on = "a", run = "create",                   desc = "Create" },
    { on = "r", run = "rename --cursor=before_ext", desc = "Rename" },
    { on = "d", run = "remove",                   desc = "Trash" },
    { on = "D", run = "remove --permanently",     desc = "Delete Forever" },
    
    # --- COPY PATHS (Hyprland/Wayland) ---
    { on = ["c", "c"], run = "shell 'echo -n \"$@\" | wl-copy' --confirm", desc = "Copy Full Path" },
    { on = ["c", "n"], run = "shell 'basename -a \"$@\" | wl-copy' --confirm", desc = "Copy Name" },
    { on = ["c", "d"], run = "shell 'dirname \"$@\" | wl-copy' --confirm", desc = "Copy Directory Path" },

    # --- CLIPBOARD (Files) ---
    { on = "y", run = "yank",        desc = "Copy File" },
    { on = "x", run = "yank --cut",  desc = "Cut File" },
    { on = "p", run = "paste",       desc = "Paste" },
    { on = "P", run = "paste --force", desc = "Paste (Overwrite)" },

    # --- SELECTION ---
    { on = "<Space>", run = ["toggle", "arrow 1"], desc = "Select" },
    { on = "<C-a>",   run = "toggle_all --state=on", desc = "Select All" },
    { on = "v",       run = "visual_mode",           desc = "Visual Mode" },

    # --- TABS ---
    { on = "t", run = "tab_create --current", desc = "New Tab" },
    { on = "1", run = "tab_switch 0", desc = "Tab 1" },
    { on = "2", run = "tab_switch 1", desc = "Tab 2" },
    { on = "3", run = "tab_switch 2", desc = "Tab 3" },
    { on = "4", run = "tab_switch 3", desc = "Tab 4" },
    { on = "5", run = "tab_switch 4", desc = "Tab 5" },
    { on = "[", run = "tab_switch -1 --relative", desc = "Prev Tab" },
    { on = "]", run = "tab_switch 1 --relative",  desc = "Next Tab" },
    
    # --- UTILS ---
    { on = ".", run = "hidden toggle", desc = "Hidden Files" },
    { on = "/", run = "find --smart",  desc = "Find" },
    { on = "s", run = "shell --interactive", desc = "Shell" },
]

[input]
keymap = [
    { on = "<C-a>", run = "move -999", desc = "Move to BOL" },
    { on = "<C-e>", run = "move 999",  desc = "Move to EOL" },
    { on = "<Backspace>", run = "backspace", desc = "Backspace" },
]
EOF

# --- THEME.TOML ---
cat << 'EOF' > "$YAZI_DIR/theme.toml"
[manager]
border_symbol = "│"
cwd = { fg = "#7aa2f7" }
[status]
separator_open = "🭁"
separator_close = "🭠"
[mode]
normal_main = { bg = "#7aa2f7", fg = "#15161e", bold = true }
[filetype]
rules = [ { name = "*", fg = "#c0caf5" } ]
EOF

# 3. SHELL INTEGRATION (The 'y' function)
echo -e "${BLUE}:: Configuring Shell Integration (CD on Exit)...${RESET}"

SHELL_FUNC='
# --- Yazi CD on Exit ---
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
'

# Append to .zshrc if exists and not already there
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "yazi-cwd" "$HOME/.zshrc"; then
        echo "$SHELL_FUNC" >> "$HOME/.zshrc"
        echo -e "${GREEN}   -> Added 'y' function to ~/.zshrc${RESET}"
    else
        echo -e "${YELLOW}   -> 'y' function already in ~/.zshrc${RESET}"
    fi
fi

# Append to .bashrc if exists
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "yazi-cwd" "$HOME/.bashrc"; then
        echo "$SHELL_FUNC" >> "$HOME/.bashrc"
        echo -e "${GREEN}   -> Added 'y' function to ~/.bashrc${RESET}"
    fi
fi

echo -e "\n${GREEN}✔ YAZI INSTALLED SUCCESSFULLY!${RESET}"
echo -e "restart your terminal and type 'y' to start yazi."
