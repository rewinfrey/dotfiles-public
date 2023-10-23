autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{#9ccfd8}%~%f %F{#ebbcba}${vcs_info_msg_0_}%f'$'\n''> '

# bun completions
[ -s "/Users/quercus/.bun/_bun" ] && source "/Users/quercus/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f "/Users/quercus/.ghcup/env" ] && source "/Users/quercus/.ghcup/env" # ghcup-env