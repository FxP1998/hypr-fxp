#!/bin/bash

# ==============================================
# DRY RUN DOTFILES INSTALLER
# ==============================================

# Symbols
CHECK="[OK]"
CROSS="[FAIL]"
WARN="[WARN]"
INFO="[INFO]"
ARROW="==>"
DRY="[DRY RUN]"

# Paths
DOTFILES_SOURCE="$HOME/hypr-fxp_dotfiles/dotfiles"
HOME_TARGET="$HOME"
CONFIG_TARGET="$HOME/.config"
BACKUP_DIR="$HOME/user_configs_backup_DRYRUN"

# Arrays
FILES_TO_COPY=()
FILES_TO_SKIP=()
WOULD_BACKUP=()
WOULD_COPY=()
WOULD_SKIP=()

# ==============================================
# HELPER FUNCTIONS
# ==============================================

print_header() {
  echo ""
  echo "=========================================="
  echo "  $1"
  echo "=========================================="
}

check_exists() {
  [[ -e "$1" ]] && return 0 || return 1
}

files_differ() {
  if check_exists "$1" && check_exists "$2"; then
    if cmp -s "$1" "$2" 2>/dev/null; then
      return 1
    else
      return 0
    fi
  else
    return 0
  fi
}

# Simulated actions
dry_copy() {
  local src="$1"
  local dst="$2"
  echo "$DRY Would copy: $src"
  echo "       to: $dst"
}

dry_backup() {
  local src="$1"
  local dst="$2"
  echo "$DRY Would backup: $src"
  echo "         to: $dst"
}

dry_remove() {
  local file="$1"
  echo "$DRY Would remove: $file"
}

# ==============================================
# STEP 1: CHECK SOURCE
# ==============================================

check_source() {
  print_header "STEP 1: CHECKING SOURCE"

  if ! check_exists "$DOTFILES_SOURCE"; then
    echo "$CROSS Source not found: $DOTFILES_SOURCE"
    exit 1
  fi

  echo "$CHECK Source exists: $DOTFILES_SOURCE"

  # Show what's in source
  echo "$ARROW Home dotfiles in source:"
  for file in "$DOTFILES_SOURCE"/.*; do
    if [[ -f "$file" ]]; then
      echo "  - $(basename "$file")"
    fi
  done

  echo ""
  echo "$ARRAY Config directories in source:"
  if check_exists "$DOTFILES_SOURCE/.config"; then
    find "$DOTFILES_SOURCE/.config" -type f 2>/dev/null | head -10 | while read -r file; do
      echo "  - ${file#$DOTFILES_SOURCE/.config/}"
    done

    local total=$(find "$DOTFILES_SOURCE/.config" -type f 2>/dev/null | wc -l)
    if [[ $total -gt 10 ]]; then
      echo "  ... and $((total - 10)) more files"
    fi
  else
    echo "  No .config directory found"
  fi
}

# ==============================================
# STEP 2: COMPARE FILES
# ==============================================

