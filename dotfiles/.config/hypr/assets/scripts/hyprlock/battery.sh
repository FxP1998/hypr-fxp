#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: battery.sh
#  󰁔  Description: Formats battery status with Pango markup for Hyprlock.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Configuration ---
COLOR_CONF="$HOME/.config/hypr/modules/04-hypr-colors.conf"
BATTERY_DEVICE="BAT1" # Standard laptop battery

# --- Helper: Extract colors from Hyprland config ---
get_color() {
    grep "\$$1 =" "$COLOR_CONF" | head -n 1 | sed -E 's/.*rgb\(([^)]+)\).*/#\1/'
}

# Source colors
C_ACCENT=$(get_color "tertiary")
C_TEXT=$(get_color "on_tertiary")
C_LOW=$(get_color "error")

# Fallbacks if colors fail
[ -z "$C_ACCENT" ] && C_ACCENT="#c0c4eb"
[ -z "$C_TEXT" ]   && C_TEXT="#292e4d"
[ -z "$C_LOW" ]    && C_LOW="#ffb4ab"

# --- Icons ---
I_CHARGING="󱐥"
I_DISCHARGING="󰁹"
I_LOW="󰂃"

# --- Logic ---
if [ -d "/sys/class/power_supply/$BATTERY_DEVICE" ]; then
    STATUS=$(cat /sys/class/power_supply/$BATTERY_DEVICE/status)
    CAPACITY=$(cat /sys/class/power_supply/$BATTERY_DEVICE/capacity)

    case "$STATUS" in
        "Charging")
            echo "<span foreground='$C_ACCENT'>$I_CHARGING  $CAPACITY% (Charging)</span>"
            ;;
        "Discharging")
            if [ "$CAPACITY" -le 20 ]; then
                echo "<span foreground='$C_LOW'>$I_LOW  $CAPACITY% (Critical)</span>"
            else
                echo "<span foreground='$C_TEXT'>$I_DISCHARGING  $CAPACITY%</span>"
            fi
            ;;
        "Full")
            echo "<span foreground='$C_ACCENT'>󰁹  Charged</span>"
            ;;
        *)
            echo "<span foreground='$C_TEXT'>$I_DISCHARGING  $CAPACITY%</span>"
            ;;
    esac
else
    echo "<span foreground='$C_ACCENT'>󰚥  AC Power</span>"
fi
