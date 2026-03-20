# =============================================================================
# Modern CLI Abbreviations
# Organized by category for easy maintenance
# =============================================================================

if status is-interactive
    # =========================================================================
    # Modern Tool Replacements
    # =========================================================================
    
    # eza (modern ls) - https://github.com/eza-community/eza
    if type -q eza
        abbr -a l 'eza --icons --group-directories-first'
        abbr -a ls 'eza --icons --group-directories-first'
        abbr -a la 'eza -la --icons --group-directories-first'
        abbr -a ll 'eza -l --icons --group-directories-first'
        abbr -a lt 'eza --tree --icons --level=2'
        abbr -a lta 'eza --tree --icons --level=2 -a'
        abbr -a tree 'eza --tree --icons'
    end
    
    # bat (modern cat) - https://github.com/sharkdp/bat
    if type -q bat
        abbr -a cat bat
        abbr -a catp 'bat -p'  # plain, no line numbers
    end
    
    # fd (modern find) - https://github.com/sharkdp/fd
    if type -q fd
        abbr -a find fd
    end
    
    # ripgrep (modern grep) - https://github.com/BurntSushi/ripgrep
    if type -q rg
        abbr -a grep rg
        abbr -a rgi 'rg -i'  # case insensitive
        abbr -a rgl 'rg -l'  # files only
    end
    
    # sd (modern sed) - https://github.com/chmln/sd
    if type -q sd
        abbr -a sed sd
    end
    
    # dust (modern du) - https://github.com/bootandy/dust
    if type -q dust
        abbr -a du dust
        abbr -a dud 'dust -d 1'
    end
    
    # duf (modern df) - https://github.com/muesli/duf
    if type -q duf
        abbr -a df duf
    end
    
    # btop (modern top) - https://github.com/aristocratos/btop
    if type -q btop
        abbr -a top btop
        abbr -a htop btop
    end
    
    # procs (modern ps) - https://github.com/dalance/procs
    if type -q procs
        abbr -a ps procs
    end
    
    # xh (modern curl) - https://github.com/ducaale/xh
    if type -q xh
        abbr -a http xh
        abbr -a https 'xh --https'
    end
    
    # tldr via tealdeer
    if type -q tldr
        abbr -a help tldr
    end
    
    # glow (markdown viewer)
    if type -q glow
        abbr -a md glow
    end
    
    # =========================================================================
    # Navigation
    # =========================================================================
    
    # Zoxide (smart cd)
    if type -q zoxide
        abbr -a cd z
        abbr -a cdi zi  # interactive
    end
    
    # Quick navigation
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
    abbr -a -- - 'cd -'
    
    # Common directories
    abbr -a dl 'cd ~/Downloads'
    abbr -a doc 'cd ~/Documents'
    abbr -a proj 'cd ~/Projects'
    abbr -a dot 'cd ~/.dotfiles'
    
    # =========================================================================
    # Git - Comprehensive shortcuts
    # =========================================================================
    
    if type -q git
        # Basics
        abbr -a g git
        abbr -a ga 'git add'
        abbr -a gaa 'git add --all'
        abbr -a gap 'git add -p'  # patch mode
        
        # Status & Diff
        abbr -a gs 'git status -s'
        abbr -a gst 'git status'
        abbr -a gd 'git diff'
        abbr -a gdc 'git diff --cached'
        abbr -a gds 'git diff --stat'
        
        # Commits
        abbr -a gc 'git commit -v'
        abbr -a gcm 'git commit -m'
        abbr -a gca 'git commit -v --amend'
        abbr -a gcn 'git commit -v --amend --no-edit'
        
        # Branches
        abbr -a gb 'git branch'
        abbr -a gba 'git branch -a'
        abbr -a gbd 'git branch -d'
        abbr -a gbD 'git branch -D'
        abbr -a gco 'git checkout'
        abbr -a gcb 'git checkout -b'
        abbr -a gsw 'git switch'
        abbr -a gswc 'git switch -c'
        
        # Remote
        abbr -a gf 'git fetch'
        abbr -a gfa 'git fetch --all --prune'
        abbr -a gl 'git pull'
        abbr -a glr 'git pull --rebase'
        abbr -a gp 'git push'
        abbr -a gpf 'git push --force-with-lease'
        abbr -a gpsup 'git push --set-upstream origin (git branch --show-current)'
        
        # Log
        abbr -a glog 'git log --oneline --graph --decorate'
        abbr -a gloga 'git log --oneline --graph --decorate --all'
        abbr -a glogp 'git log -p'
        
        # Stash
        abbr -a gss 'git stash'
        abbr -a gsp 'git stash pop'
        abbr -a gsl 'git stash list'
        
        # Rebase
        abbr -a grb 'git rebase'
        abbr -a grbi 'git rebase -i'
        abbr -a grbc 'git rebase --continue'
        abbr -a grba 'git rebase --abort'
        
        # Reset
        abbr -a grh 'git reset HEAD'
        abbr -a grhh 'git reset HEAD --hard'
        
        # Cleanup
        abbr -a gclean 'git clean -fd'
        abbr -a gpristine 'git reset --hard && git clean -dfx'
        
        # Worktree
        abbr -a gwt 'git worktree'
        abbr -a gwta 'git worktree add'
        abbr -a gwtl 'git worktree list'
    end
    
    # Lazygit
    if type -q lazygit
        abbr -a lg lazygit
    end
    
    # GitHub CLI
    if type -q gh
        abbr -a ghpr 'gh pr'
        abbr -a ghprc 'gh pr create'
        abbr -a ghprv 'gh pr view --web'
        abbr -a ghprl 'gh pr list'
        abbr -a ghprco 'gh pr checkout'
        abbr -a ghis 'gh issue'
        abbr -a ghisc 'gh issue create'
        abbr -a ghisl 'gh issue list'
        abbr -a ghrun 'gh run list'
        abbr -a ghrunw 'gh run watch'
        abbr -a ghrepo 'gh repo view --web'
    end
    
    # =========================================================================
    # Rust Development
    # =========================================================================
    
    if type -q cargo
        abbr -a c cargo
        abbr -a cb 'cargo build'
        abbr -a cbr 'cargo build --release'
        abbr -a cr 'cargo run'
        abbr -a crr 'cargo run --release'
        abbr -a ct 'cargo test'
        abbr -a ctw 'cargo test -- --nocapture'  # with output
        abbr -a cch 'cargo check'
        abbr -a ccl 'cargo clippy'
        abbr -a cf 'cargo fmt'
        abbr -a cfc 'cargo fmt --check'
        abbr -a ca 'cargo add'
        abbr -a crm 'cargo remove'
        abbr -a cu 'cargo update'
        abbr -a cdoc 'cargo doc --open'
        abbr -a cw 'cargo watch -x'
        abbr -a cwt 'cargo watch -x test'
        abbr -a cwr 'cargo watch -x run'
    end
    
    if type -q rustup
        abbr -a ru rustup
        abbr -a ruu 'rustup update'
    end
    
    # =========================================================================
    # Python Development
    # =========================================================================
    
    # Python
    abbr -a py python3
    abbr -a py3 python3
    abbr -a pip 'python3 -m pip'
    abbr -a pip3 'python3 -m pip'
    abbr -a pir 'python3 -m pip install -r requirements.txt'
    
    # Virtual environments
    abbr -a venv 'python3 -m venv .venv'
    abbr -a va 'source .venv/bin/activate.fish'
    abbr -a vd deactivate
    
    # uv (fast Python package manager)
    if type -q uv
        abbr -a uvr 'uv run'
        abbr -a uvs 'uv sync'
        abbr -a uva 'uv add'
        abbr -a uvp 'uv pip'
        abbr -a uvv 'uv venv'
    end
    
    # Poetry
    if type -q poetry
        abbr -a po poetry
        abbr -a por 'poetry run'
        abbr -a poi 'poetry install'
        abbr -a poa 'poetry add'
        abbr -a posh 'poetry shell'
    end
    
    # pytest
    if type -q pytest
        abbr -a pyt pytest
        abbr -a pytv 'pytest -v'
        abbr -a pytf 'pytest --tb=short -q'
    end
    
    # =========================================================================
    # JavaScript/TypeScript Development
    # =========================================================================
    
    # Node/NPM
    if type -q npm
        abbr -a n npm
        abbr -a ni 'npm install'
        abbr -a nid 'npm install --save-dev'
        abbr -a nig 'npm install -g'
        abbr -a nr 'npm run'
        abbr -a nrs 'npm run start'
        abbr -a nrd 'npm run dev'
        abbr -a nrb 'npm run build'
        abbr -a nrt 'npm run test'
        abbr -a nrl 'npm run lint'
        abbr -a nx 'npx'
    end
    
    # pnpm
    if type -q pnpm
        abbr -a p pnpm
        abbr -a pi 'pnpm install'
        abbr -a pa 'pnpm add'
        abbr -a pad 'pnpm add -D'
        abbr -a pr 'pnpm run'
        abbr -a prd 'pnpm run dev'
        abbr -a prb 'pnpm run build'
        abbr -a prt 'pnpm run test'
        abbr -a px 'pnpm dlx'
    end
    
    # Yarn
    if type -q yarn
        abbr -a y yarn
        abbr -a ya 'yarn add'
        abbr -a yad 'yarn add -D'
        abbr -a yr 'yarn run'
        abbr -a yd 'yarn dev'
        abbr -a yb 'yarn build'
        abbr -a yt 'yarn test'
    end
    
    # Bun
    if type -q bun
        abbr -a b bun
        abbr -a bi 'bun install'
        abbr -a ba 'bun add'
        abbr -a bad 'bun add -d'
        abbr -a br 'bun run'
        abbr -a brd 'bun run dev'
        abbr -a brb 'bun run build'
        abbr -a brt 'bun run test'
        abbr -a bx 'bunx'
    end
    
    # Deno
    if type -q deno
        abbr -a d deno
        abbr -a dr 'deno run'
        abbr -a dt 'deno task'
        abbr -a dra 'deno run -A'
        abbr -a dc 'deno compile'
    end
    
    # =========================================================================
    # Ruby/Rails Development
    # =========================================================================
    
    if type -q ruby
        abbr -a rb ruby
        abbr -a be 'bundle exec'
        abbr -a bi 'bundle install'
        abbr -a bu 'bundle update'
    end
    
    # Rails
    if type -q rails; or test -f bin/rails
        abbr -a r 'bin/rails'
        abbr -a rs 'bin/rails server'
        abbr -a rc 'bin/rails console'
        abbr -a rlg 'bin/rails generate'
        abbr -a rd 'bin/rails destroy'
        abbr -a rdb 'bin/rails db:migrate'
        abbr -a rdbs 'bin/rails db:migrate:status'
        abbr -a rdbr 'bin/rails db:rollback'
        abbr -a rdbreset 'bin/rails db:drop db:create db:migrate db:seed'
        abbr -a rspec 'bin/rspec'
        abbr -a rspf 'bin/rspec --fail-fast'
    end
    
    # =========================================================================
    # Go Development
    # =========================================================================
    
    if type -q go
        abbr -a gor 'go run .'
        abbr -a gob 'go build'
        abbr -a got 'go test ./...'
        abbr -a gotv 'go test -v ./...'
        abbr -a gof 'go fmt ./...'
        abbr -a gom 'go mod'
        abbr -a gomt 'go mod tidy'
        abbr -a gomi 'go mod init'
        abbr -a gog 'go get'
        abbr -a goi 'go install'
    end
    
    # =========================================================================
    # C/C++ Development
    # =========================================================================
    
    abbr -a cc 'gcc'
    abbr -a cpp 'g++'
    abbr -a mk make
    abbr -a mkc 'make clean'
    abbr -a mkb 'make build'
    abbr -a cm cmake
    abbr -a cmb 'cmake --build .'
    abbr -a cmi 'cmake -B build && cmake --build build'
    
    # =========================================================================
    # Database / SQL
    # =========================================================================
    
    # PostgreSQL
    if type -q psql
        abbr -a pg psql
    end
    
    if type -q pgcli
        abbr -a pgc pgcli
    end
    
    # SQLite
    if type -q sqlite3
        abbr -a sq sqlite3
    end
    
    # Redis
    if type -q redis-cli
        abbr -a rds redis-cli
    end
    
    # =========================================================================
    # Docker & Containers
    # =========================================================================
    
    if type -q docker
        abbr -a dk docker
        abbr -a dkps 'docker ps'
        abbr -a dkpsa 'docker ps -a'
        abbr -a dki 'docker images'
        abbr -a dkr 'docker run'
        abbr -a dkri 'docker run -it'
        abbr -a dkrm 'docker rm'
        abbr -a dkrmi 'docker rmi'
        abbr -a dkl 'docker logs'
        abbr -a dklf 'docker logs -f'
        abbr -a dkex 'docker exec -it'
        abbr -a dkb 'docker build'
        abbr -a dkbt 'docker build -t'
        abbr -a dkstop 'docker stop (docker ps -q)'
        abbr -a dkprune 'docker system prune -af'
    end
    
    if type -q docker-compose; or type -q 'docker compose'
        abbr -a dco 'docker compose'
        abbr -a dcou 'docker compose up'
        abbr -a dcoud 'docker compose up -d'
        abbr -a dcod 'docker compose down'
        abbr -a dcor 'docker compose restart'
        abbr -a dcol 'docker compose logs'
        abbr -a dcolf 'docker compose logs -f'
        abbr -a dcops 'docker compose ps'
        abbr -a dcob 'docker compose build'
    end
    
    if type -q lazydocker
        abbr -a lzd lazydocker
    end
    
    # Podman (rootless by default, no sudo needed)
    if type -q podman
        abbr -a p podman
        abbr -a pps 'podman ps'
        abbr -a ppsa 'podman ps -a'
        abbr -a pi 'podman images'
        abbr -a pr 'podman run'
        abbr -a pri 'podman run -it'
        abbr -a prm 'podman rm'
        abbr -a prmi 'podman rmi'
        abbr -a pl 'podman logs'
        abbr -a plf 'podman logs -f'
        abbr -a pex 'podman exec -it'
        abbr -a pb 'podman build'
        abbr -a pbt 'podman build -t'
        abbr -a pstop 'podman stop'
        abbr -a pprune 'podman system prune -af'
        
        # Podman Compose
        abbr -a pc 'podman compose'
        abbr -a pcu 'podman compose up'
        abbr -a pcud 'podman compose up -d'
        abbr -a pcd 'podman compose down'
        abbr -a pcl 'podman compose logs -f'
    end

    # Distrobox
    if type -q distrobox
        abbr -a db distrobox
        abbr -a dbe 'distrobox enter'
        abbr -a dbc 'distrobox create'
        abbr -a dbl 'distrobox list'
        abbr -a dbr 'distrobox rm'
        abbr -a dbs 'distrobox stop'
    end
    
    # =========================================================================
    # Kubernetes
    # =========================================================================
    
    if type -q kubectl
        abbr -a k kubectl
        abbr -a kg 'kubectl get'
        abbr -a kgp 'kubectl get pods'
        abbr -a kgs 'kubectl get svc'
        abbr -a kgd 'kubectl get deployments'
        abbr -a kd 'kubectl describe'
        abbr -a kl 'kubectl logs'
        abbr -a klf 'kubectl logs -f'
        abbr -a kex 'kubectl exec -it'
        abbr -a ka 'kubectl apply -f'
        abbr -a kdel 'kubectl delete'
        abbr -a kctx 'kubectl config use-context'
        abbr -a kns 'kubectl config set-context --current --namespace'
    end
    
    # =========================================================================
    # System Management (Fedora/DNF)
    # =========================================================================
    
    # Package manager abbreviations (distro-agnostic)
    if type -q dnf
        # Fedora/RHEL
        abbr -a pkgi 'sudo dnf install'
        abbr -a pkgs 'dnf search'
        abbr -a pkgu 'sudo dnf upgrade'
        abbr -a pkgr 'sudo dnf remove'
        abbr -a pkgl 'dnf list installed'
        abbr -a pkginfo 'dnf info'
    else if type -q apt
        # Debian/Ubuntu
        abbr -a pkgi 'sudo apt install'
        abbr -a pkgs 'apt search'
        abbr -a pkgu 'sudo apt upgrade'
        abbr -a pkgr 'sudo apt remove'
        abbr -a pkgl 'apt list --installed'
        abbr -a pkginfo 'apt show'
    else if type -q pacman
        # Arch Linux
        abbr -a pkgi 'sudo pacman -S'
        abbr -a pkgs 'pacman -Ss'
        abbr -a pkgu 'sudo pacman -Syu'
        abbr -a pkgr 'sudo pacman -R'
        abbr -a pkgl 'pacman -Q'
        abbr -a pkginfo 'pacman -Si'
    end
    
    if type -q flatpak
        abbr -a fp flatpak
        abbr -a fpi 'flatpak install'
        abbr -a fps 'flatpak search'
        abbr -a fpu 'flatpak update'
        abbr -a fpr 'flatpak uninstall'
        abbr -a fpl 'flatpak list'
    end
    
    if type -q systemctl
        abbr -a sc 'sudo systemctl'
        abbr -a scs 'sudo systemctl status'
        abbr -a scstart 'sudo systemctl start'
        abbr -a scstop 'sudo systemctl stop'
        abbr -a screstart 'sudo systemctl restart'
        abbr -a scenable 'sudo systemctl enable'
        abbr -a scdisable 'sudo systemctl disable'
        abbr -a sclog 'journalctl -u'
    end
    
    # =========================================================================
    # Utilities
    # =========================================================================
    
    # Clipboard (Wayland)
    if type -q wl-copy
        abbr -a copy wl-copy
        abbr -a paste wl-paste
    end
    
    # Quick edit config files
    abbr -a fishrc '$EDITOR ~/.config/fish/config.fish'
    abbr -a fishabbr '$EDITOR ~/.config/fish/conf.d/abbreviations.fish'
    abbr -a starrc '$EDITOR ~/.config/starship.toml'
    abbr -a gitrc '$EDITOR ~/.gitconfig'
    
    # Reload fish config
    abbr -a reload 'source ~/.config/fish/config.fish'
    abbr -a fishreload 'source ~/.config/fish/config.fish'
    
    # Quick shortcuts
    abbr -a q exit
    abbr -a :q exit
    abbr -a cls clear
    abbr -a h history
    abbr -a j jobs
    abbr -a ports 'ss -tulanp'
    abbr -a myip 'curl -s ifconfig.me'
    abbr -a now 'date +"%Y-%m-%d %H:%M:%S"'
    abbr -a week 'date +%V'
    abbr -a path 'echo $PATH | tr " " "\n"'
    
    # Safety nets
    abbr -a rm 'rm -i'
    abbr -a mv 'mv -i'
    abbr -a cp 'cp -i'
    abbr -a mkdir 'mkdir -p'
    
    # Editor
    if type -q nvim
        abbr -a v nvim
        abbr -a vim nvim
        abbr -a vi nvim
    else if type -q vim
        abbr -a v vim
        abbr -a vi vim
    end
    
    # File manager
    if type -q yazi
        abbr -a fm yazi
    else if type -q ranger
        abbr -a fm ranger
    else if type -q nnn
        abbr -a fm nnn
    end
    
    # Tokei (code stats)
    if type -q tokei
        abbr -a loc tokei
    end
    
    # Hyperfine (benchmarking)
    if type -q hyperfine
        abbr -a bench hyperfine
    end
end