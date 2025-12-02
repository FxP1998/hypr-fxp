#!/bin/bash

# ==============================================
# SUBFOLDER DOTFILES INSTALLER WITH COLORS
# ==============================================

# Setup colors - safe for TTY and terminal
setup_colors() {
  # Check if we're in a terminal that supports colors
  if [[ -t 1 ]] && [[ "$TERM" != "dumb" ]]; then
    # Use tput for maximum compatibility
    if command -v tput >/dev/null 2>&1; then
      RED=$(tput setaf 1)
      GREEN=$(tput setaf 2)
      YELLOW=$(tput setaf 3)
      BLUE=$(tput setaf 4)
      MAGENTA=$(tput setaf 5)
      CYAN=$(tput setaf 6)
      WHITE=$(tput setaf 7)
      BOLD=$(tput bold)
      RESET=$(tput sgr0)
    else
      # Fallback to ANSI codes
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[0;33m'
      BLUE='\033[0;34m'
      MAGENTA='\033[0;35m'
      CYAN='\033[0;36m'
      WHITE='\033[0;37m'
      BOLD='\033[1m'
      RESET='\033[0m'
    fi
  else
    # No colors for non-terminal or dumb terminal
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    MAGENTA=''
    CYAN=''
    WHITE=''
    BOLD=''
    RESET=''
  fi
}

# Initialize colors
setup_colors

# Symbols with colors
CHECK="${GREEN}[OK]${RESET}"
CROSS="${RED}[FAIL]${RESET}"
WARN="${YELLOW}[WARN]${RESET}"
INFO="${BLUE}[INFO]${RESET}"
ARROW="${CYAN}==>${RESET}"
PROMPT="${MAGENTA}[?]${RESET}"

# Paths
DOTFILES_SOURCE="$HOME/hypr-fxp_dotfiles/dotfiles"
HOME_TARGET="$HOME"
CONFIG_TARGET="$HOME/.config"
BACKUP_DIR="$HOME/user_configs_backup_$(date +%Y%m%d_%H%M%S)"

# ==============================================
# CONFIGURATION - EDIT THIS SECTION
# ==============================================

# Home dotfiles (files starting with .)
HOME_FILES=(
  ".bashrc"
  ".zshrc"
)

# Config subfolders to copy (from .config/ to .config/)
CONFIG_FOLDERS=(
  "hypr"
  "kitty"
  "nvim"
  "waybar"
  "rofi"
  "dunst"
  "btop"
  "mako"
  "swayosd"
  "auto-cpufreq"
  "yazi"
  "menus"
  "gtk-3.0"
)

# Other directories to copy (from root to root)
OTHER_DIRS=(
  ".fonts"
  ".icons"
  ".themes"
  ".vim"
)

# ==============================================
# HELPER FUNCTIONS
# ==============================================

print_header() {
  echo ""
  echo "${BOLD}${WHITE}==========================================${RESET}"
  echo "${BOLD}${WHITE}  $1${RESET}"
  echo "${BOLD}${WHITE}==========================================${RESET}"
}

check_exists() {
  [[ -e "$1" ]] && return 0 || return 1
}

ask_confirm() {
  local question="$1"

  while true; do
    printf "%b %b %b" "$PROMPT" "$question" "(y/n): "
    read -r answer

    case "$answer" in
    [Yy] | [Yy][Ee][Ss]) return 0 ;;
    [Nn] | [Nn][Oo]) return 1 ;;
    *) echo "Please answer yes (y) or no (n)" ;;
    esac
  done
}

# ==============================================
# STEP 1: CHECK WHAT EXISTS
# ==============================================

