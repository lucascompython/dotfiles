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


local visual = os.getenv("VISUAL")
-- pressing gd will open  the file under the cursor in the editor specified by $VISUAL
-- In my case $VISUAL is set to zed, and has the same behavior as gd in zed, kinda like a "go to definition" but for files
vim.keymap.set("n", "gd", function()
    local file = vim.fn.expand("<cfile>")
    if file == "" then
        print("No file under cursor")
        return
    end

    if not visual or visual == "" then
        print("$VISUAL is not set")
        return
    end

    vim.fn.jobstart({ visual, file }, { detach = true })
end, { desc = "Open file under cursor in $VISUAL" })




-- https://github.com/xb-bx/editable-term.nvim
-- TODO: checkout https://github.com/chomosuke/term-edit.nvim
require("editable-term").setup({
    prompts = {
        -- the zsh theme is risto
        ["^lucas@lpcdolucas:.-%$ "] = {}, -- matches both regular and git prompts
    },
    --wait_for_keys_delay = 50
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
