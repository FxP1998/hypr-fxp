#!/usr/bin/env bash

# Battery Monitor Script with Real-time Charging/Unplug Notifications

# Configuration
LOW_BATTERY=20
CRITICAL_BATTERY=10
FULL_BATTERY=95
CHECK_INTERVAL=1

# Sound files
LOW_SOUND="$HOME/.config/hypr-fxp/assets/sounds/battery_low.oga"
CRITICAL_SOUND="$HOME/.config/hypr-fxp/assets/sounds/battery_low.oga"
PLUG_SOUND="$HOME/.config/hypr-fxp/assets/sounds/battery_charger-plugin.oga"
UNPLUG_SOUND="$HOME/.config/hypr-fxp/assets/sounds/battery_charger-plugout.oga"

# State files
LAST_STATUS_FILE="/tmp/battery_last_status"
LOCK_FILE="/tmp/battery-monitor.lock"

# ========== MULTIPLE INSTANCE PREVENTION ==========
if [ -f "$LOCK_FILE" ]; then
    # Check if the process in lock file is still running
    if ps -p $(cat "$LOCK_FILE") > /dev/null 2>&1; then
        echo "Battery monitor is already running (PID: $(cat "$LOCK_FILE")). Exiting."
        exit 1
    else
        # Remove stale lock file
        rm -f "$LOCK_FILE"
    fi
fi

# Create lock file with current PID
echo $$ > "$LOCK_FILE"

# Function to get battery info
get_battery_info() {
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        battery_dir="/sys/class/power_supply/BAT0"
    elif [ -d "/sys/class/power_supply/BAT1" ]; then
        battery_dir="/sys/class/power_supply/BAT1"
    else
        return 1
    fi

    capacity=$(cat "$battery_dir/capacity" 2>/dev/null)
    status=$(cat "$battery_dir/status" 2>/dev/null)

    echo "$capacity $status"
}

# Function to send notification (silent MPV to avoid errors)
send_notification() {
    local urgency="$1"
    local title="$2"
    local message="$3"
    local sound="$4"

    notify-send -u "$urgency" -i "battery" "$title" "$message"

    if [ -n "$sound" ] && [ -f "$sound" ]; then
        # Suppress MPV errors and run in background
        mpv --really-quiet "$sound" 2>/dev/null &
    fi
}

# Function to handle power source changes
handle_power_change() {
    local current_status="$1"
    local current_capacity="$2"
    local last_status="$3"

    case "$current_status" in
        "Charging")
            if [ "$last_status" != "Charging" ] && [ "$last_status" != "Full" ]; then
                send_notification "normal" " Power Connected" "Charger plugged in. Battery: ${current_capacity}%" "$PLUG_SOUND"
            fi
            ;;
        "Discharging")
            if [ "$last_status" = "Charging" ] || [ "$last_status" = "Full" ]; then
                send_notification "normal" " Power Disconnected" "Charger unplugged. Battery: ${current_capacity}%" "$UNPLUG_SOUND"
            fi
            ;;
        "Full")
            if [ "$last_status" != "Full" ]; then
                send_notification "low" "󱈏 Battery Fully Charged" "Battery is at 100%. You can unplug the charger." "$PLUG_SOUND"
            fi
            ;;
    esac
}

