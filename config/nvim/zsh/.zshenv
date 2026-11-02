# Load the user's normal startup file, then continue through our .zshrc shim.
typeset _nvim_term_shim="$ZDOTDIR"
if [[ -n "$NVIM_TERM_ORIGINAL_ZDOTDIR" ]]; then
    ZDOTDIR="$NVIM_TERM_ORIGINAL_ZDOTDIR"
else
    unset ZDOTDIR
fi
[[ -r "${ZDOTDIR:-$HOME}/.zshenv" ]] && source "${ZDOTDIR:-$HOME}/.zshenv"
export NVIM_TERM_ORIGINAL_ZDOTDIR="${ZDOTDIR-}"
export ZDOTDIR="$_nvim_term_shim"
