autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{#9ccfd8}%~%f %F{#ebbcba}${vcs_info_msg_0_}%f'$'\n''> '
eval "$(frum init)"
