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
command -v zoxide >/dev/null 2>&1 || brew install zoxide
eval "$(zoxide init zsh)"
alias cd='z'

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

#
# bat
#
command -v bat >/dev/null 2>&1 || brew install bat bat-extras
alias cat='bat'

#
# mcfly (https://github.com/cantino/mcfly)
#
command -v mcfly >/dev/null 2>&1 || brew install mcfly
eval "$(mcfly init zsh)"

#
# lazydocker (https://github.com/jesseduffield/lazydocker)
#
command -v lazydocker >/dev/null 2>&1 || brew install lazydocker
alias lzd='lazydocker'

#
# lazygit (https://github.com/jesseduffield/lazygit)
#
command -v lazygit >/dev/null 2>&1 || brew install lazygit
alias lg='lazygit'

#
# yazi (https://github.com/sxyazi/yazi)
#
command -v yazi >/dev/null 2>&1 || brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

#
# direnv (https://direnv.net/)
#
command -v direnv >/dev/null 2>&1 || brew install direnv
eval "$(direnv hook zsh)"

