#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: album_art.sh
#  󰁔  Description: Fetches and saves current media album art for Hyprlock.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Configuration ---
ART_PATH="/tmp/album_art.png"

# --- Logic ---
# Get the art URL from playerctl
URL=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -n "$URL" ]]; then
    # Handle local files (mpd/vlc)
    if [[ "$URL" == file://* ]]; then
        cp "${URL#file://}" "$ART_PATH"
    # Handle web URLs (Spotify)
    elif [[ "$URL" == http* ]]; then
        curl -s -o "$ART_PATH" "$URL"
    fi
else
    # Cleanup if nothing is playing to allow fallback icons
    rm -f "$ART_PATH" 2>/dev/null
fi
