#!/bin/bash
# check-deps.sh - Verify required tools are installed

echo "🔍 Checking Dependencies"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Core tools
CORE_TOOLS=(
    "git"
    "stow"
    "curl"
    "wget"
)

# Modern CLI tools
CLI_TOOLS=(
    "fish"
    "eza"
    "bat"
    "fd"
    "rg"
    "fzf"
    "zoxide"
    "starship"
    "direnv"
    "atuin"
    "delta"
    "sd"
    "dust"
    "duf"
    "btop"
    "procs"
    "hyperfine"
    "tldr"
    "jq"
    "yq"
    "xh"
    "glow"
    "lazygit"
    "tokei"
    "hexyl"
    "gh"
)

# Editors
EDITORS=(
    "nvim"
    "helix"
    "zed"
    "code"
)

check_command() {
    local cmd=$1
    if command -v "$cmd" &>/dev/null; then
        echo "✓ $cmd"
        return 0
    else
        echo "✗ $cmd (missing)"
        return 1
    fi
}

# Check core tools
echo "Core Tools:"
echo "───────────"
MISSING_CORE=0
for tool in "${CORE_TOOLS[@]}"; do
    check_command "$tool" || ((MISSING_CORE++))
done

echo ""
echo "Modern CLI Tools:"
echo "─────────────────"
MISSING_CLI=0
for tool in "${CLI_TOOLS[@]}"; do
    check_command "$tool" || ((MISSING_CLI++))
done

echo ""
echo "Editors:"
echo "────────"
MISSING_EDITORS=0
for tool in "${EDITORS[@]}"; do
    check_command "$tool" || ((MISSING_EDITORS++))
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TOTAL_MISSING=$((MISSING_CORE + MISSING_CLI + MISSING_EDITORS))

if [ $MISSING_CORE -gt 0 ]; then
    echo "❌ Missing $MISSING_CORE core tool(s)"
    echo "   Run: ./scripts/bootstrap.sh"
else
    echo "✅ All core tools installed"
fi

if [ $MISSING_CLI -gt 0 ]; then
    echo "⚠️  Missing $MISSING_CLI CLI tool(s) (optional)"
else
    echo "✅ All CLI tools installed"
fi

if [ $MISSING_EDITORS -gt 0 ]; then
    echo "⊙ Missing $MISSING_EDITORS editor(s) (optional)"
else
    echo "✅ All editors installed"
fi

echo ""

if [ $TOTAL_MISSING -eq 0 ]; then
    echo "🎉 All dependencies satisfied!"
    exit 0
else
    echo "📝 Total missing: $TOTAL_MISSING"
    if [ $MISSING_CORE -gt 0 ]; then
        echo "   ⚠️  Missing core dependencies! Run bootstrap.sh"
        exit 1
    else
        echo "   ℹ️  Missing optional tools"
        exit 0
    fi
fi
