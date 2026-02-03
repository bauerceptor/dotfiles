#!/bin/bash
# switch-theme.sh - Flexible theme switcher for individual tools
# Apply different themes to different tools independently

set -e

DOTFILES="$HOME/.dotfiles"
THEMES_DIR="$DOTFILES/themes"
SCHEMES_DIR="$THEMES_DIR/schemes"
CONVERTERS_DIR="$THEMES_DIR/converters"
GENERATED_DIR="$THEMES_DIR/generated"

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Show usage
show_usage() {
    cat << EOF
$(print_color "$CYAN" "🎨 Theme Switcher")
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage:
  $(basename "$0") list                    # List available themes
  $(basename "$0") show                    # Show current themes per tool
  $(basename "$0") <theme> <tool>          # Apply theme to specific tool
  $(basename "$0") <theme> all             # Apply theme to all tools

Tools:
  alacritty    - Alacritty terminal
  ghostty      - Ghostty terminal
  all          - Apply to all supported tools

Examples:
  $(basename "$0") sakura-dark alacritty   # Set Alacritty to Sakura Dark
  $(basename "$0") nord ghostty            # Set Ghostty to Nord
  $(basename "$0") gruvbox-dark all        # Set all tools to Gruvbox Dark

EOF
}

# List available themes
list_themes() {
    print_color "$CYAN" "\n📚 Available Themes:"
    print_color "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    for theme_file in "$SCHEMES_DIR"/*.toml; do
        if [ -f "$theme_file" ]; then
            theme_name=$(basename "$theme_file" .toml)

            # Read theme metadata using Python
            meta=$(python3 << EOF
import tomllib
with open('$theme_file', 'rb') as f:
    theme = tomllib.load(f)
    print(f"{theme['meta']['name']} - {theme['meta']['variant']} - {theme['meta']['description']}")
EOF
)
            print_color "$GREEN" "  • $theme_name"
            print_color "$NC" "    $meta"
        fi
    done
    echo ""
}

# Show current themes for each tool
show_current_themes() {
    print_color "$CYAN" "\n🎨 Current Themes:"
    print_color "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Check Alacritty
    if [ -L "$HOME/.config/alacritty/colors.toml" ]; then
        alacritty_theme=$(readlink "$HOME/.config/alacritty/colors.toml" | xargs basename)
        print_color "$GREEN" "  Alacritty: $alacritty_theme (generated)"
    else
        print_color "$YELLOW" "  Alacritty: Using inline theme (not managed by central system)"
    fi

    # Check Ghostty
    if [ -f "$HOME/.config/ghostty/theme-active" ]; then
        print_color "$GREEN" "  Ghostty: theme-active (generated)"
    else
        print_color "$YELLOW" "  Ghostty: Using theme from config (not managed by central system)"
    fi

    echo ""
}

# Apply theme to Alacritty
apply_alacritty() {
    local theme_file=$1
    local output_file="$GENERATED_DIR/alacritty-$(basename "$theme_file")"

    print_color "$BLUE" "  → Generating Alacritty config..."
    python3 "$CONVERTERS_DIR/to_alacritty.py" "$theme_file" > "$output_file"

    # Create or update symlink
    mkdir -p "$HOME/.config/alacritty"
    ln -sf "$output_file" "$HOME/.config/alacritty/colors.toml"

    print_color "$GREEN" "  ✓ Alacritty theme applied"
}

# Apply theme to Ghostty
apply_ghostty() {
    local theme_file=$1
    local output_file="$GENERATED_DIR/ghostty-$(basename "$theme_file")"

    print_color "$BLUE" "  → Generating Ghostty config..."
    python3 "$CONVERTERS_DIR/to_ghostty.py" "$theme_file" > "$output_file"

    # Create or update symlink
    mkdir -p "$HOME/.config/ghostty"
    ln -sf "$output_file" "$HOME/.config/ghostty/theme-active"

    print_color "$GREEN" "  ✓ Ghostty theme applied"
}

# Main logic
case "${1:-}" in
    list)
        list_themes
        exit 0
        ;;
    show)
        show_current_themes
        exit 0
        ;;
    "")
        show_usage
        exit 0
        ;;
    *)
        THEME_NAME="$1"
        TOOL="${2:-}"

        if [ -z "$TOOL" ]; then
            print_color "$RED" "❌ Error: Tool not specified"
            echo ""
            show_usage
            exit 1
        fi

        # Find theme file
        THEME_FILE="$SCHEMES_DIR/${THEME_NAME}.toml"

        if [ ! -f "$THEME_FILE" ]; then
            print_color "$RED" "❌ Error: Theme not found: $THEME_NAME"
            echo ""
            print_color "$YELLOW" "Available themes:"
            list_themes
            exit 1
        fi

        # Create generated directory if it doesn't exist
        mkdir -p "$GENERATED_DIR"

        print_color "$CYAN" "\n🎨 Applying theme: $THEME_NAME"
        print_color "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""

        # Apply to specific tool or all
        case "$TOOL" in
            alacritty)
                apply_alacritty "$THEME_FILE"
                ;;
            ghostty)
                apply_ghostty "$THEME_FILE"
                ;;
            all)
                apply_alacritty "$THEME_FILE"
                apply_ghostty "$THEME_FILE"
                ;;
            *)
                print_color "$RED" "❌ Error: Unknown tool: $TOOL"
                echo ""
                print_color "$YELLOW" "Supported tools: alacritty, ghostty, all"
                exit 1
                ;;
        esac

        echo ""
        print_color "$GREEN" "✨ Theme applied successfully!"
        print_color "$YELLOW" "📝 Note: Restart your terminals to see changes"
        echo ""
        ;;
esac
