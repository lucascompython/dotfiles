ZSH_THEME=afowler
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

alias yay="paru"
alias zed="zeditor"
alias clip="wl-copy -n"
alias open="xdg-open"
alias update="yay -Syu"

eval "$(zoxide init zsh --cmd cd)"
