#!/bin/bash

# Color setup with extended colors
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    # Basic colors
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    WHITE='\033[0;37m'

    # Bright colors
    BRIGHT_RED='\033[1;31m'
    BRIGHT_GREEN='\033[1;32m'
    BRIGHT_YELLOW='\033[1;33m'
    BRIGHT_BLUE='\033[1;34m'
    BRIGHT_MAGENTA='\033[1;35m'
    BRIGHT_CYAN='\033[1;36m'
    BRIGHT_WHITE='\033[1;37m'

    # Effects
    BOLD='\033[1m'
    DIM='\033[2m'
    RESET='\033[0m'

    # Symbols
    CHECKMARK='✓'
    CROSSMARK='✗'
    WARNING='⚠'
    ARROW='→'
    INFO='ⓘ'
    STAR='★'
    DOT='•'
  else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    MAGENTA=''
    CYAN=''
    WHITE=''
    BRIGHT_RED=''
    BRIGHT_GREEN=''
    BRIGHT_YELLOW=''
    BRIGHT_BLUE=''
    BRIGHT_MAGENTA=''
    BRIGHT_CYAN=''
    BRIGHT_WHITE=''
    BOLD=''
    DIM=''
    RESET=''
    CHECKMARK='OK'
    CROSSMARK='FAIL'
    WARNING='WARN'
    ARROW='->'
    INFO='INFO'
    STAR='*'
    DOT='-'
  fi
}

setup_colors

# Logging functions
log_success() { echo -e "${GREEN}${CHECKMARK}${RESET} ${BOLD}$1${RESET}"; }
log_error() { echo -e "${RED}${CROSSMARK}${RESET} ${BOLD}$1${RESET}" >&2; }
log_warning() { echo -e "${YELLOW}${WARNING}${RESET} ${BOLD}$1${RESET}"; }
log_info() { echo -e "${BLUE}${INFO}${RESET} ${BOLD}$1${RESET}"; }
log_step() { echo -e "${BRIGHT_BLUE}${ARROW}${RESET} ${BOLD}$1${RESET}"; }
log_install() { echo -e "${BRIGHT_GREEN}${STAR}${RESET} ${BOLD}$1${RESET}"; }
log_skip() { echo -e "${DIM}${DOT}${RESET} ${DIM}$1${RESET}"; }

# Function to check if yay is installed
is_yay_installed() {
  command -v yay &>/dev/null
}

# Function to install yay-bin
install_yay_bin() {
  log_step "Checking for yay..."

  if is_yay_installed; then
    log_success "yay is already installed"
    return 0
  fi

  log_info "yay not found. Installing yay-bin..."

  # Create temp directory
  local temp_dir=$(mktemp -d)
  cd "$temp_dir" || return 1

  # Install dependencies
  log_info "Installing dependencies..."
  sudo pacman -S --needed --noconfirm git base-devel

  # Clone yay-bin repository
  log_info "Cloning yay-bin repository..."
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin || return 1

  # Build and install
  log_info "Building yay-bin..."
  if makepkg -si --noconfirm; then
    log_success "yay-bin installed successfully"
    cd ~
    rm -rf "$temp_dir"
    return 0
  else
    log_error "Failed to install yay-bin"
    cd ~
    rm -rf "$temp_dir"
    return 1
  fi
}

# Function to analyze packages and return missing count
analyze_packages() {
  local package_file="$1"
  local source="$2"

  if [[ ! -f "$package_file" ]]; then
    echo "0" # No file = no packages
    return 1
  fi

  # Read packages, remove comments and empty lines
  local packages=$(grep -v '^#' "$package_file" | grep -v '^$' | sort)

  if [[ -z "$packages" ]]; then
    echo "0" # Empty file = no packages
    return 0
  fi

  local total=0
  local missing=0

  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    pkg=$(echo "$pkg" | xargs)
    [[ -z "$pkg" ]] && continue

    total=$((total + 1))

    if ! pacman -Qi "$pkg" &>/dev/null; then
      missing=$((missing + 1))
    fi
  done <<<"$packages"

  echo "$missing" # Return count of missing packages
}

