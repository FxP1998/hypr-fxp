#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  FxP1998 KEYBINDING CHEATSHEET
#  󰀻  File: keybinds.sh
#  󰁔  Description: Manual, hand-curated Rofi menu for system shortcuts.
# -----------------------------------------------------------------------------

# Configuration
# Using a specialized single-column theme for better readability
THEME_FILE="$HOME/.config/rofi/keybinds.rasi"

# --- MANUAL KEYBIND LIST ---
# Add or remove lines here as you wish!
# Format: "Icon + Key 	󰁔    Description"
LIST="󰘳 + Q       		󰁔    Kill Active Window
Ctrl + Alt + Del    	󰁔    Exit Hyprland
󰘳 + V             		󰁔    Toggle Floating Mode
󰘳 + P             		󰁔    Pin Window (Always on Top)
󰘳 + F             		󰁔    Fullscreen (Keep Gaps)
󰘳 + Shift + F      	󰁔    Fullscreen (No Gaps)
󰘳 + Space         	󰁔    Open Terminal (Kitty)
󰘳 + A             		󰁔    App Launcher (Rofi)
󰘳 + E             		󰁔    Open File Manager (Nautilus)
󰘳 + C             		󰁔    Open Code Editor (VS Code)
󰘳 + B             		󰁔    Open Web Browser (Firefox)
󰘳 + Shift + E     	󰁔    Terminal File Manager (Yazi)
󰘳 + Shift + Space  	󰁔    Quick Floating Terminal
󰘳 + Shift + M      	󰁔    Music Player (Kew)
󰘳 + N             		󰁔    Dismiss Current Notification
󰘳 + Shift + N      	󰁔    Restore Last Notification
󰘳 + Alt + N        	󰁔    Clear All Notifications
󰘳 + K             		󰁔    Pseudo Tiling Mode
󰘳 + J             		󰁔    Toggle Window Split
Alt + Shift + L     	󰁔    Lock Screen (Hyprlock)
󰘳 + Alt + L        	󰁔    Power Menu (wlogout)
󰘳 + Shift + P      	󰁔    Clipboard History (Cliphist)
󰘳 + /             		󰁔    Show this Help Menu
󰘳 + Shift + W      	󰁔    Wallpaper Selector
󰘳 + Shift + R      	󰁔    Reload Waybar
󰘳 + Shift + Print  	󰁔    Area Screenshot
󰘳 + Ctrl + Print   	󰁔    Full Screenshot
󰘳 + Ctrl+Shift+Pr  	󰁔    Area Screen Recording
󰘳 + Shift + T      	󰁔    Full Screen Recording
Volume Keys         	󰁔    Adjust/Mute Audio (SwayOSD)
Brightness Keys     	󰁔    Adjust Screen Light (SwayOSD)
Media Keys          	󰁔    Play/Pause/Next/Prev Track"

# Launch Rofi
echo -e "$LIST" | rofi -dmenu -i -theme "$THEME_FILE" -p "󰌌  System Shortcuts" -config "$HOME/.config/rofi/config.rasi"
