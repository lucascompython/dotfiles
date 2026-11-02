if [[ -n "$NVIM_TERM_ORIGINAL_ZDOTDIR" ]]; then
    ZDOTDIR="$NVIM_TERM_ORIGINAL_ZDOTDIR"
else
    unset ZDOTDIR
fi
[[ -r "${ZDOTDIR:-$HOME}/.zshrc" ]] && source "${ZDOTDIR:-$HOME}/.zshrc"
source "$_nvim_term_shim/integration.zsh"
unset _nvim_term_shim NVIM_TERM_ORIGINAL_ZDOTDIR
