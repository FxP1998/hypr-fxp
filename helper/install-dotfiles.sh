#!/bin/bash

# ==============================================
# TTY-COMPATIBLE DOTFILES INSTALLER
# ==============================================

# Simple symbols that work everywhere
CHECK="[OK]"
CROSS="[FAIL]"
WARN="[WARN]"
INFO="[INFO]"
ARROW="==>"
PROMPT="[?]"
BACKUP="[BACKUP]"
COPY="[COPY]"

# Paths
DOTFILES_SOURCE="$HOME/hypr-fxp_dotfiles/dotfiles"
HOME_TARGET="$HOME"
CONFIG_TARGET="$HOME/.config"
BACKUP_DIR="$HOME/user_configs_backup_$(date +%Y%m%d_%H%M%S)"

# Arrays to track files
FILES_TO_COPY=()
FILES_TO_SKIP=()

# ==============================================
# HELPER FUNCTIONS
# ==============================================

# Ask for confirmation (works in TTY)
ask_confirm() {
  local question="$1"

  while true; do
    printf "%s %s (y/n): " "$PROMPT" "$question"
    read -r answer

    case "$answer" in
    [Yy] | [Yy][Ee][Ss])
      return 0
      ;;
    [Nn] | [Nn][Oo])
      return 1
      ;;
    *)
      echo "Please answer yes (y) or no (n)"
      ;;
    esac
  done
}

# Print header
print_header() {
  echo ""
  echo "=========================================="
  echo "  $1"
  echo "=========================================="
}

# Check if file/dir exists
check_exists() {
  [[ -e "$1" ]] && return 0 || return 1
}

# Compare two files
files_differ() {
  if check_exists "$1" && check_exists "$2"; then
    if cmp -s "$1" "$2"; then
      return 1 # Files are same
    else
      return 0 # Files differ
    fi
  else
    return 0 # One doesn't exist, so they "differ"
  fi
}

# ==============================================
# STEP 1: CHECK SOURCE
# ==============================================

check_source() {
  print_header "STEP 1: CHECKING SOURCE FILES"

  if ! check_exists "$DOTFILES_SOURCE"; then
    echo "$CROSS Source not found: $DOTFILES_SOURCE"
    exit 1
  fi

  echo "$CHECK Source directory: $DOTFILES_SOURCE"

  # Count files
  local home_files=$(find "$DOTFILES_SOURCE" -maxdepth 1 -type f -name ".*" 2>/dev/null | wc -l)
  local config_files=0

  if check_exists "$DOTFILES_SOURCE/.config"; then
    config_files=$(find "$DOTFILES_SOURCE/.config" -type f 2>/dev/null | wc -l)
  fi

  echo "$INFO Found $home_files home dotfiles"
  echo "$INFO Found $config_files config files"

  if [[ $home_files -eq 0 ]] && [[ $config_files -eq 0 ]]; then
    echo "$WARN No files found in source directory"
    if ! ask_confirm "Continue anyway?"; then
      exit 0
    fi
  fi
}

# ==============================================
# STEP 2: FIND FILES TO COPY
# ==============================================

