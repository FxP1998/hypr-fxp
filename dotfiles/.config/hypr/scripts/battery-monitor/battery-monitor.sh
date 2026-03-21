#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  HYPRLAND CONFIGURATION
#  󰀻  File: battery-monitor.sh
#  󰁔  Description: Background service to monitor battery levels and charger status.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    # TTY SAFE MODE
    I_BAT="[BAT]"; I_OK="[OK]"; I_INFO="->"; I_WARN="[!]"; I_PLUG="[+]"; I_UNPLUG="[-]"
else
    # GUI CANDY MODE
    I_BAT="󰁹"; I_OK="󰄬"; I_INFO="󰁔"; I_WARN="󰀦"; I_PLUG="󱐥"; I_UNPLUG="󱐤"
fi

# --- Configuration ---
LOW_BATTERY=20
CRITICAL_BATTERY=10
FULL_BATTERY=95
CHECK_INTERVAL=2

# --- Dynamic Path Detection ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/assets"

LOW_SOUND="$ASSETS_DIR/battery_low.ogx"
CRITICAL_SOUND="$ASSETS_DIR/battery_low.ogx"
PLUG_SOUND="$ASSETS_DIR/battery_charger-plugin.ogx"
UNPLUG_SOUND="$ASSETS_DIR/battery_charger-plugout.ogx"

LAST_STATUS_FILE="/tmp/battery_last_status"
LOCK_FILE="/tmp/battery-monitor.lock"

# --- Multiple Instance Prevention ---
if [ -f "$LOCK_FILE" ]; then
    if ps -p $(cat "$LOCK_FILE") > /dev/null 2>&1; then
        echo -e "${C_YELLOW}${I_WARN} Battery monitor is already running.${C_RESET}"
        exit 1
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"

# --- Helper Functions ---
get_battery_info() {
    local bat_dir=""
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        bat_dir="/sys/class/power_supply/BAT0"
    elif [ -d "/sys/class/power_supply/BAT1" ]; then
        bat_dir="/sys/class/power_supply/BAT1"
    else
        return 1
    fi
    echo "$(cat "$bat_dir/capacity" 2>/dev/null) $(cat "$bat_dir/status" 2>/dev/null)"
}

send_notification() {
    local urgency="$1"
    local title="$2"
    local message="$3"
    local sound="$4"
    local icon="$5"

    notify-send -u "$urgency" -i "$icon" "$title" "$message"
    if [ -f "$sound" ]; then
        mpv --no-video --volume=100 "$sound" > /dev/null 2>&1 &
    fi
}

# --- Main Logic ---
handle_power_change() {
    local status="$1"
    local capacity="$2"
    local last="$3"

    case "$status" in
        "Charging")
            if [[ "$last" != "Charging" && "$last" != "Full" ]]; then
                send_notification "normal" "$I_PLUG  Power Connected" "Charger plugged in ($capacity%)" "$PLUG_SOUND" "battery-charging"
            fi
            ;;
        "Discharging")
            if [[ "$last" == "Charging" || "$last" == "Full" ]]; then
                send_notification "normal" "$I_UNPLUG  Power Disconnected" "Charger unplugged ($capacity%)" "$UNPLUG_SOUND" "battery-discharging"
            fi
            ;;
        "Full")
            if [[ "$last" != "Full" ]]; then
                send_notification "low" "󱈏  Battery Full" "Battery at 100%. Unplug charger." "$PLUG_SOUND" "battery-full"
            fi
            ;;
    esac
}

check_battery() {
    local info=$(get_battery_info)
    [ -z "$info" ] && return
    
    local capacity=$(echo "$info" | awk '{print $1}')
    local status=$(echo "$info" | awk '{print $2}')
    local last_status=$(cat "$LAST_STATUS_FILE" 2>/dev/null)

    # Detect power change
    if [ "$last_status" != "$status" ]; then
        handle_power_change "$status" "$capacity" "$last_status"
        echo "$status" > "$LAST_STATUS_FILE"
    fi

    # Low/Critical alerts
    if [[ "$status" != "Charging" && "$status" != "Full" ]]; then
        if [ "$capacity" -le "$CRITICAL_BATTERY" ]; then
            if [ ! -f "/tmp/bat_crit" ]; then
                send_notification "critical" "$I_WARN  CRITICAL BATTERY" "$capacity% remaining! Plug in NOW!" "$CRITICAL_SOUND" "battery-level-10-critical"
                touch "/tmp/bat_crit"
            fi
        elif [ "$capacity" -le "$LOW_BATTERY" ]; then
            if [ ! -f "/tmp/bat_low" ]; then
                send_notification "normal" "$I_BAT  Low Battery" "$capacity% remaining." "$LOW_SOUND" "battery-level-20"
                touch "/tmp/bat_low"
            fi
        fi
    fi

    # Reset alert flags
    [ "$capacity" -gt "$LOW_BATTERY" ] && rm -f "/tmp/bat_low" "/tmp/bat_crit"
    [[ "$status" == "Charging" || "$status" == "Full" ]] && rm -f "/tmp/bat_low" "/tmp/bat_crit"
}

cleanup() {
    rm -f "$LOCK_FILE" "$LAST_STATUS_FILE" "/tmp/bat_low" "/tmp/bat_crit"
    exit 0
}
trap cleanup EXIT INT TERM

# --- Start Monitoring ---
echo -e "${C_BLUE}${I_BAT}  Starting Battery Monitor service...${C_RESET}"
while true; do
    check_battery
    sleep $CHECK_INTERVAL
done
