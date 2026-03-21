#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: screenshot.sh
#  󰁔  Description: Screenshot utility using grim and slurp with clipboard sync.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE
    I_CAM="[CAM]"; I_OK="[OK]"; I_INFO="->"; I_FAIL="[!!]"
else
    # GUI CANDY MODE
    I_CAM="󰄀"; I_OK="󰄬"; I_INFO="󰁔"; I_FAIL="󰅖"
fi

# --- Configuration ---
SAVE_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILE="$SAVE_DIR/scr_$TIMESTAMP.png"

mkdir -p "$SAVE_DIR"

# --- Dependency Check ---
if ! command -v grim &>/dev/null; then
    notify-send -u critical "$I_FAIL Error" "grim is not installed."
    exit 1
fi

# --- Capture Logic ---
if [ "$1" == "area" ]; then
    if ! command -v slurp &>/dev/null; then
        notify-send -u critical "$I_FAIL Error" "slurp is not installed."
        exit 1
    fi
    SEL=$(slurp) || exit 1
    grim -g "$SEL" "$FILE"
else
    grim "$FILE"
fi

# --- Post-Capture ---
if [ -f "$FILE" ]; then
    # Sync to clipboard
    wl-copy < "$FILE"
    # Notify
    notify-send -i "$FILE" "$I_CAM Screenshot Captured" "Saved: scr_$TIMESTAMP.png\nCopied to clipboard."
else
    notify-send -u critical "$I_FAIL Error" "Capture failed."
fi
