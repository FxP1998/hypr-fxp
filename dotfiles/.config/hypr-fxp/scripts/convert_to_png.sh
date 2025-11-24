#!/bin/bash
# PNG Converter Pro - NERDified Edition

# ┌──────────────────────────────────────────────────────────┐
# │                      NERD Icon Set                       │
# ├──────────────────────────────────────────────────────────┤
# │                                   │
# └──────────────────────────────────────────────────────────┘

# ─── Functions ──────────────────────────────────────────────
nerd_notify() {
  local icon="$1" msg="$2" urgency="$3"
  if command -v notify-send &>/dev/null; then
    notify-send -i "$icon" "PNG Converter" "$msg" -u "$urgency"
  fi
  echo -e "$icon $msg"
}

color_echo() {
  local color="$1" msg="$2"
  case "$color" in
    red)    echo -e "\033[31m$msg\033[0m" ;;
    green)  echo -e "\033[32m$msg\033[0m" ;;
    yellow) echo -e "\033[33m$msg\033[0m" ;;
    blue)   echo -e "\033[34m$msg\033[0m" ;;
    *)      echo -e "$msg" ;;
  esac
}

# ─── Pre-Flight Checks ──────────────────────────────────────
if ! command -v magick &>/dev/null; then
  nerd_notify "" " ImageMagick not found! Run: sudo apt install imagemagick" "critical"
  exit 1
fi

# ─── Target Directory ───────────────────────────────────────
TARGET_DIR="${1:-.}"
if ! cd "$TARGET_DIR" 2>/dev/null; then
  nerd_notify "" " Directory not found: $TARGET_DIR" "critical"
  exit 1
fi

# ─── File Detection ─────────────────────────────────────────
files=()
for ext in jpg JPG jpeg JPEG; do
  for f in *."$ext"; do
    [[ -e "$f" ]] && files+=("$f")
  done
done
total=${#files[@]}

if (( total == 0 )); then
  nerd_notify "" " No JPEG files found in: $(pwd)" "normal"
  exit 0
fi

# ─── Conversion Header ──────────────────────────────────────
color_echo "blue" " NERD PNG Converter  → "
color_echo "yellow" " Target: $(pwd)"
color_echo "green" " Found $total files to convert:"

printf "  %s\n" "${files[@]}" | column
echo "──────────────────────────────────────────────"

# ─── Conversion Process ─────────────────────────────────────
nerd_notify "" " Starting batch conversion..." "low"

success=0
start=$SECONDS

for file in "${files[@]}"; do
  output="${file%.*}.png"
  echo " Converting: '$file' → '$output'"
  
  if magick "$file" "$output" &>/dev/null; then
    rm -f "$file"
    ((success++))
    color_echo "green" " Converted: $file → "
  else
    color_echo "red" " Failed: $file"
  fi
done

# ─── Results ────────────────────────────────────────────────
duration=$(( SECONDS - start ))
rate=$(( success * 100 / total ))

nerd_notify "" " Conversion Complete (${duration}s)" "normal"

color_echo "blue" "──────────────────────────────────────────────"
color_echo "green" " Success: $success/$total ($rate%)"
color_echo "yellow" " Time: $duration seconds"
color_echo "blue" " Output: $(pwd)"
color_echo "blue" "──────────────────────────────────────────────"

if (( success == total )); then
  nerd_notify "" " All files converted successfully!" "low"
else
  nerd_notify "" " Some files failed conversion!" "normal"
fi

