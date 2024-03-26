# Git aliases
alias ga="git add"
alias gc="git commit -v"
alias gca="git commit --amend"
alias gcm="git commit -m"
alias gcan="git commit --amend --no-edit"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gs="git status"
alias gwl="git worktree list"
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias gsu="git submodule update --init --recursive"
alias gpf="git push --force"
alias gpu="git push --set-upstream origin HEAD"
alias gx="git log --all --graph --color --decorate --oneline"
alias gl="git log --oneline"
alias gb="git branch -v"
alias gbd="git branch -D"
alias gp="git pull"
alias gf="git fetch"

# Codespaces
alias ghc="gh codespace"
alias ghcc="gh codespace create"
alias ghcd="gh codespace delete"
alias ghcl="gh codespace list"
alias ghcr="gh codespace rebuild"
alias ghcs="gh codespace ssh"

# Navigation aliases
alias l="ls -alhGg"
alias aleph="cd $HOME/github/aleph; l"
alias blackbird="cd $HOME/github/blackbird; l"
alias blackbird-mw="cd $HOME/github/blackbird-mw; l"
alias cloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs; l"
alias github="cd $HOME/github; l"
alias personal="cd $HOME/personal; l"
alias se="cd $HOME/github/symbol-extraction; l"

# Neovim
alias vim="nvim"

alias cbe="cargo bench"
alias cb="cargo build"
alias cc="cargo check"
alias cr="cargo run"
alias ct="cargo test"
alias ctnc="cargo test -- --nocapture"

# Tree-sitter
alias tsg="tree-sitter generate"
alias tsp="tree-sitter parse"

# Other
alias notes="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Notes; vim"

# Stack Graphs
alias tv="./contrib/test test"

# Tailscale
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Config files
alias ezshenv="vim $HOME/.zshenv"
alias ezshrc="vim $HOME/.zshrc"
alias etmux="vim $HOME/.tmux.conf"
alias epacker="vim $HOME/.config/nvim/lua/rewinfrey/packer.lua"
alias evim="vim $HOME/.config/nvim/lua/rewinfrey/vim.lua"
alias eremap="vim $HOME/.config/nvim/lua/rewinfrey/remap.lua"

# Helper functions
delete_unused_branches() {
    # Fetch the latest state of the remote and prune deleted branches
    git fetch --prune

    # List local branches that are gone (do not have a corresponding remote branch)
    local branches_to_delete=$(git branch -vv | grep ': gone]' | awk '{print $1}')

    # Check if there are any branches to delete
    if [[ -z "$branches_to_delete" ]]; then
        echo "No branches to delete."
        return 0
    fi

    # Show the branches to be deleted and ask for confirmation
    echo "The following branches will be deleted:"
    echo "$branches_to_delete"
    echo "Do you want to proceed? (y/n)"
    read answer

    if [[ "$answer" == [Yy]* ]]; then
        # If yes, delete the branches
        echo "$branches_to_delete" | xargs git branch -d
        echo "Branches deleted."
    else
        echo "Deletion cancelled."
    fi
}
