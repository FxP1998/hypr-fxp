#!/usr/bin/env bash

# Define where the art will be saved
ART_PATH="/tmp/album_art.png"

# Get the art URL from playerctl
URL=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -n "$URL" ]]; then
    # If it's a local file (common with mpd/vlc)
    if [[ "$URL" == file://* ]]; then
        cp "${URL#file://}" "$ART_PATH"

    # If it's a web URL (common with Spotify)
    elif [[ "$URL" == http* ]]; then
        curl -s -o "$ART_PATH" "$URL"
    fi
else
    # No music playing? Remove the file so the fallback icon shows
    rm "$ART_PATH" 2>/dev/null
fi
