# ═══════════════════════════════════════════════════════════════════════════
# ~/.bashrc - Modern CLI Setup
# ═══════════════════════════════════════════════════════════════════════════

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ═══════════════════════════════════════════════════════════════════════════
# PATH
# ═══════════════════════════════════════════════════════════════════════════

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/.opencode/bin:$PATH"

# ═══════════════════════════════════════════════════════════════════════════
# ble.sh SHELL AUTOCOMPLETIONS
# ═══════════════════════════════════════════════════════════════════════════

# Auto-install ble.sh if not present
if [[ $- == *i* ]] && [[ ! -f ~/.local/share/blesh/ble.sh ]]; then
    echo "Installing ble.sh..."
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX=~/.local
    rm -rf /tmp/ble.sh
fi

# Load ble.sh (at TOP of file)
[[ $- == *i* ]] && [[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh



# ═══════════════════════════════════════════════════════════════════════════
# SHELL OPTIONS
# ═══════════════════════════════════════════════════════════════════════════

shopt -s histappend       # Append to history
shopt -s checkwinsize     # Update LINES/COLUMNS
shopt -s cdspell          # Autocorrect cd typos
shopt -s dirspell         # Autocorrect directory spelling
shopt -s autocd           # Type directory name to cd
shopt -s globstar         # Enable ** recursive glob
shopt -s nocaseglob       # Case-insensitive glob

# ═══════════════════════════════════════════════════════════════════════════
# HISTORY
# ═══════════════════════════════════════════════════════════════════════════

HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:exit:clear:history:ll:la"
HISTTIMEFORMAT="%F %T "

# ═══════════════════════════════════════════════════════════════════════════
# ENVIRONMENT
# ═══════════════════════════════════════════════════════════════════════════

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="TwoDark"

# ═══════════════════════════════════════════════════════════════════════════
# TOOL INITIALIZATIONS
# ═══════════════════════════════════════════════════════════════════════════

# Homebrew (platform-agnostic)
if command -v brew &>/dev/null; then
    eval "$(brew shellenv bash)"
elif [ -d "$HOME/.linuxbrew" ]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv bash)"
elif [ -d /opt/homebrew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv bash)"
fi

# Cargo/Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# fnm (Node version manager)
if [ -d "$HOME/.local/share/fnm" ]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"
fi

# uv (Python)
command -v uv &>/dev/null && eval "$(uv generate-shell-completion bash)"
command -v uvx &>/dev/null && eval "$(uvx --generate-shell-completion bash)"

# Atuin (shell history)
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
command -v atuin &>/dev/null && eval "$(atuin init bash)"

# Zoxide (smart cd)
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# Direnv (per-directory env)
command -v direnv &>/dev/null && eval "$(direnv hook bash)"

# fzf (platform-agnostic)
for fzf_path in /usr/share/fzf/shell /usr/local/opt/fzf/shell ~/.fzf/shell; do
    [[ -f "$fzf_path/key-bindings.bash" ]] && source "$fzf_path/key-bindings.bash" && break
done
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# envman
[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"

# Bash completions (platform-agnostic)
for bc_path in /usr/share/bash-completion/bash_completion \
                /usr/local/share/bash-completion/bash_completion \
                /opt/homebrew/etc/profile.d/bash_completion.sh; do
    [[ -f "$bc_path" ]] && source "$bc_path" && break
done

# Source additional configs
# Also source from dotfiles if ~/.bashrc.d doesn't exist locally
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [[ -f "$rc" ]] && . "$rc"
    done
elif [ -d ~/.dotfiles/bash/.bashrc.d ]; then
    for rc in ~/.dotfiles/bash/.bashrc.d/*; do
        [[ -f "$rc" ]] && . "$rc"
    done
fi
unset rc

# ═══════════════════════════════════════════════════════════════════════════
# STANDARD TOOL REPLACEMENTS
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# ls → eza
# ─────────────────────────────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias l='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
    alias lta='eza --tree --icons --level=2 -a'
    alias ltl='eza --tree --icons --level=3'
    alias l.='eza -d .* --icons'
    alias lS='eza -l --icons --sort=size --reverse'
    alias lm='eza -l --icons --sort=modified'
    alias lr='eza -l --icons --sort=modified --reverse'
fi

# ─────────────────────────────────────────────────────────────────────────────
# cat → bat
# ─────────────────────────────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catn='bat --paging=never'
    alias catp='bat --plain'
    alias catl='bat'
    alias bathelp='bat --plain --language=help'
    help() { "$@" --help 2>&1 | bathelp; }
fi

# ─────────────────────────────────────────────────────────────────────────────
# grep → ripgrep
# ─────────────────────────────────────────────────────────────────────────────
if command -v rg &>/dev/null; then
    alias grep='rg'
    alias rgi='rg -i'
    alias rgl='rg -l'
    alias rgf='rg -F'
    alias rgh='rg --hidden'
    alias rgn='rg --no-ignore'
    alias rga='rg --hidden --no-ignore'
    alias rgc='rg --count'
    alias rgw='rg -w'
fi

# ripgrep-all (grep PDFs, zips, etc)
command -v rga &>/dev/null && alias grpa='rga'

# pdfgrep
command -v pdfgrep &>/dev/null && alias pgrep='pdfgrep'

# ─────────────────────────────────────────────────────────────────────────────
# find → fd
# ─────────────────────────────────────────────────────────────────────────────
if command -v fd &>/dev/null; then
    alias find='fd'
    alias fda='fd -H -I'
    alias fdf='fd -t f'
    alias fdd='fd -t d'
    alias fdx='fd -t x'
    alias fde='fd -e'
    alias fdl='fd -t l'
fi

# ─────────────────────────────────────────────────────────────────────────────
# du → dust
# ─────────────────────────────────────────────────────────────────────────────
if command -v dust &>/dev/null; then
    alias du='dust'
    alias dud='dust -d 1'
    alias dus='dust -s'
    alias dub='dust -b'
fi
command -v ncdu &>/dev/null && alias ncdu='ncdu --color dark'

# ─────────────────────────────────────────────────────────────────────────────
# df → duf
# ─────────────────────────────────────────────────────────────────────────────
if command -v duf &>/dev/null; then
    alias df='duf'
    alias dfl='duf --only local'
    alias dfm='duf --only mounted'
fi

# ─────────────────────────────────────────────────────────────────────────────
# top → btop/btm
# ─────────────────────────────────────────────────────────────────────────────
if command -v btop &>/dev/null; then
    alias top='btop'
    alias htop='btop'
elif command -v btm &>/dev/null; then
    alias top='btm'
    alias htop='btm'
fi
command -v glances &>/dev/null && alias gtop='glances'

# ─────────────────────────────────────────────────────────────────────────────
# ps → procs
# ─────────────────────────────────────────────────────────────────────────────
if command -v procs &>/dev/null; then
    alias ps='procs'
    alias psa='procs -a'
    alias pst='procs --tree'
    alias psw='procs --watch'
    alias psc='procs --sortd cpu'
    alias psm='procs --sortd mem'
    alias psk='procs --kill'
fi

# ─────────────────────────────────────────────────────────────────────────────
# sed → sd
# ─────────────────────────────────────────────────────────────────────────────
command -v sd &>/dev/null && alias sed='sd'

# ─────────────────────────────────────────────────────────────────────────────
# diff → delta/difftastic
# ─────────────────────────────────────────────────────────────────────────────
if command -v delta &>/dev/null; then
    alias diff='delta'
elif command -v difft &>/dev/null; then
    alias diff='difft'
fi

# ─────────────────────────────────────────────────────────────────────────────
# man → tldr
# ─────────────────────────────────────────────────────────────────────────────
if command -v tldr &>/dev/null; then
    alias tl='tldr'
    alias tlf='tldr --list | fzf --preview "tldr {}" | xargs tldr'
fi

# ─────────────────────────────────────────────────────────────────────────────
# curl → xh/httpie
# ─────────────────────────────────────────────────────────────────────────────
if command -v xh &>/dev/null; then
    alias http='xh'
    alias https='xh --https'
    alias httpd='xh --download'
    alias httpj='xh --json'
elif command -v http &>/dev/null; then
    alias https='http --default-scheme=https'
fi

# ─────────────────────────────────────────────────────────────────────────────
# dig → dog/drill
# ─────────────────────────────────────────────────────────────────────────────
if command -v dog &>/dev/null; then
    alias dig='dog'
elif command -v drill &>/dev/null; then
    alias dig='drill'
fi

# ─────────────────────────────────────────────────────────────────────────────
# hexdump → hexyl
# ─────────────────────────────────────────────────────────────────────────────
if command -v hexyl &>/dev/null; then
    alias hexdump='hexyl'
    alias hex='hexyl'
fi

# ─────────────────────────────────────────────────────────────────────────────
# traceroute → mtr
# ─────────────────────────────────────────────────────────────────────────────
command -v mtr &>/dev/null && alias traceroute='mtr'

# ─────────────────────────────────────────────────────────────────────────────
# locate → plocate
# ─────────────────────────────────────────────────────────────────────────────
command -v plocate &>/dev/null && alias locate='plocate'

# ═══════════════════════════════════════════════════════════════════════════
# INTERACTIVE TOOLS
# ═══════════════════════════════════════════════════════════════════════════

# Git interfaces
command -v lazygit &>/dev/null && alias lg='lazygit'
command -v tig &>/dev/null && alias tg='tig'

# Docker/Podman interfaces
command -v lazydocker &>/dev/null && alias lzd='lazydocker'
command -v ctop &>/dev/null && alias ctop='ctop'

# File managers
command -v yazi &>/dev/null && alias fm='yazi'
command -v ranger &>/dev/null && alias ra='ranger'
command -v nnn &>/dev/null && alias n='nnn -de'
command -v broot &>/dev/null && alias br='broot'

# Markdown viewer
command -v glow &>/dev/null && alias md='glow'
command -v mdp &>/dev/null && alias mdp='mdp'

# ═══════════════════════════════════════════════════════════════════════════
# JSON/YAML/CSV TOOLS
# ═══════════════════════════════════════════════════════════════════════════

# jq - JSON
if command -v jq &>/dev/null; then
    alias jqc='jq -C'       # Colorized output
    alias jqr='jq -r'       # Raw output
    alias jqs='jq -S'       # Sort keys
    alias jqk='jq keys'     # Get keys
fi

# jless - JSON pager
command -v jless &>/dev/null && alias jl='jless'

# fx - Interactive JSON
command -v fx &>/dev/null && alias fxj='fx'

# gron - Make JSON greppable
command -v gron &>/dev/null && alias gron='gron'

# jo - Create JSON
command -v jo &>/dev/null && alias jo='jo'

# jc - Convert output to JSON
command -v jc &>/dev/null && alias jc='jc'

# yq - YAML
if command -v yq &>/dev/null; then
    alias yqr='yq -r'
    alias yqc='yq -C'
fi

# xsv - CSV
if command -v xsv &>/dev/null; then
    alias csvh='xsv headers'
    alias csvs='xsv select'
    alias csvf='xsv search'
    alias csvt='xsv table'
    alias csvc='xsv count'
    alias csvj='xsv join'
fi

# miller - CSV/JSON/TSV swiss army knife
command -v mlr &>/dev/null && alias mlr='mlr --csv'

# visidata - Interactive tabular data
command -v vd &>/dev/null && alias vd='vd'

# htmlq - jq for HTML
command -v htmlq &>/dev/null && alias hq='htmlq'

# fq - jq for binary
command -v fq &>/dev/null && alias fq='fq'

# ═══════════════════════════════════════════════════════════════════════════
# UTILITIES
# ═══════════════════════════════════════════════════════════════════════════

# Clipboard (Wayland)
if command -v wl-copy &>/dev/null; then
    alias copy='wl-copy'
    alias paste='wl-paste'
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
fi

# Benchmarking
command -v hyperfine &>/dev/null && alias bench='hyperfine'

# File transfer
command -v croc &>/dev/null && alias send='croc send'
command -v wormhole &>/dev/null && alias wh='wormhole'

# Watch files and run commands
command -v entr &>/dev/null && alias watch='entr'

# Pipe viewer (progress bar)
command -v pv &>/dev/null && alias pv='pv'

# Batch rename files in vim
command -v vidir &>/dev/null && alias vr='vidir'

# Terminal sharing
command -v tmate &>/dev/null && alias tm='tmate'

# Log viewer
command -v lnav &>/dev/null && alias lnav='lnav'

# choose (awk/cut replacement)
command -v choose &>/dev/null && alias choose='choose'

# thefuck (autocorrect)
command -v thefuck &>/dev/null && eval "$(thefuck --alias fuck)"

# ═══════════════════════════════════════════════════════════════════════════
# GIT ALIASES
# ═══════════════════════════════════════════════════════════════════════════

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add -p'
alias gs='git status -s'
alias gst='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --stat'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v --amend'
alias gcn='git commit -v --amend --no-edit'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gl='git pull'
alias glr='git pull --rebase'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias glog='git log --oneline --graph --decorate'
alias gloga='git log --oneline --graph --decorate --all'
alias glogp='git log -p'
alias gss='git stash'
alias gsp='git stash pop'
alias gsl='git stash list'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtl='git worktree list'

# ═══════════════════════════════════════════════════════════════════════════
# PODMAN/DOCKER ALIASES
# ═══════════════════════════════════════════════════════════════════════════

if command -v podman &>/dev/null; then
    alias p='podman'
    alias pps='podman ps'
    alias ppsa='podman ps -a'
    alias pi='podman images'
    alias pr='podman run'
    alias pri='podman run -it'
    alias prm='podman rm'
    alias prmi='podman rmi'
    alias pl='podman logs'
    alias plf='podman logs -f'
    alias pex='podman exec -it'
    alias pb='podman build'
    alias pbt='podman build -t'
    alias pstop='podman stop'
    alias pprune='podman system prune -af'
    alias pc='podman compose'
    alias pcu='podman compose up'
    alias pcud='podman compose up -d'
    alias pcd='podman compose down'
    alias pcl='podman compose logs -f'
fi

# Docker (if using docker instead)
if command -v docker &>/dev/null && ! command -v podman &>/dev/null; then
    alias d='docker'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dr='docker run'
    alias dri='docker run -it'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dl='docker logs'
    alias dlf='docker logs -f'
    alias dex='docker exec -it'
    alias db='docker build'
    alias dbt='docker build -t'
    alias dstop='docker stop'
    alias dprune='docker system prune -af'
    alias dc='docker compose'
    alias dcu='docker compose up'
    alias dcud='docker compose up -d'
    alias dcd='docker compose down'
    alias dcl='docker compose logs -f'
fi

# Distrobox
if command -v distrobox &>/dev/null; then
    alias db='distrobox'
    alias dbe='distrobox enter'
    alias dbc='distrobox create'
    alias dbl='distrobox list'
    alias dbr='distrobox rm'
    alias dbs='distrobox stop'
fi

# ═══════════════════════════════════════════════════════════════════════════
# SYSTEM ALIASES (Distro-Agnostic)
# ═══════════════════════════════════════════════════════════════════════════

# Package manager aliases are loaded from ~/.bashrc.d/package-manager.sh

# Flatpak
alias fp='flatpak'
alias fpi='flatpak install'
alias fps='flatpak search'
alias fpu='flatpak update'
alias fpr='flatpak uninstall'
alias fpl='flatpak list'

# Systemctl
alias sc='sudo systemctl'
alias scs='sudo systemctl status'
alias scstart='sudo systemctl start'
alias scstop='sudo systemctl stop'
alias screstart='sudo systemctl restart'
alias scenable='sudo systemctl enable'
alias scdisable='sudo systemctl disable'
alias sclog='journalctl -u'

# ═══════════════════════════════════════════════════════════════════════════
# NAVIGATION ALIASES
# ═══════════════════════════════════════════════════════════════════════════

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'
alias dl='cd ~/Downloads'
alias doc='cd ~/Documents'
alias proj='cd ~/Projects'
alias dot='cd ~/.dotfiles'

# ═══════════════════════════════════════════════════════════════════════════
# CONVENIENCE ALIASES
# ═══════════════════════════════════════════════════════════════════════════

# Quick edits
alias bashrc='$EDITOR ~/.bashrc'
alias starrc='$EDITOR ~/.config/starship.toml'
alias gitrc='$EDITOR ~/.gitconfig'

# Reload shell
alias reload='source ~/.bashrc'
alias rl='source ~/.bashrc'

# Quick exit
alias q='exit'
alias :q='exit'
alias cls='clear'

# History
alias h='history'
alias hs='history | rg'

# Jobs
alias j='jobs -l'

# Network
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me'
alias localip='hostname -I | cut -d" " -f1'

# Date/time
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias utc='date -u'

# Path
alias path='echo $PATH | tr ":" "\n"'

# Safety nets
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias ln='ln -i'

# Editors
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

# Misc
alias c='clear'
alias e='exit'
alias x='exit'
alias tree='eza --tree --icons'
alias wget='wget -c'  # Resume by default

# ═══════════════════════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.tar.xz) tar xJf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *.zst) unzstd "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# cd to git root
grt() { cd "$(git rev-parse --show-toplevel)" 2>/dev/null || echo "Not in a git repo"; }

# Backup a file with timestamp
backup() { cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"; }

# Find and replace in files
replace() {
    if [ $# -ne 3 ]; then
        echo "Usage: replace 'pattern' 'replacement' 'file_pattern'"
        return 1
    fi
    fd "$3" -x sd "$1" "$2" {}
}

# Quick HTTP server
serve() { python3 -m http.server "${1:-8000}"; }

# Weather
weather() { curl "wttr.in/${1:-}"; }

# Cheatsheet
cheat() { curl "cheat.sh/$1"; }

# ═══════════════════════════════════════════════════════════════════════════
# FZF CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS='
        --height=40%
        --layout=reverse
        --border
        --info=inline
        --preview "bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}"
        --preview-window=right:50%:hidden
        --bind="ctrl-/:toggle-preview"
        --bind="ctrl-y:execute-silent(echo -n {} | wl-copy)"
    '

    # fzf + cd
    fcd() { cd "$(fd --type d | fzf --preview 'eza --tree --level=1 {}')" || return; }

    # fzf + vim
    fv() { nvim "$(fzf --preview 'bat --style=numbers --color=always {}')" || return; }

    # fzf + kill process
    fkill() {
        local pid
        pid=$(procs | fzf --header-lines=1 | awk '{print $1}')
        [ -n "$pid" ] && kill -9 "$pid"
    }

    # fzf + git log
    fgl() {
        git log --oneline --graph --color=always | fzf --ansi --preview 'git show --color=always {1}'
    }

    # fzf + git branch
    fgb() {
        git branch -a --color=always | fzf --ansi | sed 's/^[* ]*//' | xargs git checkout
    }
fi

# ═══════════════════════════════════════════════════════════════════════════
# PROMPT (Starship - must be at the end)
# ═══════════════════════════════════════════════════════════════════════════

eval "$(starship init bash)"


# ═══════════════════════════════════════════════════════════════════════════
# ble.sh SHELL AUTOCOMPLETIONS
# ═══════════════════════════════════════════════════════════════════════════

[[ ${BLE_VERSION-} ]] && ble-attach

# pnpm
export PNPM_HOME="/home/red/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# fnm
FNM_PATH="/home/red/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell bash)"
fi
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"