compare_files() {
  print_header "STEP 2: COMPARING FILES"

  echo "$ARRAY Comparing home directory files..."
  local home_new=0
  local home_update=0
  local home_same=0

  for source_file in "$DOTFILES_SOURCE"/.*; do
    if [[ -f "$source_file" ]]; then
      local filename=$(basename "$source_file")
      local target_file="$HOME_TARGET/$filename"

      if ! check_exists "$target_file"; then
        echo "$WARN NEW: $filename (doesn't exist in home)"
        FILES_TO_COPY+=("home:$filename")
        home_new=$((home_new + 1))
      elif files_differ "$source_file" "$target_file"; then
        echo "$WARN UPDATE: $filename (different)"
        FILES_TO_COPY+=("home:$filename")
        home_update=$((home_update + 1))
      else
        echo "$CHECK SAME: $filename"
        FILES_TO_SKIP+=("home:$filename")
        home_same=$((home_same + 1))
      fi
    fi
  done

  echo ""
  echo "$ARRAY Comparing .config files..."
  local config_new=0
  local config_update=0
  local config_same=0

  if check_exists "$DOTFILES_SOURCE/.config"; then
    while IFS= read -r -d '' source_file; do
      local relative_path="${source_file#$DOTFILES_SOURCE/.config/}"
      local target_file="$CONFIG_TARGET/$relative_path"

      if ! check_exists "$target_file"; then
        echo "$WARN NEW: .config/$relative_path"
        FILES_TO_COPY+=("config:$relative_path")
        config_new=$((config_new + 1))
      elif files_differ "$source_file" "$target_file"; then
        echo "$WARN UPDATE: .config/$relative_path"
        FILES_TO_COPY+=("config:$relative_path")
        config_update=$((config_update + 1))
      else
        echo "$CHECK SAME: .config/$relative_path"
        FILES_TO_SKIP+=("config:$relative_path")
        config_same=$((config_same + 1))
      fi
    done < <(find "$DOTFILES_SOURCE/.config" -type f -print0 2>/dev/null)
  fi

  echo ""
  echo "$INFO Summary:"
  echo "  Home: $home_new new, $home_update updates, $home_same same"
  echo "  Config: $config_new new, $config_update updates, $config_same same"
  echo "  Total to process: ${#FILES_TO_COPY[@]} files"

  if [[ ${#FILES_TO_COPY[@]} -eq 0 ]]; then
    echo "$CHECK No changes needed - everything is up-to-date!"
    return 1
  fi

  return 0
}

# ==============================================
# STEP 3: SHOW WHAT WOULD HAPPEN
# ==============================================

show_actions() {
  print_header "STEP 3: DRY RUN - WHAT WOULD HAPPEN"

  echo "$DRY This is a simulation. No files will be changed."
  echo ""

  # Backup simulation
  echo "$ARROW Backup would be created at:"
  echo "  $BACKUP_DIR"
  echo ""

  echo "$ARROW Files that would be backed up:"
  local backup_count=0
  for item in "${FILES_TO_COPY[@]}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      local target_file="$HOME_TARGET/$path"
      if check_exists "$target_file"; then
        echo "  - $path"
        WOULD_BACKUP+=("$path")
        backup_count=$((backup_count + 1))
      fi
    else
      local target_file="$CONFIG_TARGET/$path"
      if check_exists "$target_file"; then
        echo "  - .config/$path"
        WOULD_BACKUP+=("config:$path")
        backup_count=$((backup_count + 1))
      fi
    fi
  done

  if [[ $backup_count -eq 0 ]]; then
    echo "  (No backups needed - files are new)"
  fi

  echo ""

  # Copy simulation
  echo "$ARROW Files that would be copied:"
  for item in "${FILES_TO_COPY[@]}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      echo "  - $path"
      WOULD_COPY+=("$path")
    else
      echo "  - .config/$path"
      WOULD_COPY+=("config:$path")
    fi
  done

  echo ""

  # Skip simulation
  if [[ ${#FILES_TO_SKIP[@]} -gt 0 ]]; then
    echo "$ARROW Files that would be skipped (already up-to-date):"
    for item in "${FILES_TO_SKIP[@]:0:5}"; do
      IFS=':' read -r type path <<<"$item"
      if [[ "$type" == "home" ]]; then
        echo "  - $path"
      else
        echo "  - .config/$path"
      fi
    done

    if [[ ${#FILES_TO_SKIP[@]} -gt 5 ]]; then
      echo "  ... and $((${#FILES_TO_SKIP[@]} - 5)) more"
    fi
  fi

  echo ""

  # Command summary
  echo "$ARROW Commands that would be executed:"
  echo "  1. mkdir -p '$BACKUP_DIR'"

  for item in "${FILES_TO_COPY[@]}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      local source="$DOTFILES_SOURCE/$path"
      local target="$HOME_TARGET/$path"

      if check_exists "$target"; then
        echo "  2. cp '$target' '$BACKUP_DIR/home/$path'"
        echo "  3. rm -f '$target'"
      fi
      echo "  4. cp '$source' '$target'"
    else
      local source="$DOTFILES_SOURCE/.config/$path"
      local target="$CONFIG_TARGET/$path"

      if check_exists "$target"; then
        echo "  2. cp '$target' '$BACKUP_DIR/config/$path'"
        echo "  3. rm -rf '$target'"
      fi
      echo "  4. mkdir -p '$(dirname "$target")'"
      echo "  5. cp '$source' '$target'"
    fi
  done
}

# ==============================================
# STEP 4: SUMMARY
# ==============================================

show_summary() {
  print_header "STEP 4: DRY RUN SUMMARY"

  echo "$INFO This was a DRY RUN - no changes were made"
  echo ""

  echo "$ARROW Statistics:"
  echo "  Total files checked: $((${#FILES_TO_COPY[@]} + ${#FILES_TO_SKIP[@]}))"
  echo "  Files that would be updated: ${#FILES_TO_COPY[@]}"
  echo "  Files already up-to-date: ${#FILES_TO_SKIP[@]}"
  echo "  Backups that would be created: ${#WOULD_BACKUP[@]}"
  echo ""

  echo "$ARROW To actually run the installation:"
  echo "  1. Save this script as 'real-install.sh'"
  echo "  2. Remove all '$DRY' messages and 'Would' prefixes"
  echo "  3. Change simulation functions to real actions"
  echo ""

  echo "$ARROW Quick preview of what would change:"
  for item in "${FILES_TO_COPY[@]:0:10}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      local source="$DOTFILES_SOURCE/$path"
      local target="$HOME_TARGET/$path"

      if check_exists "$target"; then
        echo "  $(basename "$path") - would be replaced"
      else
        echo "  $(basename "$path") - would be created"
      fi
    else
      local source="$DOTFILES_SOURCE/.config/$path"
      local target="$CONFIG_TARGET/$path"

      if check_exists "$target"; then
        echo "  .config/$path - would be replaced"
      else
        echo "  .config/$path - would be created"
      fi
    fi
  done

  if [[ ${#FILES_TO_COPY[@]} -gt 10 ]]; then
    echo "  ... and $((${#FILES_TO_COPY[@]} - 10)) more files"
  fi
}

# ==============================================
# MAIN
# ==============================================

main() {
  clear
  echo "=========================================="
  echo "    DRY RUN - DOTFILES INSTALLER"
  echo "=========================================="
  echo ""
  echo "$DRY This is a simulation only"
  echo "$DRY No files will be changed"
  echo ""

  # Step 1: Check source
  check_source

  echo ""
  read -p "Press Enter to continue to comparison..." _

  # Step 2: Compare files
  if compare_files; then
    echo ""
    read -p "Press Enter to see what would happen..." _

    # Step 3: Show actions
    show_actions

    echo ""
    read -p "Press Enter for summary..." _

    # Step 4: Summary
    show_summary
  fi

  echo ""
  echo "=========================================="
  echo "    DRY RUN COMPLETE"
  echo "=========================================="
  echo ""
  echo "$INFO Remember: No changes were actually made!"
  echo "$INFO Review the output above before running real installation."
  echo ""
}

# Run
main "$@"
