function cdrepo() {
    cd $(ghq list -p | peco)
}

alias g='git'
