#!/usr/bin/env bash

# Kill all active waybar process
killall waybar 

# Sleep for 0.5 second
sleep 0.5

# Restart waybar 
waybar &
