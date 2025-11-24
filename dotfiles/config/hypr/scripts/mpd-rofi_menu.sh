#!/usr/bin/env bash
# Hyprland-focused music menu

MENU=$(echo -e "▶ Play/Pause\n⏭ Next\n⏮ Previous\n⏹ Stop\n🔀 Shuffle\n🔄 Update Library\n🎵 ncmpcpp\n📊 Visualizer\n🔊 Volume +10%\n🔉 Volume -10%" | rofi -dmenu -p "🎶" -theme-str 'window {width: 20%;}')

case "$MENU" in
    "▶ Play/Pause") mpc toggle ;;
    "⏭ Next") mpc next ;;
    "⏮ Previous") mpc prev ;;
    "⏹ Stop") mpc stop ;;
    "🔀 Shuffle") mpc shuffle ;;
    "🔄 Update Library") mpc update ;;
    "🎵 ncmpcpp") kitty --class=musicplayer -e ncmpcpp ;;
    "📊 Visualizer") kitty --class=visualizer -e ncmpcpp -s visualizer ;;
    "🔊 Volume +10%") mpc volume +10 ;;
    "🔉 Volume -10%") mpc volume -10 ;;
esac