# Function to check battery levels
check_battery_levels() {
    battery_info=$(get_battery_info)
    if [ $? -ne 0 ]; then
        echo "Error: Cannot read battery information"
        return 1
    fi

    capacity=$(echo "$battery_info" | awk '{print $1}')
    status=$(echo "$battery_info" | awk '{print $2}')

    # Read last status
    if [ -f "$LAST_STATUS_FILE" ]; then
        last_status=$(cat "$LAST_STATUS_FILE")
    else
        last_status=""
    fi

    # Check for power source changes
    if [ "$last_status" != "$status" ]; then
        handle_power_change "$status" "$capacity" "$last_status"
        echo "$status" > "$LAST_STATUS_FILE"
    fi

    # Critical battery level (plug in immediately!)
    if [ "$capacity" -le "$CRITICAL_BATTERY" ] && [ "$status" != "Charging" ]; then
        if [ ! -f "/tmp/battery_critical_sent" ] || [ $(find "/tmp/battery_critical_sent" -mmin +5 2>/dev/null) ]; then
            send_notification "critical" "󰂃 CRITICAL BATTERY!" "Battery at ${capacity}%! Plug in immediately!" "$CRITICAL_SOUND"
            touch "/tmp/battery_critical_sent"
        fi

    # Low battery warning
    elif [ "$capacity" -le "$LOW_BATTERY" ] && [ "$status" != "Charging" ]; then
        if [ ! -f "/tmp/battery_low_sent" ] || [ $(find "/tmp/battery_low_sent" -mmin +10 2>/dev/null) ]; then
            send_notification "normal" "󰁻 Low Battery" "Battery at ${capacity}%. Consider plugging in soon." "$LOW_SOUND"
            touch "/tmp/battery_low_sent"
        fi

    # Full battery (when charging)
    elif [ "$capacity" -ge "$FULL_BATTERY" ] && [ "$status" = "Charging" ]; then
        if [ ! -f "/tmp/battery_full_sent" ]; then
            send_notification "low" "󰂁 Battery Almost Full" "Battery at ${capacity}%. You can unplug the charger."
            touch "/tmp/battery_full_sent"
        fi

    # Charging started from low level
    elif [ "$capacity" -le "$LOW_BATTERY" ] && [ "$status" = "Charging" ]; then
        if [ ! -f "/tmp/charging_started_sent" ]; then
            send_notification "low" "⚡ Charging Started" "Battery at ${capacity}%. Now charging..." "$PLUG_SOUND"
            touch "/tmp/charging_started_sent"
        fi

    # Battery fully charged
    elif [ "$capacity" -eq 100 ] && [ "$status" = "Full" ]; then
        if [ ! -f "/tmp/battery_100_sent" ]; then
            send_notification "low" "󱈏 Battery Fully Charged" "Battery is fully charged. You can unplug the charger." "$PLUG_SOUND"
            touch "/tmp/battery_100_sent"
        fi

    # Reset flags when conditions change
    else
        # Reset low battery flag when above threshold
        if [ "$capacity" -gt "$LOW_BATTERY" ] && [ -f "/tmp/battery_low_sent" ]; then
            rm -f "/tmp/battery_low_sent"
        fi
        # Reset critical battery flag when above threshold
        if [ "$capacity" -gt "$CRITICAL_BATTERY" ] && [ -f "/tmp/battery_critical_sent" ]; then
            rm -f "/tmp/battery_critical_sent"
        fi
        # Reset charging flag when discharging
        if [ "$status" = "Discharging" ] && [ -f "/tmp/charging_started_sent" ]; then
            rm -f "/tmp/charging_started_sent"
        fi
        # Reset full flags when discharging
        if [ "$status" = "Discharging" ]; then
            rm -f "/tmp/battery_full_sent" "/tmp/battery_100_sent"
        fi
    fi
}

# Cleanup function
cleanup() {
    echo "Cleaning up battery monitor..."
    # Remove lock file
    rm -f "$LOCK_FILE"
    # Remove state files
    rm -f "$LAST_STATUS_FILE"
    # Kill any child processes (MPV sounds)
    pkill -P $$ 2>/dev/null
    exit 0
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Main execution
echo "Starting battery monitor (PID: $$)..."

# Initial setup
battery_info=$(get_battery_info)
if [ $? -eq 0 ]; then
    initial_status=$(echo "$battery_info" | awk '{print $2}')
    echo "$initial_status" > "$LAST_STATUS_FILE"
    echo "Initial battery status: $initial_status"
else
    echo "Error: Cannot read battery information on startup"
    cleanup
    exit 1
fi

# Main monitoring loop
echo "Entering main monitoring loop..."
while true; do
    check_battery_levels
    sleep $CHECK_INTERVAL
done
