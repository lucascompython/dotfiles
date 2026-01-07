vim.g.mapleader = " "

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('n', '<leader>t', ':terminal<CR>')

vim.api.nvim_set_option("clipboard", "unnamedplus")

-- https://github.com/xb-bx/editable-term.nvim
require("editable-term").setup({})

-- TODO: .zshrc
    --preexec() {
        --printf "\033]133;A\007"
    --}
    --precmd() {
        --printf "\033]133;B\007"
    --}
