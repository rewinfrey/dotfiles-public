autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{#9ccfd8}%~%f %F{#ebbcba}${vcs_info_msg_0_}%f'$'\n''> '

# Load shell environment variables
if [[ "$OSTYPE" == darwin* ]]; then
  # Brew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Source .zshenv.private
if [[ -e "$HOME/.zshenv.private" ]]; then
  source "$HOME/.zshenv.private"
fi

# Direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Ruby
if command -v frum >/dev/null 2>&1; then
  eval "$(frum init)"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
export PATH=$HOME/.cargo/bin:$PATH

# Go
# export GOPROXY=https://goproxy.githubapp.com/mod,https://proxy.golang.org/,direct
# export GOPRIVATE=
# export GONOPROXY=
# export GONOSUMDB=github.com/github/*
export GOPATH=`go env GOPATH`
export PATH=$GOPATH/bin:$PATH

# TexLive (LaTeX)
export PATH="/usr/local/texlive/2024/bin/universal-darwin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# UV and Ruff
. "$HOME/.local/bin/env"
