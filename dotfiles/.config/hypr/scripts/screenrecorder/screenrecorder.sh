#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: screenrecorder.sh
#  󰁔  Description: Screen recording utility using wf-recorder with area selection.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE
    I_REC="[REC]"; I_OK="[OK]"; I_INFO="->"; I_FAIL="[!!]"
else
    # GUI CANDY MODE
    I_REC="󰑊"; I_OK="󰄬"; I_INFO="󰁔"; I_FAIL="󰅖"
fi

# --- Configuration ---
SAVE_DIR="$HOME/Videos/ScreenRecordings"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILE="$SAVE_DIR/rec_$TIMESTAMP.mp4"

mkdir -p "$SAVE_DIR"

# --- Dependency Check ---
if ! command -v wf-recorder &>/dev/null; then
    notify-send -u critical "$I_FAIL Error" "wf-recorder is not installed."
    exit 1
fi

# --- Toggle Logic ---
if pgrep -x "wf-recorder" >/dev/null; then
    pkill -INT wf-recorder
    notify-send -i "video-x-generic" "$I_REC Recording Stopped" "File saved to $SAVE_DIR"
    exit 0
fi

# --- Start Recording ---
case "$1" in
    "area")
        SEL=$(slurp) || exit 1
        wf-recorder -g "$SEL" -f "$FILE" & ;;
    "audio")
        wf-recorder -a -f "$FILE" & ;;
    "full")
        wf-recorder -a -f "$FILE" & ;;
    *)
        wf-recorder -f "$FILE" & ;;
esac

# Give feedback
if [ $? -eq 0 ]; then
    notify-send -i "video-x-generic" "$I_REC Recording Started" "Press shortcut again to stop.\nFile: rec_$TIMESTAMP.mp4"
    # Copy filename to clipboard for quick access
    echo -n "$FILE" | wl-copy
else
    notify-send -u critical "$I_FAIL Error" "Failed to start recording."
fi
