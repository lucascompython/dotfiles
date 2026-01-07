vim.g.mapleader = " "

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('n', '<leader>t', ':terminal<CR>')

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})
vim.highlight.on_yank()

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
vim.opt.laststatus = 0


-- https://github.com/xb-bx/editable-term.nvim
require("editable-term").setup({
    prompts = {
        ["^lucas@melhorpcnaoha:.-%$ "] = {}, -- matches both regular and git prompts
    },
    wait_for_keys_delay = 50
})

-- zsh config:
-- alias vt='nvim +terminal +startinsert'

-- may need to add this:
--preexec() {
--printf "\033]133;A\007"
--}
--precmd() {
--printf "\033]133;B\007"
--}
