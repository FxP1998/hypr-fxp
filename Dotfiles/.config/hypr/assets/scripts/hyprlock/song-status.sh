#!/usr/bin/env bash
# Check if media is playing
if playerctl status >/dev/null 2>&1; then
  # Print song info
  playerctl metadata --format "{{title}}  {{artist}}" | cut -c 1-35
else
  # If nothing is playing
  echo "No media playing"
fi