analyze_files() {
  print_header "ANALYZING FILES"

  echo "$INFO Checking source directory..."
  if ! check_exists "$DOTFILES_SOURCE"; then
    echo "$CROSS Source not found: $DOTFILES_SOURCE"
    exit 1
  fi
  echo "$CHECK Source directory exists"
  echo ""

  echo "$INFO Checking home dotfiles..."
  for file in "${HOME_FILES[@]}"; do
    local source_file="$DOTFILES_SOURCE/$file"
    local target_file="$HOME_TARGET/$file"

    if check_exists "$source_file"; then
      if check_exists "$target_file"; then
        echo "  $WARN $file (exists, will be replaced)"
      else
        echo "  $CHECK $file (will be created)"
      fi
    else
      echo "  $CROSS $file (missing in source)"
    fi
  done
  echo ""

  echo "$INFO Checking config subfolders..."
  for folder in "${CONFIG_FOLDERS[@]}"; do
    local source_folder="$DOTFILES_SOURCE/.config/$folder"
    local target_folder="$CONFIG_TARGET/$folder"

    if check_exists "$source_folder"; then
      if check_exists "$target_folder"; then
        echo "  $WARN .config/$folder (exists, will be replaced)"
      else
        echo "  $CHECK .config/$folder (will be created)"
      fi
    else
      echo "  $CROSS .config/$folder (missing in source)"
    fi
  done
  echo ""

  echo "$INFO Checking other directories..."
  for dir in "${OTHER_DIRS[@]}"; do
    local source_dir="$DOTFILES_SOURCE/$dir"
    local target_dir="$HOME_TARGET/$dir"

    if check_exists "$source_dir"; then
      if check_exists "$target_dir"; then
        echo "  $WARN $dir (exists, will be replaced)"
      else
        echo "  $CHECK $dir (will be created)"
      fi
    else
      echo "  $CROSS $dir (missing in source)"
    fi
  done
}

# ==============================================
# STEP 2: CREATE BACKUP
# ==============================================

create_backup() {
  print_header "CREATING BACKUP"

  echo "$INFO Creating backup directory: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"

  # Backup home files
  echo "$INFO Backing up home files..."
  for file in "${HOME_FILES[@]}"; do
    local target_file="$HOME_TARGET/$file"
    if check_exists "$target_file"; then
      mkdir -p "$BACKUP_DIR/home"
      if cp -r "$target_file" "$BACKUP_DIR/home/$file" 2>/dev/null; then
        echo "  $CHECK $file"
      else
        echo "  $CROSS Failed to backup $file"
      fi
    fi
  done

  # Backup config folders
  echo "$INFO Backing up config folders..."
  for folder in "${CONFIG_FOLDERS[@]}"; do
    local target_folder="$CONFIG_TARGET/$folder"
    if check_exists "$target_folder"; then
      mkdir -p "$BACKUP_DIR/config"
      if cp -r "$target_folder" "$BACKUP_DIR/config/$folder" 2>/dev/null; then
        echo "  $CHECK .config/$folder"
      else
        echo "  $CROSS Failed to backup .config/$folder"
      fi
    fi
  done

  # Backup other directories
  echo "$INFO Backing up other directories..."
  for dir in "${OTHER_DIRS[@]}"; do
    local target_dir="$HOME_TARGET/$dir"
    if check_exists "$target_dir"; then
      mkdir -p "$BACKUP_DIR/other"
      if cp -r "$target_dir" "$BACKUP_DIR/other/$dir" 2>/dev/null; then
        echo "  $CHECK $dir"
      else
        echo "  $CROSS Failed to backup $dir"
      fi
    fi
  done

  echo ""
  echo "$CHECK Backup created at: ${BOLD}$BACKUP_DIR${RESET}"
}

# ==============================================
# STEP 3: COPY FILES AND FOLDERS
# ==============================================

copy_items() {
  print_header "COPYING FILES AND FOLDERS"

  # Copy home files
  echo "$INFO Copying home files..."
  for file in "${HOME_FILES[@]}"; do
    local source_file="$DOTFILES_SOURCE/$file"
    local target_file="$HOME_TARGET/$file"

    if check_exists "$source_file"; then
      # Remove old file if exists
      if check_exists "$target_file"; then
        rm -f "$target_file"
      fi

      # Copy new file
      if cp "$source_file" "$target_file"; then
        echo "  $CHECK $file"
      else
        echo "  $CROSS Failed to copy $file"
      fi
    fi
  done
  echo ""

  # Copy config subfolders
  echo "$INFO Copying config subfolders..."
  for folder in "${CONFIG_FOLDERS[@]}"; do
    local source_folder="$DOTFILES_SOURCE/.config/$folder"
    local target_folder="$CONFIG_TARGET/$folder"

    if check_exists "$source_folder"; then
      # Remove old folder if exists
      if check_exists "$target_folder"; then
        rm -rf "$target_folder"
      fi

      # Create parent directory
      mkdir -p "$(dirname "$target_folder")"

      # Copy new folder
      if cp -r "$source_folder" "$target_folder"; then
        echo "  $CHECK .config/$folder"
      else
        echo "  $CROSS Failed to copy .config/$folder"
      fi
    fi
  done
  echo ""

  # Copy other directories
  echo "$INFO Copying other directories..."
  for dir in "${OTHER_DIRS[@]}"; do
    local source_dir="$DOTFILES_SOURCE/$dir"
    local target_dir="$HOME_TARGET/$dir"

    if check_exists "$source_dir"; then
      # Remove old directory if exists
      if check_exists "$target_dir"; then
        rm -rf "$target_dir"
      fi

      # Copy new directory
      if cp -r "$source_dir" "$target_dir"; then
        echo "  $CHECK $dir"
      else
        echo "  $CROSS Failed to copy $dir"
      fi
    fi
  done
}