# Function to display package analysis
display_package_analysis() {
  local package_file="$1"
  local source="$2"

  if [[ ! -f "$package_file" ]]; then
    log_warning "${source^^} package file not found: $package_file"
    return 1
  fi

  # Read packages
  local packages=$(grep -v '^#' "$package_file" | grep -v '^$' | sort)

  if [[ -z "$packages" ]]; then
    log_info "No packages in ${source} file"
    return 0
  fi

  local total=$(echo "$packages" | wc -l)
  local installed=0
  local missing=0

  echo -e "${BRIGHT_WHITE}Analyzing packages from ${source^^}:${RESET}"
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

  # Display first few packages (limit to 10 for readability)
  local display_count=0
  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    pkg=$(echo "$pkg" | xargs)
    [[ -z "$pkg" ]] && continue

    if pacman -Qi "$pkg" &>/dev/null; then
      if [[ $display_count -lt 10 ]]; then
        echo -e "  ${GREEN}${CHECKMARK} ${pkg}${RESET}"
        display_count=$((display_count + 1))
      fi
      installed=$((installed + 1))
    else
      if [[ $display_count -lt 10 ]]; then
        echo -e "  ${YELLOW}${CROSSMARK} ${pkg}${RESET}"
        display_count=$((display_count + 1))
      fi
      missing=$((missing + 1))
    fi
  done <<<"$packages"

  # Show "..." if there are more packages
  if [[ $total -gt 10 ]]; then
    echo -e "  ${DIM}... and $((total - 10)) more packages${RESET}"
  fi

  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "  ${GREEN}Installed: ${installed}/${total}${RESET}"

  if [[ $missing -gt 0 ]]; then
    echo -e "  ${YELLOW}Missing:   ${missing}/${total}${RESET}"
  else
    echo -e "  ${BRIGHT_GREEN}✓ All ${source} packages are installed!${RESET}"
  fi

  echo ""
  return $missing # Return exit code based on missing count
}