find_files_to_copy() {
  print_header "STEP 2: FINDING FILES TO COPY"

  echo "$ARRAY Checking home directory..."

  # Home dotfiles (files starting with .)
  for source_file in "$DOTFILES_SOURCE"/.*; do
    if [[ -f "$source_file" ]]; then
      local filename=$(basename "$source_file")
      local target_file="$HOME_TARGET/$filename"

      if files_differ "$source_file" "$target_file"; then
        FILES_TO_COPY+=("home:$filename")
        echo "$WARN $filename needs update"
      else
        FILES_TO_SKIP+=("home:$filename")
        echo "$CHECK $filename is up-to-date"
      fi
    fi
  done

  echo ""
  echo "$ARROW Checking .config directory..."

  # .config files
  if check_exists "$DOTFILES_SOURCE/.config"; then
    while IFS= read -r -d '' source_file; do
      local relative_path="${source_file#$DOTFILES_SOURCE/.config/}"
      local target_file="$CONFIG_TARGET/$relative_path"

      if files_differ "$source_file" "$target_file"; then
        FILES_TO_COPY+=("config:$relative_path")
        echo "$WARN .config/$relative_path needs update"
      else
        FILES_TO_SKIP+=("config:$relative_path")
        echo "$CHECK .config/$relative_path is up-to-date"
      fi
    done < <(find "$DOTFILES_SOURCE/.config" -type f -print0 2>/dev/null)
  fi

  echo ""
  echo "$INFO Total files to update: ${#FILES_TO_COPY[@]}"
  echo "$INFO Files already up-to-date: ${#FILES_TO_SKIP[@]}"

  if [[ ${#FILES_TO_COPY[@]} -eq 0 ]]; then
    echo "$CHECK All files are already up-to-date!"
    return 1
  fi

  return 0
}

# ==============================================
# STEP 3: CREATE BACKUP
# ==============================================

create_backup() {
  print_header "STEP 3: CREATING BACKUP"

  if ! ask_confirm "Create backup of current files?"; then
    echo "$WARN Skipping backup"
    return 1
  fi

  mkdir -p "$BACKUP_DIR"
  echo "$INFO Backup directory: $BACKUP_DIR"

  local backup_count=0

  for item in "${FILES_TO_COPY[@]}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      local target_file="$HOME_TARGET/$path"
      if check_exists "$target_file"; then
        mkdir -p "$BACKUP_DIR/home"
        cp "$target_file" "$BACKUP_DIR/home/$path" 2>/dev/null
        if [[ $? -eq 0 ]]; then
          echo "$BACKUP $path"
          backup_count=$((backup_count + 1))
        fi
      fi
    else
      local target_file="$CONFIG_TARGET/$path"
      if check_exists "$target_file"; then
        mkdir -p "$(dirname "$BACKUP_DIR/config/$path")"
        cp "$target_file" "$BACKUP_DIR/config/$path" 2>/dev/null
        if [[ $? -eq 0 ]]; then
          echo "$BACKUP .config/$path"
          backup_count=$((backup_count + 1))
        fi
      fi
    fi
  done

  echo "$INFO Backed up $backup_count files"
  return 0
}

# ==============================================
# STEP 4: COPY FILES
# ==============================================

copy_files() {
  print_header "STEP 4: COPYING FILES"

  local copy_count=0
  local skip_count=0

  for item in "${FILES_TO_COPY[@]}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      local source_file="$DOTFILES_SOURCE/$path"
      local target_file="$HOME_TARGET/$path"
      local display_name="$path"
    else
      local source_file="$DOTFILES_SOURCE/.config/$path"
      local target_file="$CONFIG_TARGET/$path"
      local display_name=".config/$path"
    fi

    if ask_confirm "Copy $display_name?"; then
      # Remove old if exists
      if check_exists "$target_file"; then
        rm -rf "$target_file"
      fi

      # Create directory if needed
      mkdir -p "$(dirname "$target_file")"

      # Copy file or directory
      if [[ -d "$source_file" ]]; then
        cp -r "$source_file" "$target_file" 2>/dev/null
      else
        cp "$source_file" "$target_file" 2>/dev/null
      fi

      if [[ $? -eq 0 ]]; then
        echo "$COPY $display_name"
        copy_count=$((copy_count + 1))
      else
        echo "$CROSS Failed: $display_name"
        skip_count=$((skip_count + 1))
      fi
    else
      echo "$WARN Skipped: $display_name"
      skip_count=$((skip_count + 1))
    fi
  done

  echo ""
  echo "$INFO Copied: $copy_count files"
  echo "$INFO Skipped: $skip_count files"
}

# ==============================================
# STEP 5: VERIFY
# ==============================================

verify_copy() {
  print_header "STEP 5: VERIFICATION"

  if ! ask_confirm "Verify copied files?"; then
    echo "$WARN Skipping verification"
    return
  fi

  local verify_count=0
  local fail_count=0

  for item in "${FILES_TO_COPY[@]}"; do
    IFS=':' read -r type path <<<"$item"

    if [[ "$type" == "home" ]]; then
      local source_file="$DOTFILES_SOURCE/$path"
      local target_file="$HOME_TARGET/$path"
      local display_name="$path"
    else
      local source_file="$DOTFILES_SOURCE/.config/$path"
      local target_file="$CONFIG_TARGET/$path"
      local display_name=".config/$path"
    fi

    if check_exists "$target_file"; then
      if [[ -f "$source_file" ]] && [[ -f "$target_file" ]]; then
        if cmp -s "$source_file" "$target_file" 2>/dev/null; then
          echo "$CHECK $display_name"
          verify_count=$((verify_count + 1))
        else
          echo "$CROSS $display_name (mismatch)"
          fail_count=$((fail_count + 1))
        fi
      else
        # Directory or special file
        echo "$CHECK $display_name (exists)"
        verify_count=$((verify_count + 1))
      fi
    else
      echo "$CROSS $display_name (missing)"
      fail_count=$((fail_count + 1))
    fi
  done

  echo ""
  echo "$INFO Verified: $verify_count files"
  echo "$INFO Failed: $fail_count files"
}

# ==============================================
# MAIN FUNCTION
# ==============================================

main() {
  clear
  echo "=========================================="
  echo "    DOTFILES INSTALLATION TOOL"
  echo "=========================================="
  echo ""

  # Step 1: Check source
  check_source

  echo ""
  if ! ask_confirm "Continue to file comparison?"; then
    echo "Installation cancelled."
    exit 0
  fi

  # Step 2: Find files
  if ! find_files_to_copy; then
    exit 0
  fi

  echo ""
  if ! ask_confirm "Continue with file updates?"; then
    echo "Installation cancelled."
    exit 0
  fi

  # Step 3: Backup
  create_backup

  # Step 4: Copy files
  copy_files

  # Step 5: Verify
  verify_copy

  # Final message
  echo ""
  echo "=========================================="
  echo "    INSTALLATION COMPLETE"
  echo "=========================================="
  echo ""

  if [[ -d "$BACKUP_DIR" ]]; then
    echo "Backup saved in: $BACKUP_DIR"
    echo "To restore: cp -r $BACKUP_DIR/home/* ~/"
    echo "            cp -r $BACKUP_DIR/config/* ~/.config/"
  fi

  echo ""
  echo "Note: Restart your applications for changes to take effect."
}

# Run
main "$@"
