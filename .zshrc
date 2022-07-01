# Add the following line in ~/.zshrc
#
# ```zsh
# . ~/ghq/github.com/ita-jp/dotfiles/.zshrc.include
# ```
#

function cdrepo() {
    cd $(ghq list -p | peco)
}

alias g='git'

alias -g B='$(git branch -a --format="%(refname:short)" | peco --prompt "GIT BRANCH >")'
alias -g CH='$(git log --oneline --branches | peco --prompt "GIT COMMIT HASH >" | cut -d" " -f1)'
