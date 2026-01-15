#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998
# ---------------------------------------------------------------------------

# Function to handle the copying safely
copy_item() {
    src="$1"
    dest="$2"

    # Only proceed if the source exists
    if [ -e "$src" ]; then
        # Create destination folder if it doesn't exist
        mkdir -p "$(dirname "$dest")" > /dev/null 2>&1
        
        # Copy recursively (-r) and force (-f), sending all output to void
        cp -rf "$src" "$dest" > /dev/null 2>&1
    fi
}

# ===========================================================================
#                            ADD YOUR FILES BELOW
# ===========================================================================
# Usage: copy_item "SOURCE_PATH" "DESTINATION_PATH"

# copy the matugen config file
copy_item "$HOME/.config/hypr/config/matugen/config.toml" "$HOME/.config/matugen/config.toml"
