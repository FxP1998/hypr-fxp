#!/bin/bash

# GTK-3.0 Settings Reload Script
# Reloads GTK-3.0 applications after manual changes to settings.ini

# Configuration
GTK_CONFIG_DIR="$HOME/.config/gtk-3.0"
SETTINGS_FILE="$GTK_CONFIG_DIR/settings.ini"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to reload GTK settings
reload_gtk_settings() {
    print_status "Reloading GTK-3.0 settings..."
    
    # Check if settings.ini exists
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        print_error "Settings file not found: $SETTINGS_FILE"
        return 1
    fi
    
    # Validate settings.ini format
    if ! grep -q "\[Settings\]" "$SETTINGS_FILE"; then
        print_error "Invalid settings.ini format - missing [Settings] section"
        return 1
    fi
    
    # Get current theme for verification
    CURRENT_THEME=$(grep "gtk-theme-name" "$SETTINGS_FILE" | cut -d'=' -f2)
    if [[ -n "$CURRENT_THEME" ]]; then
        print_status "Current theme: $CURRENT_THEME"
    fi
    
    # Reload GTK settings
    print_status "Sending reload signal to GTK applications..."
    
    # Method 1: Use gsettings (if available)
    if command -v gsettings &> /dev/null; then
        print_status "Reloading via gsettings..."
        gsettings reset org.gnome.desktop.interface gtk-theme
        gsettings set org.gnome.desktop.interface gtk-theme "$CURRENT_THEME"
    fi
    
    # Method 2: Kill and restart common GTK applications
    print_status "Restarting GTK applications..."
    
    # List of common GTK applications to restart
    GTK_APPS=("nautilus" "nemo" "caja" "thunar" "file-roller" "gedit" "gnome-terminal")
    
    for app in "${GTK_APPS[@]}"; do
        if pgrep -x "$app" > /dev/null; then
            print_status "Restarting $app..."
            pkill -x "$app"
            # Restart in background
            nohup "$app" > /dev/null 2>&1 &
        fi
    done
    
    # Method 3: Reload specific applications that might be running
    reload_specific_apps() {
        # Firefox (if using GTK theme)
        if pgrep -x "firefox" > /dev/null; then
            print_status "Firefox detected - please restart manually to apply theme changes"
        fi
        
        # Chrome/Chromium
        if pgrep -x "chrome" > /dev/null || pgrep -x "chromium" > /dev/null; then
            print_status "Chrome/Chromium detected - please restart manually to apply theme changes"
        fi
        
        # Discord
        if pgrep -x "discord" > /dev/null; then
            print_status "Discord detected - restarting..."
            pkill -x "discord"
            nohup discord > /dev/null 2>&1 &
        fi
    }
    
    reload_specific_apps
    
    # Method 4: Update GTK cache
    print_status "Updating GTK cache..."
    if command -v gtk3-update-icon-cache &> /dev/null; then
        # Update icon cache for installed themes
        for theme_dir in "$HOME/.themes"/* "$HOME/.local/share/themes"/*; do
            if [[ -d "$theme_dir" ]]; then
                icon_dir="$theme_dir/gtk-3.0/assets"
                if [[ -d "$icon_dir" ]]; then
                    gtk3-update-icon-cache -q "$icon_dir" 2>/dev/null || true
                fi
            fi
        done
    fi
    
    print_success "GTK settings reload completed!"
    print_warning "Some applications may need to be restarted manually"
    print_warning "For complete theme application, you may need to log out and log back in"
}

# Function to show current settings
show_current_settings() {
    if [[ -f "$SETTINGS_FILE" ]]; then
        print_status "Current GTK-3.0 settings:"
        echo "────────────────────────────────"
        cat "$SETTINGS_FILE"
        echo "────────────────────────────────"
    else
        print_error "No settings file found at $SETTINGS_FILE"
    fi
}

# Function to validate theme existence
validate_theme() {
    local theme_name="$1"
    local theme_dirs=(
        "$HOME/.themes/$theme_name"
        "$HOME/.local/share/themes/$theme_name"
        "/usr/share/themes/$theme_name"
    )
    
    for dir in "${theme_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            print_success "Theme found: $dir"
            return 0
        fi
    done
    
    print_error "Theme '$theme_name' not found in any standard location"
    print_status "Checked locations:"
    for dir in "${theme_dirs[@]}"; do
        echo "  - $dir"
    done
    return 1
}

# Function to change theme interactively
change_theme_interactive() {
    print_status "Available themes in ~/.themes/:"
    if [[ -d "$HOME/.themes" ]]; then
        ls -1 "$HOME/.themes"
        echo
        read -p "Enter theme name to switch to: " new_theme
        
        if validate_theme "$new_theme"; then
            # Backup current settings
            if [[ -f "$SETTINGS_FILE" ]]; then
                cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
            fi
            
            # Update theme in settings.ini
            if [[ -f "$SETTINGS_FILE" ]]; then
                sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$new_theme/" "$SETTINGS_FILE"
                print_success "Updated theme to: $new_theme"
                reload_gtk_settings
            else
                print_error "Settings file not found. Creating new one..."
                mkdir -p "$GTK_CONFIG_DIR"
                cat > "$SETTINGS_FILE" << EOF
[Settings]
gtk-theme-name=$new_theme
gtk-icon-theme-name=BeautySolar
gtk-font-name=Maple Mono NF 11
gtk-cursor-theme-name=Future-cursors
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=0
EOF
                reload_gtk_settings
            fi
        else
            print_error "Theme validation failed. No changes made."
        fi
    else
        print_error "Themes directory not found: $HOME/.themes"
    fi
}

# Main script
main() {
    case "${1:-}" in
        "show"|"status")
            show_current_settings
            ;;
        "theme"|"change-theme")
            change_theme_interactive
            ;;
        "validate")
            CURRENT_THEME=$(grep "gtk-theme-name" "$SETTINGS_FILE" 2>/dev/null | cut -d'=' -f2)
            if [[ -n "$CURRENT_THEME" ]]; then
                validate_theme "$CURRENT_THEME"
            else
                print_error "No current theme found in settings"
            fi
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  (no command)  - Reload GTK-3.0 settings"
            echo "  show          - Show current GTK settings"
            echo "  theme         - Interactively change theme"
            echo "  validate      - Validate current theme exists"
            echo "  help          - Show this help message"
            echo ""
            echo "This script reloads GTK-3.0 applications after manual changes to settings.ini"
            ;;
        *)
            reload_gtk_settings
            ;;
    esac
}

# Run main function with all arguments
main "$@"
