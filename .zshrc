# Add the following line in ~/.zshrc
#
# ```zsh
# . ~/ghq/github.com/ita-jp/dotfiles/.zshrc
# ```
#

function cdrepo() {
    cd $(ghq list -p | peco)
}

function fac() {
    cat ~/ghq/github.com/ita-jp/dotfiles/command.list | peco | bash
}

alias g='git'
alias k='kubectl'
alias lzd='lazydocker'

alias -g B='$(git branch -a --format="%(refname:short)" | peco --prompt "GIT BRANCH >")'
alias -g CH='$(git log --oneline --branches | peco --prompt "GIT COMMIT HASH >" | cut -d" " -f1)'
alias -g P='| peco'
alias -g G='| grep --color'

HISTSIZE=1000000000
SAVEHIST=1000000000

setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history

function select-history-with-peco() {
    BUFFER="`history -r -n 1 | peco --query "$BUFFER"`"
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N select-history-with-peco
bindkey '^r' select-history-with-peco

cd_git_root() {
    local root_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ -n $root_dir ]]; then
        cd $root_dir
    else
        echo "This is not a git repository."
    fi
}

alias cdgr='cd_git_root'

function ssha() {
    ssh $(cat ~/.ssh/config | grep 'Host ' | cut -d' ' -f2 | fzf --tmux center)
}
