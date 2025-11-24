#!/usr/bin/env bash

# Directory to save recordings
DIR="$HOME/Videos/ScreenRecordings"
mkdir -p "$DIR"

# Filename with timestamp
FILE="$DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Check if wf-recorder is installed
if ! command -v wf-recorder >/dev/null 2>&1; then
    notify-send "Screen Recording" "wf-recorder is not installed. Please install it first."
    exit 1
fi

# Function to stop recording
stop_recording() {
    if [ -n "$RECORDER_PID" ]; then
        kill -INT "$RECORDER_PID"
        wait "$RECORDER_PID" 2>/dev/null
        RECORDER_PID=""
        
        # Wait a moment for file to be finalized
        sleep 1
        
        if [ -f "$FILE" ]; then
            # Copy to clipboard (the file path)
            echo -n "$FILE" | wl-copy
            
            # Show notification
            if command -v mako >/dev/null 2>&1; then
                notify-send -i "video-x-generic" "Recording saved" "$FILE"
            else
                notify-send "Recording saved" "$FILE"
            fi
        else
            notify-send "Recording failed" "Could not save recording file"
        fi
    fi
}

# Handle SIGINT (Ctrl+C) and SIGTERM
trap stop_recording SIGINT SIGTERM

# Check if recording is already in progress
if pgrep -x "wf-recorder" >/dev/null; then
    # Stop existing recording
    pkill -INT wf-recorder
    sleep 2
    notify-send "Screen Recording" "Stopped previous recording"
    exit 0
fi

# Start new recording based on selection
if [ "$1" == "area" ]; then
    # Select area to record
    SEL=$(slurp)
    if [ -z "$SEL" ]; then
        notify-send "Recording cancelled" "No area selected"
        exit 1
    fi
    wf-recorder -g "$SEL" -f "$FILE" &
elif [ "$1" == "audio" ]; then
    # Record with audio (requires pipewire)
    wf-recorder -a --audio=target -f "$FILE" &
elif [ "$1" == "full" ]; then
    # Record full screen with audio
    wf-recorder -a --audio=target -f "$FILE" &
else
    # Record full screen without audio
    wf-recorder -f "$FILE" &
fi

RECORDER_PID=$!

# Show start notification
notify-send "Screen Recording" "Recording started... Press Ctrl+C or run script again to stop"

# Wait for user to stop recording
echo "Recording... Press Ctrl+C to stop"
wait $RECORDER_PID
