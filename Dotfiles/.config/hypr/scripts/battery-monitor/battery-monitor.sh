#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Configuration ---
LOW_BATTERY=20
CRITICAL_BATTERY=10
FULL_BATTERY=95
CHECK_INTERVAL=1

# --- Paths ---
BASE_DIR="$HOME/.config/FxP-Hyprland/Scripts/shared-scripts/battery-monitor/assets"
LOW_SOUND="$BASE_DIR/battery_low.ogx"
CRITICAL_SOUND="$BASE_DIR/battery_low.ogx"
PLUG_SOUND="$BASE_DIR/battery_charger-plugin.ogx"
UNPLUG_SOUND="$BASE_DIR/battery_charger-plugout.ogx"

LAST_STATUS_FILE="/tmp/battery_last_status"
LOCK_FILE="/tmp/battery-monitor.lock"

# --- Prevention of Multiple Instances ---
if [ -f "$LOCK_FILE" ]; then
    if ps -p $(cat "$LOCK_FILE") > /dev/null 2>&1; then
        exit 1
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"

# --- Helper Functions ---
get_battery_info() {
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        BAT_DIR="/sys/class/power_supply/BAT0"
    elif [ -d "/sys/class/power_supply/BAT1" ]; then
        BAT_DIR="/sys/class/power_supply/BAT1"
    else
        return 1
    fi
    echo "$(cat "$BAT_DIR/capacity" 2>/dev/null) $(cat "$BAT_DIR/status" 2>/dev/null)"
}

send_notification() {
    local urgency="$1"
    local title="$2"
    local message="$3"
    local sound="$4"

    notify-send -u "$urgency" -i "battery" "$title" "$message"
    [ -n "$sound" ] && [ -f "$sound" ] && mpv --really-quiet "$sound" 2>/dev/null &
}

# --- Main Logic ---
handle_power_change() {
    local status="$1"
    local capacity="$2"
    local last="$3"

    case "$status" in
        "Charging")
            [ "$last" != "Charging" ] && [ "$last" != "Full" ] && \
            send_notification "normal" "  Power Connected" "Charger plugged in ($capacity%)" "$PLUG_SOUND"
            ;;
        "Discharging")
            ([ "$last" = "Charging" ] || [ "$last" = "Full" ]) && \
            send_notification "normal" "  Power Disconnected" "Charger unplugged ($capacity%)" "$UNPLUG_SOUND"
            ;;
        "Full")
            [ "$last" != "Full" ] && \
            send_notification "low" "󱈏  Battery Full" "Battery at 100%. Unplug charger." "$PLUG_SOUND"
            ;;
    esac
}

check_battery() {
    read -r capacity status <<< "$(get_battery_info)"
    [ -z "$status" ] && return

    last_status=$(cat "$LAST_STATUS_FILE" 2>/dev/null)

    if [ "$last_status" != "$status" ]; then
        handle_power_change "$status" "$capacity" "$last_status"
        echo "$status" > "$LAST_STATUS_FILE"
    fi

    # Alerts logic
    if [ "$capacity" -le "$CRITICAL_BATTERY" ] && [ "$status" != "Charging" ]; then
        if [ ! -f "/tmp/bat_crit" ]; then
            send_notification "critical" "󰂃 CRITICAL BATTERY" "$capacity% remaining! Plug in NOW!" "$CRITICAL_SOUND"
            touch "/tmp/bat_crit"
        fi
    elif [ "$capacity" -le "$LOW_BATTERY" ] && [ "$status" != "Charging" ]; then
        if [ ! -f "/tmp/bat_low" ]; then
            send_notification "normal" "󰁻 Low Battery" "$capacity% remaining." "$LOW_SOUND"
            touch "/tmp/bat_low"
        fi
    else
        # Reset flags if safe
        [ "$capacity" -gt "$LOW_BATTERY" ] && rm -f "/tmp/bat_low" "/tmp/bat_crit"
    fi
}

cleanup() {
    rm -f "$LOCK_FILE" "$LAST_STATUS_FILE"
    pkill -P $$ 2>/dev/null
    exit 0
}
trap cleanup EXIT INT TERM

# Start Loop
echo "Monitoring Battery..."
while true; do
    check_battery
    sleep $CHECK_INTERVAL
done
