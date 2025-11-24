#!/usr/bin/env bash
# 🖼️ Resize Wallpapers to 1920x1080 and Replace Originals

# Get the current directory
SRC_DIR=$(pwd)

# Check if there are any images in the directory
if ! find "$SRC_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | grep -q .; then
    echo "❌ No wallpapers found in the current directory ($SRC_DIR)"
    exit 1
fi

# Keep track of how many files were resized and skipped
resized_count=0
skipped_count=0

# Loop through each image in the directory (using a `for` loop instead of `while read`)
for img in "$SRC_DIR"/*.{jpg,png}; do
    # Ensure it's a valid file
    if [[ ! -f "$img" ]]; then
        continue
    fi

    # Get the original size
    original_size=$(identify -format "%wx%h" "$img")
    filename=$(basename "$img")

    # If it's already 1920x1080, skip it and increment the skipped count
    if [[ "$original_size" == "1920x1080" ]]; then
        echo "🔒 Skipping '$filename' (already 1920x1080)"
        skipped_count=$((skipped_count + 1))
        continue
    fi

    # Show the original size
    echo "🌄 Original size of '$filename': $original_size"

    # Resize the image and overwrite it
    magick convert "$img" -resize 1920x1080^ -gravity center -extent 1920x1080 "$img"

    # Get the new size
    new_size=$(identify -format "%wx%h" "$img")

    # Show the converted size
    echo "✅ Converted '$filename' to $new_size"

    resized_count=$((resized_count + 1))
done

# Send a notification at the end with the results
if ((resized_count > 0 || skipped_count > 0)); then
    notify-send -u low "🖼️ Wallpaper Resize Complete" \
        "$resized_count wallpapers resized. $skipped_count skipped (already 1920x1080)."
else
    notify-send -u low "🖼️ Wallpaper Resize Complete" "No wallpapers were resized."
fi

# Final message in the terminal
echo "✅ Resized $resized_count wallpapers, skipped $skipped_count already at 1920x1080."

