#!/bin/bash
status=$(playerctl status 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    # Pause Icon (Double Vertical Bar)
    echo "⏸" 
else
    # Play Icon (Triangle)
    echo "▶"
fi
