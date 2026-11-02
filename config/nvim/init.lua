vim.g.mapleader = " "

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('n', '<leader>t', ':terminal<CR>')

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})


vim.opt.relativenumber = true

vim.api.nvim_create_autocmd({ "TermOpen" }, { -- needed for +terminal
    callback = function()
        vim.opt.relativenumber = true
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


-- Find the packages beside this file, including when launched with nvim -u.
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)
vim.opt.packpath:prepend(config_dir)
vim.cmd.packadd("multicursor.nvim")
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25-blinkon500-blinkoff500-TermCursor"
require("terminal-edit").setup({ config_dir = config_dir })

-- zsh alias: vt='nvim +terminal +startinsert'
