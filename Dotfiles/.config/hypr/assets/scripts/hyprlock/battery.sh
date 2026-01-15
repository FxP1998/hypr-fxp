#!/bin/bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# -----------------------------------------------------------------------------
# 1. SOURCE COLORS FROM CONFIG
# -----------------------------------------------------------------------------
COLOR_CONF="$HOME/.config/hypr/modules/04-hypr-colors.conf"

get_color() {
    grep "\$$1 =" "$COLOR_CONF" | head -n 1 | sed -E 's/.*rgb\(([^)]+)\).*/#\1/'
}

C_CHARGING=$(get_color "on_tertiary")
C_LOW=$(get_color "error")
C_DEFAULT=$(get_color "on_tertiary")

[ -z "$C_CHARGING" ] && C_CHARGING="#99ccf9"
[ -z "$C_LOW" ] && C_LOW="#ffb4ab"
[ -z "$C_DEFAULT" ] && C_DEFAULT="#372a4a"

# -----------------------------------------------------------------------------
# 2. BATTERY LOGIC
# -----------------------------------------------------------------------------
BATTERY_DEVICE="BAT1"
ICON_CHARGING=""
ICON_DISCHARGING=""
ICON_LOW=""

if [ -d "/sys/class/power_supply/$BATTERY_DEVICE" ]; then
    STATUS=$(cat /sys/class/power_supply/$BATTERY_DEVICE/status)
    CAPACITY=$(cat /sys/class/power_supply/$BATTERY_DEVICE/capacity)

    if [[ "$STATUS" == "Charging" ]]; then
        echo "<span foreground='$C_CHARGING'>$ICON_CHARGING  $CAPACITY%  Charged</span>"
        
    elif [[ "$STATUS" == "Discharging" ]]; then
        if (( CAPACITY < 20 )); then            
             echo "<span foreground='$C_LOW'>$ICON_LOW   $CAPACITY% (Low)</span>"
        else
             echo "<span foreground='$C_DEFAULT'>$ICON_DISCHARGING   $CAPACITY%</span>"
        fi
        
    elif [[ "$STATUS" == "Full" ]]; then
        echo "<span foreground='$C_CHARGING'>$ICON_DISCHARGING   Full</span>"
    else
        echo "<span foreground='$C_DEFAULT'>$ICON_DISCHARGING   $CAPACITY%</span>"
    fi
else
    echo "<span foreground='$C_CHARGING'>AC Power</span>"
fi
