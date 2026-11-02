# Capture BUFFER, never the autosuggestion in POSTDISPLAY. Hex keeps control
# characters and Unicode out of the OSC protocol and shell command parsing.
_nvim_term_snapshot() {
    local text="$BUFFER" cursor="$CURSOR" encoded='' byte
    local LC_ALL=C
    integer i
    for (( i = 1; i <= ${#text}; i++ )); do
        builtin printf -v byte '%02x' "'${text[i]}"
        encoded+="$byte"
    done
    builtin printf '\033]777;nvim-edit;snapshot;%s;%s\007' "$cursor" "$encoded"
}

_nvim_term_apply() {
    local payload='' cursor encoded escaped='' byte
    while read -rsk 1 byte; do
        [[ "$byte" == $'\n' || "$byte" == $'\r' ]] && break
        payload+="$byte"
    done
    cursor="${payload%%;*}"
    encoded="${payload#*;}"
    [[ "$cursor" == <-> && "$encoded" != *[^[:xdigit:]]* ]] || return
    (( ${#encoded} % 2 == 0 )) || return
    integer i
    for (( i = 1; i <= ${#encoded}; i += 2 )); do
        escaped+="\\x${encoded[i,i+1]}"
    done
    builtin printf -v BUFFER '%b' "$escaped"
    CURSOR=$cursor
    _nvim_term_snapshot
    zle -R
}

_nvim_term_start() { builtin printf '\033]777;nvim-edit;start\007'; }
_nvim_term_end() { builtin printf '\033]777;nvim-edit;end\007'; }

zle -N _nvim_term_snapshot
zle -N _nvim_term_apply
for _nvim_term_keymap in emacs viins vicmd; do
    bindkey -M "$_nvim_term_keymap" '\e[99;1~' _nvim_term_snapshot
    bindkey -M "$_nvim_term_keymap" '\e[99;2~' _nvim_term_apply
done
unset _nvim_term_keymap
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init _nvim_term_start
add-zle-hook-widget line-finish _nvim_term_end
