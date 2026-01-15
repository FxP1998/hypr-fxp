#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

DIR="$HOME/Videos/ScreenRecordings"
mkdir -p "$DIR"
FILE="$DIR/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Check Deps
if ! command -v wf-recorder &>/dev/null; then
    notify-send "Error" "wf-recorder not installed."
    exit 1
fi

stop_recording() {
    if [ -n "$PID" ]; then
        kill -INT "$PID" 2>/dev/null
        wait "$PID" 2>/dev/null
        sleep 1
        if [ -f "$FILE" ]; then
            echo -n "$FILE" | wl-copy
            notify-send -i "video-x-generic" "Recording Saved" "$FILE"
        else
            notify-send "Error" "Recording Failed."
        fi
    fi
}
trap stop_recording SIGINT SIGTERM

# Toggle Logic
if pgrep -x "wf-recorder" >/dev/null; then
    pkill -INT wf-recorder
    notify-send "Recording Stopped" "Previous recording saved."
    exit 0
fi

# Start Recording
case "$1" in
    "area")
        SEL=$(slurp) || exit 1
        wf-recorder -g "$SEL" -f "$FILE" & ;;
    "audio")
        wf-recorder -a -f "$FILE" & ;;
    "full")
        wf-recorder -a -f "$FILE" & ;;
    *)
        wf-recorder -f "$FILE" & ;;
esac

PID=$!
notify-send "Recording Started" "Press script key again to stop."
wait $PID
