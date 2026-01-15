#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- Colors ---
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

ZED_CONFIG_DIR="$HOME/.config/zed"
THEMES_DIR="$ZED_CONFIG_DIR/themes"
MATUGEN_DIR="$HOME/.config/matugen"
TEMPLATE_DIR="$MATUGEN_DIR/templates"
SETTINGS_FILE="$ZED_CONFIG_DIR/settings.json"
THEME_FILE="$THEMES_DIR/matugen.json"

echo -e "${BLUE}▶ STARTING ZED EDITOR SETUP...${RESET}"

# 1. INSTALL ZED
if ! command -v zed &>/dev/null; then
    echo -e "${BLUE}:: Installing Zed...${RESET}"
    if sudo pacman -S --needed --noconfirm zed; then
        echo -e "${GREEN}✔ Zed Installed${RESET}"
    else
        echo -e "${RED}[ERROR] Install failed.${RESET}"
        exit 1
    fi
fi

# 2. PREPARE DIRECTORIES
mkdir -p "$THEMES_DIR"
mkdir -p "$TEMPLATE_DIR"

# 3. INSTALL DEFAULT THEME
echo -e "${BLUE}:: Installing Default 'Matugen Dark' Theme...${RESET}"
cat << 'EOF' > "$THEME_FILE"
{
  "$schema": "https://zed.dev/schema/themes/v0.1.0.json",
  "name": "Matugen Dark",
  "author": "FxP",
  "themes": [
    {
      "name": "Matugen Dark",
      "appearance": "dark",
      "style": {
        "border": "#948f99",
        "border.variant": "#49454e",
        "border.focused": "#d2bcfd",
        "border.selected": "#d2bcfd",
        "border.transparent": null,
        "border.disabled": "#49454e",
        "elevated_surface.background": "#1d1b20",
        "surface.background": "#151218",
        "background": "#151218",
        "element.background": "#211f24",
        "element.hover": "#2b292f",
        "element.active": "#36343a",
        "element.selected": "#4b4358",
        "drop_target.background": "#36343a",
        "ghost_element.background": null,
        "ghost_element.hover": "#2b292f",
        "ghost_element.active": "#36343a",
        "ghost_element.selected": "#4b4358",
        "text": "#e7e0e8",
        "text.muted": "#cbc4cf",
        "text.placeholder": "#948f99",
        "text.disabled": "#49454e",
        "text.accent": "#d2bcfd",
        "icon": "#cbc4cf",
        "icon.muted": "#948f99",
        "icon.disabled": "#49454e",
        "icon.placeholder": "#49454e",
        "icon.accent": "#d2bcfd",
        "statusbar.background": "#211f24",
        "titlebar.background": "#151218",
        "toolbar.background": "#151218",
        "tab_bar.background": "#1d1b20",
        "tab.inactive_background": "#1d1b20",
        "tab.active_background": "#151218",
        "search.background": "#2b292f",
        "panel.background": "#1d1b20",
        "scrollbar.thumb.background": "#49454e",
        "scrollbar.thumb.hover_background": "#948f99",
        "scrollbar.track.background": "#151218",
        "scrollbar.track.border": "#49454e",
        "editor.background": "#151218",
        "editor.gutter.background": "#151218",
        "editor.subheader.background": "#211f24",
        "editor.active_line.background": "#211f24",
        "editor.highlighted_line.background": "#211f24",
        "editor.line_number": "#49454e",
        "editor.active_line_number": "#d2bcfd",
        "editor.invisible": "#49454e",
        "editor.wrap_guide": "#49454e",
        "editor.active_wrap_guide": "#948f99",
        "terminal.background": "#151218",
        "terminal.foreground": "#e7e0e8",
        "terminal.bright_foreground": "#e7e0e8",
        "terminal.dim_foreground": "#cbc4cf",
        "syntax": {
          "comment": { "color": "#948f99", "font_style": "italic" },
          "keyword": { "color": "#f0b7c5", "font_style": "normal" },
          "function": { "color": "#d2bcfd", "font_style": "normal" },
          "string": { "color": "#cdc2db", "font_style": "normal" },
          "type": { "color": "#f0b7c5", "font_style": "normal" },
          "number": { "color": "#cdc2db", "font_style": "normal" },
          "property": { "color": "#e7e0e8", "font_style": "normal" },
          "operator": { "color": "#cbc4cf", "font_style": "normal" },
          "variable": { "color": "#e7e0e8", "font_style": "normal" },
          "constant": { "color": "#f0b7c5", "font_style": "normal" }
        }
      }
    }
  ]
}
EOF

