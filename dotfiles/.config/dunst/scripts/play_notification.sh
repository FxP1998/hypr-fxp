#!/usr/bin/env bash
# Official Notification Sound Helper
mpv --no-video --volume=100 "$HOME/.config/dunst/assets/new-notification.ogx" > /dev/null 2>&1 &
