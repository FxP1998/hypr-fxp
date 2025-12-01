#!/bin/bash

# Color setup for both TTY and terminal
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    WHITE='\033[0;37m'
    BRIGHT_RED='\033[1;31m'
    BRIGHT_GREEN='\033[1;32m'
    BRIGHT_YELLOW='\033[1;33m'
    BOLD='\033[1m'
    RESET='\033[0m'
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
    BOLD=''
    RESET=''
  fi
}

setup_colors

# Colorful output functions
log_info() {
  echo -e "${BLUE}[INFO]${RESET} ${BOLD}$1${RESET}"
}

log_success() {
  echo -e "${GREEN}[✓]${RESET} ${BOLD}$1${RESET}"
}

log_warning() {
  echo -e "${YELLOW}[!]${RESET} ${BOLD}$1${RESET}"
}

log_error() {
  echo -e "${RED}[✗]${RESET} ${BOLD}$1${RESET}" >&2
}

# Function to check if a package is installed
is_package_installed() {
  pacman -Qi "$1" &>/dev/null
  return $?
}

# Function to install a package if not already installed
install_package() {
  local pkg="$1"

  if is_package_installed "$pkg"; then
    log_success "$pkg is already installed"
    return 0
  else
    log_info "Installing $pkg..."
    if sudo pacman -S --needed --noconfirm "$pkg"; then
      log_success "$pkg installed successfully"
      return 0
    else
      log_error "Failed to install $pkg"
      return 1
    fi
  fi
}

# Main installation function
install_git_base_devel() {
  echo -e "${BRIGHT_YELLOW}========================================${RESET}"
  echo -e "${BRIGHT_YELLOW}    Installing git and base-devel       ${RESET}"
  echo -e "${BRIGHT_YELLOW}========================================${RESET}"
  echo ""

  # Check if pacman is available
  if ! command -v pacman &>/dev/null; then
    log_error "pacman not found. Are you on Arch Linux?"
    return 1
  fi

  # Update package database first (optional but recommended)
  log_info "Refreshing package database..."
  if sudo pacman -Sy; then
    log_success "Package database updated"
  else
    log_warning "Failed to update package database, continuing anyway..."
  fi

  echo ""

  # Install packages
  install_package "git"
  install_package "base-devel"

  # Verify installations
  echo ""
  log_info "Verifying installations..."

  if is_package_installed "git" && is_package_installed "base-devel"; then
    echo -e "${BRIGHT_GREEN}========================================${RESET}"
    echo -e "${BRIGHT_GREEN}   All required packages are installed!  ${RESET}"
    echo -e "${BRIGHT_GREEN}========================================${RESET}"
    return 0
  else
    echo -e "${BRIGHT_RED}========================================${RESET}"
    echo -e "${BRIGHT_RED}   Some packages failed to install!      ${RESET}"
    echo -e "${BRIGHT_RED}========================================${RESET}"
    return 1
  fi
}

# Enhanced version with group package handling
install_git_base_devel_enhanced() {
  echo -e "${BRIGHT_YELLOW}========================================${RESET}"
  echo -e "${BRIGHT_YELLOW}    Installing git and base-devel       ${RESET}"
  echo -e "${BRIGHT_YELLOW}========================================${RESET}"
  echo ""

  # Check for git
  if is_package_installed "git"; then
    log_success "git is already installed"
  else
    log_info "Installing git..."
    if sudo pacman -S --needed --noconfirm git; then
      log_success "git installed successfully"
    else
      log_error "Failed to install git"
      return 1
    fi
  fi

  echo ""

  # Check for base-devel group
  log_info "Checking base-devel group..."

  # Get list of packages in base-devel group
  base_devel_packages=$(pacman -Sg base-devel 2>/dev/null | awk '{print $2}')

  if [[ -z "$base_devel_packages" ]]; then
    log_warning "base-devel group not found in package database"
    log_info "Refreshing package database and trying again..."
    sudo pacman -Sy
    base_devel_packages=$(pacman -Sg base-devel 2>/dev/null | awk '{print $2}')
  fi

  if [[ -z "$base_devel_packages" ]]; then
    log_error "Could not retrieve base-devel package list"
    return 1
  fi

  # Check which packages are already installed
  missing_packages=()
  installed_packages=()

  for pkg in $base_devel_packages; do
    if is_package_installed "$pkg"; then
      installed_packages+=("$pkg")
    else
      missing_packages+=("$pkg")
    fi
  done

  # Show status
  log_info "base-devel group status:"
  log_success "${#installed_packages[@]}/${#base_devel_packages[@]} packages already installed"

  if [[ ${#missing_packages[@]} -eq 0 ]]; then
    log_success "All base-devel packages are already installed!"
    echo ""
    echo -e "${BRIGHT_GREEN}========================================${RESET}"
    echo -e "${BRIGHT_GREEN}   All required packages are installed!  ${RESET}"
    echo -e "${BRIGHT_GREEN}========================================${RESET}"
    return 0
  fi

  log_warning "${#missing_packages[@]} packages need installation"

  echo ""
  log_info "Installing missing base-devel packages..."

  # Install the entire group
  if sudo pacman -S --needed --noconfirm base-devel; then
    log_success "base-devel group installed successfully"
    echo ""
    echo -e "${BRIGHT_GREEN}========================================${RESET}"
    echo -e "${BRIGHT_GREEN}   All required packages are installed!  ${RESET}"
    echo -e "${BRIGHT_GREEN}========================================${RESET}"
    return 0
  else
    log_error "Failed to install base-devel group"

    # Try installing packages individually
    log_info "Trying to install packages individually..."
    local failed=0

    for pkg in "${missing_packages[@]}"; do
      if sudo pacman -S --needed --noconfirm "$pkg"; then
        log_success "Installed $pkg"
      else
        log_error "Failed to install $pkg"
        ((failed++))
      fi
    done

    if [[ $failed -eq 0 ]]; then
      echo -e "${BRIGHT_GREEN}========================================${RESET}"
      echo -e "${BRIGHT_GREEN}   All packages installed successfully!  ${RESET}"
      echo -e "${BRIGHT_GREEN}========================================${RESET}"
      return 0
    else
      echo -e "${BRIGHT_RED}========================================${RESET}"
      echo -e "${BRIGHT_RED}   $failed packages failed to install!    ${RESET}"
      echo -e "${BRIGHT_RED}========================================${RESET}"
      return 1
    fi
  fi
}

# Simple version (like your original but enhanced)
install_git_base_devel_simple() {
  echo -e "${BRIGHT_YELLOW}Installing git and base-devel${RESET}"

  # Check for git
  if pacman -Qi git &>/dev/null; then
    echo -e "${GREEN}git is already installed${RESET}"
  else
    echo -e "${YELLOW}Installing git...${RESET}"
    sudo pacman -S --needed --noconfirm git
  fi

  # Check for base-devel
  if pacman -Qg base-devel &>/dev/null; then
    echo -e "${GREEN}base-devel group is already installed${RESET}"
  else
    echo -e "${YELLOW}Installing base-devel...${RESET}"
    sudo pacman -S --needed --noconfirm base-devel
  fi
}

# Choose which function to use:
# Option 1: Simple version (fastest)
# install_git_base_devel_simple

# Option 2: Detailed version (recommended)
install_git_base_devel

# Option 3: Most detailed version with group handling
# install_git_base_devel_enhanced
