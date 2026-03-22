# =============================================================================
# Modern Fish Shell Configuration
# Fedora 43 | Fish 4.2.0+
# =============================================================================

# Auto-install Fisher + plugins on new machine
if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
end

# Homebrew (platform-agnostic)
if command -v brew &>/dev/null
    eval (brew shellenv)
else if test -d "$HOME/.linuxbrew"
    eval ($HOME/.linuxbrew/bin/brew shellenv)
else if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
end

# SSH Agent
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) > /dev/null
end

# mise activation (add near top, before other tools)
if type -q mise
    mise activate fish | source
end


if status is-interactive
    # =========================================================================
    # Tool Initializations (order matters!)
    # =========================================================================

    # Zoxide (smarter cd) - replaces z/autojump
    if type -q zoxide
        zoxide init fish | source
    end

    # Direnv (per-project environment variables)
    if type -q direnv
        direnv hook fish | source
    end

    # Atuin (magical shell history) - only bind Ctrl+R, keep arrow keys native
    if type -q atuin
        set -gx ATUIN_NOBIND "true"
        atuin init fish | source
        bind \cr _atuin_search
        bind -M insert \cr _atuin_search
    end

    # =========================================================================
    # FZF Configuration
    # =========================================================================
    if type -q fzf
        # Use fd for fzf if available
        if type -q fd
            set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
            set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
            set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
        end

        # FZF appearance
        set -gx FZF_DEFAULT_OPTS "\
            --height 40% \
            --layout=reverse \
            --border \
            --info=inline \
            --marker='✓' \
            --pointer='▶' \
            --prompt='∷ '"

        # Use bat for preview if available
        if type -q bat
            set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
        end

        # Use eza for directory preview if available
        if type -q eza
            set -gx fzf_preview_dir_cmd 'eza --all --color=always --icons'
        end

        # Use delta for git diff preview
        if type -q delta
            set -gx fzf_diff_highlighter delta --paging=never --width=20
        end
    end

    # =========================================================================
    # Environment Variables
    # =========================================================================

    # Editor
    if type -q nvim
        set -gx EDITOR nvim
        set -gx VISUAL nvim
    else if type -q vim
        set -gx EDITOR vim
        set -gx VISUAL vim
    end

    # Pager
    if type -q bat
        set -gx PAGER "bat --style=plain"
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    else
        set -gx PAGER less
    end

    # LS_COLORS using vivid if available
    if type -q vivid
        set -gx LS_COLORS (vivid generate molokai)
    end

    # Git
    if type -q delta
        set -gx GIT_PAGER delta
    end

    # Ripgrep config
    set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/config"

    # =========================================================================
    # PATH additions
    # =========================================================================

    # Local binaries
    fish_add_path -g "$HOME/.local/bin"
    fish_add_path -g "$HOME/bin"

    # Rust/Cargo
    fish_add_path -g "$HOME/.cargo/bin"

    # Go
    if test -d "$HOME/go/bin"
        fish_add_path -g "$HOME/go/bin"
        set -gx GOPATH "$HOME/go"
    end

    # Ruby gems
    if test -d "$HOME/.local/share/gem/ruby"
        for dir in $HOME/.local/share/gem/ruby/*/bin
            fish_add_path -g $dir
        end
    end

    # =========================================================================
    # Disable greeting
    # =========================================================================
    set -g fish_greeting
end

# pnpm (platform-agnostic)
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$HOME/.local/share/fnm"