# 4. CREATE MATUGEN TEMPLATE
echo -e "${BLUE}:: Creating Matugen Template...${RESET}"
cat << 'EOF' > "$TEMPLATE_DIR/zed-colors.json"
{
  "$schema": "https://zed.dev/schema/themes/v0.1.0.json",
  "name": "Matugen Dark",
  "author": "FxP",
  "themes": [
    {
      "name": "Matugen Dark",
      "appearance": "dark",
      "style": {
        "border": "{{colors.outline.default.hex}}",
        "border.variant": "{{colors.outline_variant.default.hex}}",
        "border.focused": "{{colors.primary.default.hex}}",
        "border.selected": "{{colors.primary.default.hex}}",
        "border.transparent": null,
        "border.disabled": "{{colors.outline_variant.default.hex}}",
        "elevated_surface.background": "{{colors.surface_container_low.default.hex}}",
        "surface.background": "{{colors.background.default.hex}}",
        "background": "{{colors.background.default.hex}}",
        "element.background": "{{colors.surface_container.default.hex}}",
        "element.hover": "{{colors.surface_container_high.default.hex}}",
        "element.active": "{{colors.surface_container_highest.default.hex}}",
        "element.selected": "{{colors.secondary_container.default.hex}}",
        "drop_target.background": "{{colors.surface_container_highest.default.hex}}",
        "ghost_element.background": null,
        "ghost_element.hover": "{{colors.surface_container_high.default.hex}}",
        "ghost_element.active": "{{colors.surface_container_highest.default.hex}}",
        "ghost_element.selected": "{{colors.secondary_container.default.hex}}",
        "text": "{{colors.on_surface.default.hex}}",
        "text.muted": "{{colors.on_surface_variant.default.hex}}",
        "text.placeholder": "{{colors.outline.default.hex}}",
        "text.disabled": "{{colors.outline_variant.default.hex}}",
        "text.accent": "{{colors.primary.default.hex}}",
        "icon": "{{colors.on_surface_variant.default.hex}}",
        "icon.muted": "{{colors.outline.default.hex}}",
        "icon.disabled": "{{colors.outline_variant.default.hex}}",
        "icon.placeholder": "{{colors.outline_variant.default.hex}}",
        "icon.accent": "{{colors.primary.default.hex}}",
        "statusbar.background": "{{colors.surface_container.default.hex}}",
        "titlebar.background": "{{colors.background.default.hex}}",
        "toolbar.background": "{{colors.background.default.hex}}",
        "tab_bar.background": "{{colors.surface_container_low.default.hex}}",
        "tab.inactive_background": "{{colors.surface_container_low.default.hex}}",
        "tab.active_background": "{{colors.background.default.hex}}",
        "search.background": "{{colors.surface_container_high.default.hex}}",
        "panel.background": "{{colors.surface_container_low.default.hex}}",
        "scrollbar.thumb.background": "{{colors.outline_variant.default.hex}}",
        "scrollbar.thumb.hover_background": "{{colors.outline.default.hex}}",
        "scrollbar.track.background": "{{colors.background.default.hex}}",
        "scrollbar.track.border": "{{colors.outline_variant.default.hex}}",
        "editor.background": "{{colors.background.default.hex}}",
        "editor.gutter.background": "{{colors.background.default.hex}}",
        "editor.subheader.background": "{{colors.surface_container.default.hex}}",
        "editor.active_line.background": "{{colors.surface_container.default.hex}}",
        "editor.highlighted_line.background": "{{colors.surface_container.default.hex}}",
        "editor.line_number": "{{colors.outline_variant.default.hex}}",
        "editor.active_line_number": "{{colors.primary.default.hex}}",
        "editor.invisible": "{{colors.outline_variant.default.hex}}",
        "editor.wrap_guide": "{{colors.outline_variant.default.hex}}",
        "editor.active_wrap_guide": "{{colors.outline.default.hex}}",
        "terminal.background": "{{colors.background.default.hex}}",
        "terminal.foreground": "{{colors.on_surface.default.hex}}",
        "terminal.bright_foreground": "{{colors.on_surface.default.hex}}",
        "terminal.dim_foreground": "{{colors.on_surface_variant.default.hex}}",
        "syntax": {
          "comment": { "color": "{{colors.outline.default.hex}}", "font_style": "italic" },
          "keyword": { "color": "{{colors.tertiary.default.hex}}", "font_style": "normal" },
          "function": { "color": "{{colors.primary.default.hex}}", "font_style": "normal" },
          "string": { "color": "{{colors.secondary.default.hex}}", "font_style": "normal" },
          "type": { "color": "{{colors.tertiary.default.hex}}", "font_style": "normal" },
          "number": { "color": "{{colors.secondary.default.hex}}", "font_style": "normal" },
          "property": { "color": "{{colors.on_surface.default.hex}}", "font_style": "normal" },
          "operator": { "color": "{{colors.on_surface_variant.default.hex}}", "font_style": "normal" },
          "variable": { "color": "{{colors.on_surface.default.hex}}", "font_style": "normal" },
          "constant": { "color": "{{colors.tertiary.default.hex}}", "font_style": "normal" }
        }
      }
    }
  ]
}
EOF

# 5. CONFIGURE MATUGEN
echo -e "${BLUE}:: Configuring Matugen...${RESET}"
if ! grep -q "\[templates.zed\]" "$MATUGEN_DIR/config.toml"; then
    cat << 'EOF' >> "$MATUGEN_DIR/config.toml"

[templates.zed]
input_path = "~/.config/matugen/templates/zed-colors.json"
output_path = "~/.config/zed/themes/matugen.json"
EOF
fi

# 6. FORCE SETTINGS TO 'Matugen Dark' (AND DISABLE VIM MODE)
echo -e "${BLUE}:: Applying Settings...${RESET}"

if command -v jq &> /dev/null; then
    if [ -f "$SETTINGS_FILE" ]; then
        CLEAN_JSON=$(sed 's|//.*||g' "$SETTINGS_FILE")
        if echo "$CLEAN_JSON" | jq . >/dev/null 2>&1; then
            # Updates theme AND sets vim_mode to false
            echo "$CLEAN_JSON" | jq '."theme" = "Matugen Dark" | ."vim_mode" = false' > "$SETTINGS_FILE"
            echo -e "${GREEN}✔ Settings Updated${RESET}"
        else
            echo -e "${YELLOW}:: Settings invalid. Overwriting...${RESET}"
            echo '{"theme": "Matugen Dark", "vim_mode": false}' > "$SETTINGS_FILE"
        fi
    else
        echo '{"theme": "Matugen Dark", "vim_mode": false}' > "$SETTINGS_FILE"
        echo -e "${GREEN}✔ Settings Created${RESET}"
    fi
else
    echo -e "${RED}[WARN] 'jq' missing. Check settings manually.${RESET}"
fi

echo -e "${GREEN}✔ DONE!${RESET}"
