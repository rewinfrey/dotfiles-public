autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{#9ccfd8}%~%f %F{#ebbcba}${vcs_info_msg_0_}%f'$'\n''> '

# Check if the OS is macOS (Mac OS)
if [[ "$OSTYPE" == darwin* ]]; then
  # Brew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Check if .zshenv.private file exists and source it
if [[ -e "$HOME/.zshenv.private" ]]; then
  source "$HOME/.zshenv.private"
fi

# DirEnv
#if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
#fi

# Ruby
if command -v frum >/dev/null 2>&1; then
  eval "$(frum init)"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
export PATH=$HOME/.cargo/bin:$PATH

# GHC
if [ -f "/Users/quercus/.ghcup/env" ]; then
  source "/Users/quercus/.ghcup/env"
fi

# Go
export GOPROXY=https://goproxy.githubapp.com/mod,https://proxy.golang.org/,direct
export GOPRIVATE=
export GONOPROXY=
export GONOSUMDB=github.com/github/*
export GOPATH=`go env GOPATH`
export PATH=$GOPATH/bin:$PATH

# TexLive (LaTeX)
export PATH="/usr/local/texlive/2024/bin/universal-darwin:$PATH"
