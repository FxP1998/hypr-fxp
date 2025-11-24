#!/usr/bin/env bash

# =============================================
# WAYBAR UPDATE CHECK SCRIPT FOR ARCH LINUX
# =============================================
# This script checks for both official Arch repos
# and AUR package updates
#
# DEPENDENCIES:
# - pacman-contrib (for 'checkupdates' command)
# - yay OR paru (AUR helper)
# =============================================

# Check official Arch repository packages
# 'checkupdates' shows pending updates without requiring root
# '2>/dev/null' hides any error messages
# 'wc -l' counts the number of lines (packages)
OFFICIAL_COUNT=$(checkupdates 2>/dev/null | wc -l)

# Check AUR packages using available AUR helpers
# Try yay first, if not available try paru, if neither work default to 0
# '-Qua' shows only AUR updates
AUR_COUNT=$(yay -Qua 2>/dev/null | wc -l 2>/dev/null || paru -Qua 2>/dev/null | wc -l 2>/dev/null || echo "0")

# Calculate total updates
TOTAL=$((OFFICIAL_COUNT + AUR_COUNT))

# If no updates available, return empty JSON (module will be hidden in Waybar)
if [ "$TOTAL" -eq 0 ]; then
    echo '{"text": ""}'  # Empty text = hidden
    exit 0
fi

# =============================================
# COLOR CODING BASED ON UPDATE COUNT
# =============================================
# >20 updates: Red (#eb6f92) - Urgent attention
# 11-20 updates: Gold (#f6c177) - Medium priority  
# 1-10 updates: Blue (#9ccfd8) - Low priority
# =============================================
if [ "$TOTAL" -gt 20 ]; then
    COLOR="#eb6f92"  # Red - many updates available
elif [ "$TOTAL" -gt 10 ]; then
    COLOR="#f6c177"  # Gold - several updates available
else
    COLOR="#9ccfd8"  # Foam/Blue - few updates available
fi

# =============================================
# OUTPUT FORMAT FOR WAYBAR
# =============================================
# Waybar expects JSON format with these fields:
# - "text": What's displayed in the bar (with color formatting)
# - "alt": Alternate text
# - "tooltip": Hover tooltip text
# The icon 󰚰 is a package icon from Nerd Fonts
# =============================================
echo "{\"text\": \"<span foreground='$COLOR'> $TOTAL 󰚰 </span>\", \"alt\": \"$TOTAL\", \"tooltip\": \" $TOTAL 󰚰  Updates Available \"}"