# Function to install native packages
install_native_packages() {
  local package_file="$1"

  if [[ ! -f "$package_file" ]]; then
    log_error "Package file not found: $package_file"
    return 1
  fi

  # Read packages
  local packages=$(grep -v '^#' "$package_file" | grep -v '^$' | sort)

  if [[ -z "$packages" ]]; then
    log_warning "No packages found in: $package_file"
    return 0
  fi

  local total=$(echo "$packages" | wc -l)
  local installed_count=0
  local skipped_count=0
  local failed_count=0

  echo -e "${BRIGHT_WHITE}Installing Native Packages:${RESET}"
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

  # Arrays to track packages
  local to_install=()
  local already_installed=()

  # First pass: Check all packages
  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    pkg=$(echo "$pkg" | xargs)
    [[ -z "$pkg" ]] && continue

    if pacman -Qi "$pkg" &>/dev/null; then
      already_installed+=("$pkg")
      skipped_count=$((skipped_count + 1))
    else
      to_install+=("$pkg")
    fi
  done <<<"$packages"

  # Check if anything needs installation
  if [[ ${#to_install[@]} -eq 0 ]]; then
    echo -e "${BRIGHT_GREEN}✓ All native packages are already installed!${RESET}"
    echo -e "${DIM}Skipping native package installation.${RESET}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    return 0
  fi

  # Show already installed packages (first 5 only)
  if [[ ${#already_installed[@]} -gt 0 ]]; then
    echo -e "${GREEN}Already installed (${#already_installed[@]}):${RESET}"
    for ((i = 0; i < ${#already_installed[@]} && i < 5; i++)); do
      local pkg="${already_installed[$i]}"
      local version=$(pacman -Qi "$pkg" 2>/dev/null | grep -i version | head -1 | cut -d: -f2 | xargs)
      echo -e "  ${GREEN}${CHECKMARK} ${pkg} ${DIM}(${version})${RESET}"
    done
    if [[ ${#already_installed[@]} -gt 5 ]]; then
      echo -e "  ${DIM}... and $((${#already_installed[@]} - 5)) more${RESET}"
    fi
    echo ""
  fi

  # Show packages to install
  echo -e "${YELLOW}Packages to install (${#to_install[@]}):${RESET}"
  for ((i = 0; i < ${#to_install[@]} && i < 5; i++)); do
    echo -e "  ${YELLOW}${CROSSMARK} ${to_install[$i]}${RESET}"
  done
  if [[ ${#to_install[@]} -gt 5 ]]; then
    echo -e "  ${DIM}... and $((${#to_install[@]} - 5)) more${RESET}"
  fi
  echo ""

  # Install in batches
  local batch_size=10
  for ((i = 0; i < ${#to_install[@]}; i += batch_size)); do
    local batch=("${to_install[@]:i:batch_size}")
    local batch_num=$(((i / batch_size) + 1))
    local total_batches=$(((${#to_install[@]} + batch_size - 1) / batch_size))

    echo -e "${BLUE}Installing batch ${batch_num}/${total_batches}...${RESET}"

    if sudo pacman -S --needed --noconfirm "${batch[@]}"; then
      for pkg in "${batch[@]}"; do
        log_success "Installed $pkg"
        installed_count=$((installed_count + 1))
      done
    else
      for pkg in "${batch[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
          log_success "Installed $pkg"
          installed_count=$((installed_count + 1))
        else
          log_error "Failed to install $pkg"
          failed_count=$((failed_count + 1))
        fi
      done
    fi
    echo ""
  done

  # Summary
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BRIGHT_WHITE}Native Packages Summary:${RESET}"
  echo -e "  ${GREEN}${CHECKMARK} Newly installed: ${installed_count}${RESET}"
  echo -e "  ${BLUE}${INFO} Already had:      ${skipped_count}${RESET}"

  if [[ $failed_count -gt 0 ]]; then
    echo -e "  ${RED}${CROSSMARK} Failed:          ${failed_count}${RESET}"
    return 1
  fi

  return 0
}

# Function to install AUR packages
install_aur_packages() {
  local package_file="$1"

  if [[ ! -f "$package_file" ]]; then
    log_error "Package file not found: $package_file"
    return 1
  fi

  # Read packages
  local packages=$(grep -v '^#' "$package_file" | grep -v '^$' | sort)

  if [[ -z "$packages" ]]; then
    log_warning "No packages found in: $package_file"
    return 0
  fi

  local total=$(echo "$packages" | wc -l)
  local installed_count=0
  local skipped_count=0
  local failed_count=0

  echo -e "${BRIGHT_WHITE}Installing AUR Packages:${RESET}"
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

  # Arrays to track packages
  local to_install=()
  local already_installed=()

  # First pass: Check all packages
  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    pkg=$(echo "$pkg" | xargs)
    [[ -z "$pkg" ]] && continue

    if pacman -Qi "$pkg" &>/dev/null; then
      already_installed+=("$pkg")
      skipped_count=$((skipped_count + 1))
    else
      to_install+=("$pkg")
    fi
  done <<<"$packages"

  # Check if anything needs installation
  if [[ ${#to_install[@]} -eq 0 ]]; then
    echo -e "${BRIGHT_GREEN}✓ All AUR packages are already installed!${RESET}"
    echo -e "${DIM}Skipping AUR package installation.${RESET}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    return 0
  fi

  # Show already installed packages (first 5 only)
  if [[ ${#already_installed[@]} -gt 0 ]]; then
    echo -e "${GREEN}Already installed (${#already_installed[@]}):${RESET}"
    for ((i = 0; i < ${#already_installed[@]} && i < 5; i++)); do
      local pkg="${already_installed[$i]}"
      local version=$(pacman -Qi "$pkg" 2>/dev/null | grep -i version | head -1 | cut -d: -f2 | xargs)
      echo -e "  ${GREEN}${CHECKMARK} ${pkg} ${DIM}(${version})${RESET}"
    done
    if [[ ${#already_installed[@]} -gt 5 ]]; then
      echo -e "  ${DIM}... and $((${#already_installed[@]} - 5)) more${RESET}"
    fi
    echo ""
  fi

  # Show packages to install
  echo -e "${YELLOW}Packages to install (${#to_install[@]}):${RESET}"
  for ((i = 0; i < ${#to_install[@]} && i < 5; i++)); do
    echo -e "  ${YELLOW}${CROSSMARK} ${to_install[$i]}${RESET}"
  done
  if [[ ${#to_install[@]} -gt 5 ]]; then
    echo -e "  ${DIM}... and $((${#to_install[@]} - 5)) more${RESET}"
  fi
  echo ""

  # Install one by one (AUR packages need individual attention)
  for pkg in "${to_install[@]}"; do
    echo -e "${BRIGHT_GREEN}${STAR} Installing ${pkg} from AUR...${RESET}"

    if yay -S --needed --noconfirm "$pkg"; then
      log_success "Installed $pkg"
      installed_count=$((installed_count + 1))
    else
      log_error "Failed to install $pkg"
      failed_count=$((failed_count + 1))
    fi
    echo ""
  done

  # Summary
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BRIGHT_WHITE}AUR Packages Summary:${RESET}"
  echo -e "  ${GREEN}${CHECKMARK} Newly installed: ${installed_count}${RESET}"
  echo -e "  ${BLUE}${INFO} Already had:      ${skipped_count}${RESET}"

  if [[ $failed_count -gt 0 ]]; then
    echo -e "  ${RED}${CROSSMARK} Failed:          ${failed_count}${RESET}"
    return 1
  fi

  return 0
}

# Main function
main() {
  # Clear screen and show banner
  clear
  echo -e "${BRIGHT_CYAN}"
  echo "╔══════════════════════════════════════════════════╗"
  echo "║     Arch Linux Package Installation Wizard       ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo -e "${RESET}"

  # File paths
  local base_dir="$HOME/hypr-fxp_dotfiles"
  local native_file="${base_dir}/helper/pakages/archlinux-native-pakages.txt"
  local aur_file="${base_dir}/helper/pakages/archlinux-aur-pakages.txt"

  # Check if we're on Arch Linux
  if ! command -v pacman &>/dev/null; then
    log_error "This script requires Arch Linux (pacman not found)"
    exit 1
  fi

  # Update package database
  log_step "Updating package database..."
  if sudo pacman -Sy; then
    log_success "Package database updated"
  else
    log_warning "Failed to update package database"
  fi
  echo ""

  # Install yay-bin FIRST if we need AUR packages
  if [[ -f "$aur_file" ]]; then
    if ! is_yay_installed; then
      log_step "yay not found. Installing yay-bin first..."
      install_yay_bin
      if [[ $? -ne 0 ]]; then
        log_error "Failed to install yay-bin. AUR packages will be skipped."
        local skip_aur=true
      fi
    else
      log_success "yay is already installed"
    fi
    echo ""
  fi

  # Analyze packages first
  echo -e "${BRIGHT_MAGENTA}Package Analysis Report:${RESET}"
  echo ""

  # Track if anything is missing
  local total_missing=0

  # Native packages analysis
  local native_missing=0
  if [[ -f "$native_file" ]]; then
    display_package_analysis "$native_file" "native"
    native_missing=$?
    total_missing=$((total_missing + native_missing))
  else
    log_warning "Native package file not found: $native_file"
  fi

  # AUR packages analysis
  local aur_missing=0
  if [[ -f "$aur_file" ]] && [[ -z "$skip_aur" ]]; then
    display_package_analysis "$aur_file" "aur"
    aur_missing=$?
    total_missing=$((total_missing + aur_missing))
  elif [[ -f "$aur_file" ]] && [[ -n "$skip_aur" ]]; then
    log_warning "Skipping AUR analysis due to yay-bin installation failure"
  else
    log_warning "AUR package file not found: $aur_file"
  fi

  # Check if anything is missing
  if [[ $total_missing -eq 0 ]]; then
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    log_success "All packages are already installed!"
    echo ""
    log_info "No installation needed. Exiting."
    exit 0
  fi

  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo ""
  log_info "Found ${total_missing} packages to install"
  echo ""

  # Ask for confirmation
  read -p "$(echo -e ${BRIGHT_YELLOW}"Proceed with installation? [y/N]: "${RESET})" -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${DIM}Installation cancelled.${RESET}"
    exit 0
  fi

  echo ""
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo ""

  # Install native packages (only if missing)
  if [[ -f "$native_file" ]] && [[ $native_missing -gt 0 ]]; then
    install_native_packages "$native_file"
    echo ""
  elif [[ -f "$native_file" ]]; then
    echo -e "${BRIGHT_GREEN}✓ All native packages are already installed${RESET}"
    echo ""
  fi

  # Install AUR packages (only if missing and yay is available)
  if [[ -f "$aur_file" ]] && [[ $aur_missing -gt 0 ]] && [[ -z "$skip_aur" ]]; then
    install_aur_packages "$aur_file"
  elif [[ -f "$aur_file" ]] && [[ -z "$skip_aur" ]]; then
    echo -e "${BRIGHT_GREEN}✓ All AUR packages are already installed${RESET}"
    echo ""
  fi

  # Final summary
  echo ""
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BRIGHT_GREEN}✨ Installation Complete! ✨${RESET}"
  echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

  # Check for orphans
  local orphans=$(pacman -Qdtq 2>/dev/null)
  if [[ -n "$orphans" ]]; then
    echo ""
    log_warning "Orphan packages detected:"
    echo -e "${YELLOW}$orphans${RESET}"
    echo ""
    log_info "To remove orphans, run:"
    echo -e "  ${CYAN}sudo pacman -Rns \$(pacman -Qdtq)${RESET}"
  else
    echo ""
    log_success "System is clean - no orphan packages found"
  fi
}

# Run main function
main "$@"
