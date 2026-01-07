vim.g.mapleader = " "

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('n', '<leader>t', ':terminal<CR>')

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- https://github.com/xb-bx/editable-term.nvim
require("editable-term").setup({
	prompts = {
		["^lucas@melhorpcnaoha:.* %$ "] = {}, -- risto theme
	},
	--wait_for_keys_delay = 50
})

