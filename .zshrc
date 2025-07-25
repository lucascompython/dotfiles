ZSH_THEME=afowler
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

alias yay="paru"
alias zed="zeditor"
alias clip="wl-copy -n"
alias open="xdg-open"
alias update="yay -Syu"

alias ls='eza -al --color=always --group-directories-first --icons always' 

eval "$(zoxide init zsh --cmd cd)"
