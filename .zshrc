# Add the following line in ~/.zshrc
#
# ```zsh
# . ~/ghq/github.com/ita-jp/dotfiles/.zshrc
# ```
#

function fac() {
    cat ~/ghq/github.com/ita-jp/dotfiles/command.list | peco | bash
}

alias n='nvim'
alias g='git'
alias d='docker'
alias k='kubectl'
alias lzd='lazydocker'
alias lzg='lazygit'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias -g G='| grep --color'
alias -g PC='| pbcopy'

HISTSIZE=1000000000
SAVEHIST=1000000000

setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history

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

function chts() {
    tmux attach-session -t $(tmux ls | fzf --tmux center | cut -d: -f1)
}

alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "/run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock" -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/basecamp/kamal:latest'

#
# fzf (https://github.com/junegunn/fzf)
#
source <(fzf --zsh)

#
# zoxide (https://github.com/ajeetdsouza/zoxide)
#
eval "$(zoxide init zsh)"
if command -v z >/dev/null 2>&1; then
    alias cd='z'
else
    echo "'z' command not found. Keeping 'cd' as is." >&2
    echo "You can install it using: brew install z" >&2
fi

#
# eza (https://github.com/eza-community/eza)
#
# アイコン表示には terminal にフォントの設定が必要
#
# 1. brew install --cask font-jetbrains-mono-nerd-font を実行
# 2. Terminal.app > 設定（⌘ + ,）> プロファイル > テキスト > フォントの変更
# 3. JetBrainsMono Nerd Font Mono を選択
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# Replace ls with eza
alias ls='eza --group-directories-first --icons --git'
alias ll='eza -l --group-directories-first --icons --git'
alias la='eza -la --group-directories-first --icons --git'
alias lt='eza -T --level=2 --icons'
alias llt='eza -lT --icons'

#
# ghq + fzf
#
cdr() {
    local dir
    dir=$(ghq list -p | fzf --preview="eza -TL 1 --git --icons {}" --height=40%)
    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}

#
# Go to GitHub
#
gtg() {
    open $(git remote get-url origin | sed 's#ssh://git@github.com/#https://github.com/#' | sed 's#\.git$##')
}
