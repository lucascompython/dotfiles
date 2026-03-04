vim.g.mapleader = " "

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('n', '<leader>t', ':terminal<CR>')

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
vim.opt.laststatus = 0

-- TODO: make this work on windows
local function get_terminal_cwd()
    local pid = vim.fn.jobpid(vim.bo.channel)
    local cwd = vim.fn.resolve("/proc/" .. pid .. "/cwd")
    return cwd
end

-- pressing gd will open  the file under the cursor in the editor specified by $VISUAL
-- In my case $VISUAL is set to zed, and has the same behavior as gd in zed, kinda like a "go to definition" but for files
local visual = os.getenv("VISUAL") or os.getenv("EDITOR")
local browser = os.getenv("BROWSER") or "firefox"
-- maybe, if I use this enough, we could just use "xdg-open" for other opening other things
vim.keymap.set("n", "gd", function()
    local file = vim.fn.expand("<cWORD>")

    -- remove any surrounding parens, brackets, quotes, etc.
    file = file:gsub("^[%(%[\"']+", ""):gsub("[%%)%]\"']+$", "")

    if file == "" then
        print("No file under cursor")
        return
    end

    -- if file is http or https, open in browser
    if file:match("^https?://") then
        vim.fn.jobstart({ browser, file }, { detach = true })
        return
    end

    if not visual or visual == "" then
        print("$VISUAL is not set")
        return
    end

    vim.fn.jobstart({ visual, file }, { detach = true, cwd = get_terminal_cwd() })
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
