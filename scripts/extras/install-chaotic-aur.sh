#!/usr/bin/env bash
# Script: install-chaotic-aur.sh
# Desc: Safe, idempotent setup for Chaotic-AUR with backup and key change warnings.

# --- Configuration (The "Trusted Anchor") ---
# This is the primary GPG key from the official docs.
# IF THE SETUP FAILS WITH A KEY ERROR, MANUALLY CHECK THE LATEST DOCS:
# https://aur.chaotic.cx/docs
CHAOTIC_GPG_KEY="3056513887B78AEB"
CHAOTIC_MIRROR_URL="https://cdn-mirror.chaotic.cx/chaotic-aur"

# --- Formatting ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- Initial Checks ---
clear
echo -e "${BOLD}=== Safe Chaotic-AUR Setup ===${NC}\n"
[[ $EUID -ne 0 ]] && { error "Run with sudo: sudo $0"; exit 1; }
command -v pacman &>/dev/null || { error "Arch Linux (pacman) required."; exit 1; }

# --- Core Function: Setup Repository ---
setup_chaotic_aur() {
    info "Starting setup. GPG Key ID: ${BOLD}$CHAOTIC_GPG_KEY${NC}"
    warn "Note: If this key is outdated, the script will fail safely."
    echo

    # STEP 1: BACKUP pacman.conf
    local PACMAN_CONF="/etc/pacman.conf"
    local BACKUP_CONF="${PACMAN_CONF}.bak-$(date +%s)"
    info "1. Backing up ${PACMAN_CONF} -> ${BACKUP_CONF}"
    cp "$PACMAN_CONF" "$BACKUP_CONF" || { error "Backup failed!"; exit 1; }
    success "Backup created."

    # STEP 2: GPG KEY OPERATIONS
    info "2. Configuring GPG key."
    # Check if key is already present and trusted
    if pacman-key --list-keys "$CHAOTIC_GPG_KEY" &>/dev/null; then
        warn "Key $CHAOTIC_GPG_KEY already in keyring. Skipping receive."
    else
        info "   Receiving key from keyserver..."
        if ! pacman-key --recv-key "$CHAOTIC_GPG_KEY" --keyserver keyserver.ubuntu.com; then
            error "Failed to receive key. Possible causes:"
            error "   - Network issue."
            error "   - The key ID ($CHAOTIC_GPG_KEY) may have changed."
            error "   Check the latest docs: ${BOLD}https://aur.chaotic.cx/docs${NC}"
            exit 1
        fi
        success "   Key received."
    fi

    # Sign the key (this will do nothing if already signed)
    info "   Locally signing the key..."
    if pacman-key --lsign-key "$CHAOTIC_GPG_KEY"; then
        success "   Key signed."
    else
        error "Failed to sign key. Cannot proceed."
        exit 1
    fi

    # STEP 3: INSTALL PACKAGES
    info "3. Installing Chaotic-AUR packages..."
    for pkg in chaotic-keyring chaotic-mirrorlist; do
        local pkg_url="${CHAOTIC_MIRROR_URL}/${pkg}.pkg.tar.zst"
        info "   Installing $pkg from $pkg_url"
        if pacman -U --noconfirm "$pkg_url" &>/dev/null; then
            success "   $pkg installed."
        else
            error "   Failed to install $pkg."
            exit 1
        fi
    done

    # STEP 4: CONFIGURE pacman.conf
    info "4. Configuring /etc/pacman.conf..."
    if grep -q "^\[chaotic-aur\]" "$PACMAN_CONF"; then
        warn "   [chaotic-aur] repository already configured. Skipping."
    else
        info "   Adding [chaotic-aur] section..."
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> "$PACMAN_CONF"
        # Verify the addition
        if grep -q "^\[chaotic-aur\]" "$PACMAN_CONF"; then
            success "   Repository added successfully."
        else
            error "   Failed to add repository. Restoring backup..."
            cp "$BACKUP_CONF" "$PACMAN_CONF"
            error "   Original pacman.conf restored from backup."
            exit 1
        fi
    fi

    # STEP 5: SYSTEM UPDATE
    info "5. Performing full system update (sync new repo)..."
    warn "   This may take several minutes. Do not interrupt."
    if pacman -Syu --noconfirm; then
        success "   System updated successfully."
    else
        warn "   System update encountered issues. The repo may still work, but please check manually."
    fi

    # FINAL MESSAGE
    echo -e "\n${BOLD}${GREEN}=== Setup Finished ===${NC}"
    success "Chaotic-AUR is ready. Backup of pacman.conf: ${BOLD}$BACKUP_CONF${NC}"
    echo -e "\nTo install a package:"
    echo -e "  ${BOLD}sudo pacman -S chaotic-aur/firedragon${NC}"
    echo -e "  ${BOLD}paru -S chaotic-aur/firefox-nightly${NC}  # Example with AUR helper"
}

# --- Main Execution ---
setup_chaotic_aur