# ==============================================
# STEP 4: VERIFY
# ==============================================

verify_copy() {
  print_header "VERIFYING COPY"

  local success=0
  local fail=0

  # Verify home files
  echo "$INFO Verifying home files..."
  for file in "${HOME_FILES[@]}"; do
    local source_file="$DOTFILES_SOURCE/$file"
    local target_file="$HOME_TARGET/$file"

    if check_exists "$source_file"; then
      if check_exists "$target_file"; then
        echo "  $CHECK $file"
        success=$((success + 1))
      else
        echo "  $CROSS $file (missing)"
        fail=$((fail + 1))
      fi
    fi
  done

  # Verify config folders
  echo "$INFO Verifying config folders..."
  for folder in "${CONFIG_FOLDERS[@]}"; do
    local source_folder="$DOTFILES_SOURCE/.config/$folder"
    local target_folder="$CONFIG_TARGET/$folder"

    if check_exists "$source_folder"; then
      if check_exists "$target_folder"; then
        echo "  $CHECK .config/$folder"
        success=$((success + 1))
      else
        echo "  $CROSS .config/$folder (missing)"
        fail=$((fail + 1))
      fi
    fi
  done

  # Verify other directories
  echo "$INFO Verifying other directories..."
  for dir in "${OTHER_DIRS[@]}"; do
    local source_dir="$DOTFILES_SOURCE/$dir"
    local target_dir="$HOME_TARGET/$dir"

    if check_exists "$source_dir"; then
      if check_exists "$target_dir"; then
        echo "  $CHECK $dir"
        success=$((success + 1))
      else
        echo "  $CROSS $dir (missing)"
        fail=$((fail + 1))
      fi
    fi
  done

  echo ""
  echo "$INFO Verification summary:"
  echo "  $CHECK Success: $success"
  echo "  $CROSS Failed: $fail"

  if [[ $fail -eq 0 ]]; then
    echo ""
    echo "${GREEN}${BOLD}✅ All files copied successfully!${RESET}"
  fi
}

# ==============================================
# MAIN FUNCTION
# ==============================================

main() {
  clear
  echo "${BOLD}${CYAN}"
  echo "=========================================="
  echo "    SUBFOLDER DOTFILES INSTALLER"
  echo "=========================================="
  echo "${RESET}"
  echo "$INFO ${BOLD}Source:${RESET} $DOTFILES_SOURCE"
  echo "$INFO ${BOLD}Target:${RESET} $HOME_TARGET"
  echo ""

  # Analyze first
  analyze_files

  echo ""
  if ! ask_confirm "Continue with installation?"; then
    echo "${YELLOW}Installation cancelled.${RESET}"
    exit 0
  fi

  # Create backup
  if ask_confirm "Create backup of existing files?"; then
    create_backup
  else
    echo "$WARN Skipping backup"
  fi

  echo ""
  if ! ask_confirm "Proceed with copying files?"; then
    echo "${YELLOW}Copying cancelled.${RESET}"
    exit 0
  fi

  # Copy items
  copy_items

  echo ""
  if ask_confirm "Verify the copy?"; then
    verify_copy
  fi

  # Final message
  echo ""
  print_header "INSTALLATION COMPLETE"
  echo ""
  echo "$CHECK All specified subfolders have been copied"
  echo ""

  if check_exists "$BACKUP_DIR"; then
    echo "$INFO ${BOLD}Backup saved at:${RESET} $BACKUP_DIR"
    echo ""
    echo "${CYAN}To restore:${RESET}"
    echo "  ${WHITE}Home files:${RESET}   cp -r $BACKUP_DIR/home/* ~/"
    echo "  ${WHITE}Config:${RESET}       cp -r $BACKUP_DIR/config/* ~/.config/"
    echo "  ${WHITE}Other:${RESET}        cp -r $BACKUP_DIR/other/* ~/"
  fi

  echo ""
  echo "${YELLOW}${BOLD}Note:${RESET} You may need to restart applications"
  echo "${YELLOW}or reload your session for changes to take effect${RESET}"
}

# Run
main "$@"
