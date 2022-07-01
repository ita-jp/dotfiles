function cdrepo() {
    cd $(ghq list -p | peco)
}
