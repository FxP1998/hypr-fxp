#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  FxP1998 REPOSITORY CHECKER
#  󰀻  File: check_repo_updates.sh
#  󰁔  Description: Background JSON provider for Waybar to track repo changes.
# -----------------------------------------------------------------------------

# Icons
I_REPO="󰊤"

# Configuration
REPO_ROOT="$HOME/FxP1998"

# Check if repo exists
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo '{"text": "", "alt": "", "tooltip": "Repo not found"}'
    exit 0
fi

cd "$REPO_ROOT" || exit 1

# Fetch remote state without merging
git fetch origin --quiet >/dev/null 2>&1

# Count how many commits we are behind
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ "$LOCAL" = "$REMOTE" ]; then
    # Up to date
    echo '{"text": "", "alt": "", "tooltip": "Rice is up to date"}'
elif [ "$LOCAL" = "$BASE" ]; then
    # Behind
    BEHIND_COUNT=$(git rev-list --count HEAD..origin/main 2>/dev/null || git rev-list --count HEAD..origin/master 2>/dev/null)
    
    # Waybar JSON Output
    COLOR="#acc7ff" # Accent color
    TOOLTIP="<b>$I_REPO FxP1998 Update Available</b>\n\n󰁔 Commits behind: $BEHIND_COUNT\n󰁔 Click to run Global Upgrade"
    
    echo "{\"text\": \"<span color='$COLOR'>$I_REPO</span>\", \"tooltip\": \"$TOOLTIP\"}"
else
    # Diverged or Ahead
    echo '{"text": "", "alt": "", "tooltip": "Repo state: Local changes detected"}'
fi
