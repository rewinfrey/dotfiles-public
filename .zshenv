# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# DirEnv
eval "$(direnv hook zsh)"

# Git aliases
alias ga="git add"
alias gc="git commit"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gs="git status"
alias gwl="git worktree list"
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias gsu="git submodule update --init --recursive --remote"
alias gpf="git push --force"
alias gpu="git push --set-upstream origin HEAD"
alias gx="git log --all --graph --color --decorate --oneline"
alias gl="git log --oneline"
alias gb="git branch -v"
alias gbd="git branch -D"
alias gp="git pull"
alias gf="git fetch"

# GitHub
export CR_PAT=$(cat ~/.cr-pat)
alias cr_auth="echo $CR_PAT | docker login ghcr.io -u rewinfrey --password-stdin"

# Go
export GOPROXY=https://goproxy.githubapp.com/mod,https://proxy.golang.org/,direct
export GOPRIVATE=
export GONOPROXY=
export GONOSUMDB=github.com/github/*
export GOPATH=`go env GOPATH`
export PATH=$GOPATH/bin:$PATH

# Navigation aliases
alias l="ls -alhGg"
alias aleph="cd $HOME/github/aleph; l"
alias cloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs; l"
alias github="cd $HOME/github; l"
alias personal="cd $HOME/personal; l"
alias se="cd $HOME/github/symbol-extraction; l"

# Neovim
alias vim="nvim"

# Ruby
eval "$(frum init)"

# Rust
. "$HOME/.cargo/env"
export PATH=$HOME/.cargo/bin:$PATH
alias cbe="cargo bench"
alias cb="cargo build"
alias cc="cargo check"
alias cr="cargo run"
alias ct="cargo test"
alias ctnc="cargo test -- --nocapture"

# Other
alias notes="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Notes; vim"

# Stack Graphs
alias tv="./contrib/test test"

# Tailscale
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
