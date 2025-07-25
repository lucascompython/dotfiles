ZSH_THEME=afowler
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

alias yay="paru"
alias zed="zeditor"
alias clip="wl-copy -n"
alias open="xdg-open"
alias update="yay -Syu"

alias ls='eza -al --color=always --group-directories-first --icons always'
alias ci="RUSTFLAGS='-C target-cpu=native' cargo install"
alias rf="RUSTFLAGS='-C target-cpu=native'"

eval "$(zoxide init zsh --cmd cd)"
