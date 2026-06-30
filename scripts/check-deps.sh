#!/bin/bash
# check-deps.sh - Verify installed dependencies

set -euo pipefail

check_binary() {
    local name=$1
    local binary=${2:-$1}
    if command -v "$binary" &>/dev/null; then
        echo "  ✓ $name"
        return 0
    else
        echo "  ✗ $name"
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Checking dependencies"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Core tools:"
CORE_OK=true
for tool in git stow curl wget unzip fc-list fc-cache; do
    check_binary "$tool" || CORE_OK=false
done

echo ""
echo "Modern CLI tools:"
CLI_OK=true
for tool in fish eza bat fd rg fzf zoxide starship direnv atuin delta sd dust duf btop procs hyperfine tldr jq yq xh glow lazygit tokei hexyl gh neovim distrobox zellij; do
    case "$tool" in
        rg) binary="rg" ;;
        tldr) binary="tldr" ;;
        fd) binary="fd" ;;
        gh) binary="gh" ;;
        *) binary="$tool" ;;
    esac
    check_binary "$tool" "$binary" || CLI_OK=false
done

echo ""
echo "Editors:"
EDITORS_OK=true
for tool in nvim helix zed code codium; do
    check_binary "$tool" || EDITORS_OK=false
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$CORE_OK" = false ]; then
    echo "❌ Core tools missing. Run ./scripts/bootstrap.sh"
    exit 1
elif [ "$CLI_OK" = false ] || [ "$EDITORS_OK" = false ]; then
    echo "⚠️  Some optional tools/editors missing. Run ./scripts/bootstrap.sh"
    exit 0
else
    echo "✅ All dependencies present!"
    exit 0
fi
