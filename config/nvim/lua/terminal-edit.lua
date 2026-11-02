local M = {}
local mc = require("multicursor-nvim")
local active
local prompt_rows = {}
local shells = {}
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

local function encode(text)
    return (text:gsub(".", function(byte) return string.format("%02x", byte:byte()) end))
end

local function request_snapshot(buf)
    local shell = shells[buf]
    if not shell or not shell.editing then return false end
    local version = shell.version or 0
    vim.api.nvim_chan_send(vim.bo[buf].channel, "\27[99;1~")
    return vim.wait(200, function() return (shell.version or 0) > version end, 1)
end

local function apply_command(chan, command, cursor)
    vim.api.nvim_chan_send(chan, "\27[99;2~" .. cursor .. ";" .. encode(command) .. "\n")
end

local function command_at_cursor()
    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local original = vim.api.nvim_get_current_line()
    local shell = shells[buf]
    -- risto, independent of the user, host, directory and git branch.
    local _, prompt = original:find("^[^%s]+@[^%s]+:.-[%$#] ")
    if not prompt or prompt_rows[buf] ~= cursor[1] or not shell or not shell.editing or shell.text == nil then
        return
    end
    local pos = vim.fn.screenpos(0, cursor[1], prompt + 1)
    local win = vim.api.nvim_get_current_win()
    local width = vim.api.nvim_win_get_position(win)[2] + vim.api.nvim_win_get_width(win) - pos.col + 1
    if pos.row == 0 or shell.text:find("[\r\n]") or vim.fn.strdisplaywidth(shell.text) >= width then
        return
    end
    local command = shell.text
    return {
        term = buf, parent = win, chan = vim.bo[buf].channel,
        row = cursor[1], prompt = prompt, original = original,
        command = command, col = math.max(0, cursor[2] - prompt),
        screen = pos, width = width,
    }
end

local function finish(cancel, execute, terminal_input)
    local edit = active
    if not edit or edit.finishing then
        return
    end
    edit.finishing = true
    local lines = vim.api.nvim_buf_get_lines(edit.buf, 0, -1, false)
    local command = lines[1] or ""
    if not cancel then
        if #lines ~= 1 or command:find("[%z\1-\31\127]") then
            vim.notify("Keep the command on one line; Ctrl-C cancels", vim.log.levels.WARN)
            edit.finishing = false
            return
        end
        if vim.fn.strdisplaywidth(command) >= edit.width then
            vim.notify("The command must fit on this terminal line; Ctrl-C cancels", vim.log.levels.WARN)
            edit.finishing = false
            return
        end
        local valid = vim.api.nvim_buf_is_valid(edit.term) and request_snapshot(edit.term)
        if not valid or shells[edit.term].text ~= edit.command then
            vim.notify("The terminal changed; copy your edits or Ctrl-C to cancel", vim.log.levels.WARN)
            edit.finishing = false
            return
        end
    end
    local col = math.min(vim.api.nvim_win_get_cursor(edit.win)[2], #command)
    active = nil
    vim.cmd.stopinsert()
    mc.clearCursors()
    vim.api.nvim_win_close(edit.win, true)
    if cancel or not vim.api.nvim_win_is_valid(edit.parent) then
        return
    end
    vim.api.nvim_set_current_win(edit.parent)
    -- Shell movement counts characters; Neovim buffer columns count bytes.
    apply_command(edit.chan, command, vim.fn.strchars(command:sub(1, col)))
    if execute then
        vim.api.nvim_chan_send(edit.chan, "\r")
    end
    vim.api.nvim_win_set_cursor(edit.parent, { edit.row, edit.prompt + col })
    if execute or terminal_input then
        -- A change operator may still be inside Vim's insert loop. Leave that
        -- loop before starting the terminal's own input mode.
        local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>i", true, false, true)
        vim.api.nvim_feedkeys(keys, "ni", false)
    end
end

local function leave_visual()
    vim.cmd.normal({ esc, bang = true })
end

local function select_matches()
    local mode = vim.fn.mode()
    local whole_word = mode == "n"
    if whole_word then
        vim.cmd.normal({ "viw", bang = true })
    elseif mode ~= "v" then
        return
    end
    local first, last = vim.fn.getpos("v"), vim.fn.getpos(".")
    local text = table.concat(vim.fn.getregion(first, last, {
        type = "v", exclusive = vim.o.selection == "exclusive",
    }))
    leave_visual()
    if text == "" then
        return
    end
    local pattern = "\\C\\V" .. vim.fn.escape(text, "\\")
    if whole_word and vim.fn.match(text, "^\\k\\+$") == 0 then
        pattern = "\\<" .. pattern .. "\\m\\>"
    end
    mc.clearCursors()
    mc.action(function(ctx)
        local cursor = ctx:mainCursor()
        cursor:setMode("v")
        cursor:setVisual({ 1, 1 }, { 1, #vim.api.nvim_get_current_line() })
    end)
    mc.matchCursors(pattern)
end

local function open(persistent)
    if active then return false end
    local edit = command_at_cursor()
    if not edit then
        return false
    end
    local mode = vim.fn.mode()
    local anchor, cursor
    if mode == "v" or mode == "V" then
        anchor, cursor = vim.fn.getpos("v"), vim.fn.getpos(".")
        if anchor[2] ~= edit.row or cursor[2] ~= edit.row then
            return false
        end
        leave_visual()
    elseif mode ~= "n" then
        return false
    end
    edit.persistent = persistent
    edit.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[edit.buf].bufhidden = "wipe"
    vim.bo[edit.buf].swapfile = false
    vim.api.nvim_buf_set_lines(edit.buf, 0, -1, false, { edit.command })
    -- Cover only the command's cells, on the same screen row as the shell.
    edit.win = vim.api.nvim_open_win(edit.buf, true, {
        relative = "editor", row = edit.screen.row - 1, col = edit.screen.col - 1,
        width = edit.width, height = 1, style = "minimal", border = "none",
        focusable = true, noautocmd = true,
    })
    vim.wo[edit.win].wrap = false
    vim.wo[edit.win].winhighlight = "NormalFloat:Normal"
    vim.api.nvim_win_set_cursor(edit.win, { 1, edit.col })
    active = edit
    if anchor then
        local start = math.max(1, anchor[3] - edit.prompt)
        local stop = math.max(1, cursor[3] - edit.prompt)
        if mode == "V" then
            start, stop = 1, math.max(1, #edit.command)
        end
        vim.api.nvim_win_set_cursor(edit.win, { 1, start - 1 })
        vim.cmd.normal({ "v", bang = true })
        vim.api.nvim_win_set_cursor(edit.win, { 1, stop - 1 })
    end
    vim.keymap.set("n", "<Esc>", function() finish(false) end, { buffer = edit.buf })
    vim.keymap.set({ "n", "x", "i" }, "<C-c>", function() finish(true) end, { buffer = edit.buf })
    vim.keymap.set({ "n", "x", "i" }, "<CR>", function()
        -- Enter from insert must let multicursor replay the final insertion.
        edit.persistent = true
        vim.cmd.stopinsert()
        vim.schedule(function()
            if active == edit then finish(false, true) end
        end)
    end, { buffer = edit.buf })
    for _, lhs in ipairs({ "ga", "gA" }) do
        vim.keymap.set({ "n", "x" }, lhs, function()
            edit.persistent = true
            select_matches()
        end, { buffer = edit.buf })
    end
    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
        buffer = edit.buf,
        callback = function()
            vim.schedule(function()
                if active == edit and not edit.persistent and vim.fn.mode() == "n" then
                    finish(false)
                end
            end)
        end,
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
        buffer = edit.buf,
        callback = function()
            if not edit.persistent then
                vim.schedule(function()
                    if active == edit and vim.fn.mode() == "i" then
                        finish(false, false, true)
                    end
                end)
            end
        end,
    })
    -- Closing/switching windows elsewhere also ends this editing session.
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(edit.win), once = true,
        callback = function()
            if active == edit then
                active = nil
                mc.clearCursors()
            end
        end,
    })
    return true
end

local function map_terminal(buf)
    for _, lhs in ipairs({ "i", "a", "I", "A" }) do
        vim.keymap.set("n", lhs, function()
            local edit = command_at_cursor()
            if edit then
                local col = math.min(vim.fn.strchars(edit.command:sub(1, edit.col)), vim.fn.strchars(edit.command))
                if lhs == "a" then col = math.min(col + 1, vim.fn.strchars(edit.command)) end
                if lhs == "A" then col = vim.fn.strchars(edit.command) end
                if lhs == "I" then col = vim.fn.strchars(edit.command:sub(1, (edit.command:find("%S") or 1) - 1)) end
                apply_command(edit.chan, edit.command, col)
            end
            vim.cmd.startinsert()
        end, { buffer = buf })
    end
    for _, lhs in ipairs({ "ga", "gA" }) do
        vim.keymap.set({ "n", "x" }, lhs, function()
            if open(true) then
                select_matches()
            else
                vim.notify("Place the cursor in the current, unwrapped shell command", vim.log.levels.INFO)
            end
        end, { buffer = buf, desc = "Select all command matches inline" })
    end
    local function edit_key(lhs)
        local count, register = vim.v.count, vim.v.register
        if open(false) then
            local keys = '"' .. register .. (count > 0 and tostring(count) or "") .. lhs
            vim.api.nvim_feedkeys(keys, "ni", false)
        else
            vim.notify("Edit the current, unwrapped shell command", vim.log.levels.INFO)
        end
    end
    for _, lhs in ipairs({ "d", "dd", "D", "c", "cc", "C", "s", "S", "x", "X", "r", "R", "p", "P" }) do
        vim.keymap.set("n", lhs, function() edit_key(lhs) end, { buffer = buf })
    end
    for _, lhs in ipairs({ "d", "c", "x", "s" }) do
        vim.keymap.set("x", lhs, function() edit_key(lhs) end, { buffer = buf })
    end
end

function M.setup(opts)
    if vim.fn.fnamemodify(vim.o.shell, ":t") == "zsh" then
        vim.env.NVIM_TERM_SHELL = vim.o.shell
        vim.o.shell = opts.config_dir .. "/zsh/shell"
    end
    mc.setup()
    vim.api.nvim_set_hl(0, "MultiCursorCursor", { reverse = true })
    vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
    local group = vim.api.nvim_create_augroup("terminal-edit", { clear = true })
    vim.api.nvim_create_autocmd("TermRequest", {
        group = group,
        callback = function(ev)
            local message = ev.data.sequence:match("^\27%]777;nvim%-edit;(.*)$")
            if not message then return end
            shells[ev.buf] = shells[ev.buf] or {}
            local shell = shells[ev.buf]
            if message == "start" then shell.editing = true end
            if message == "end" then shell.editing, shell.text = false, nil end
            local cursor, text = message:match("^snapshot;(%d+);(%x*)$")
            if cursor then
                shell.text = text:gsub("%x%x", function(byte) return string.char(tonumber(byte, 16)) end)
                shell.cursor = tonumber(cursor)
                shell.version = (shell.version or 0) + 1
            end
        end,
    })
    vim.api.nvim_create_autocmd("TermLeave", {
        group = group,
        callback = function(ev)
            request_snapshot(ev.buf)
            prompt_rows[ev.buf] = vim.api.nvim_win_get_cursor(0)[1]
        end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        callback = function(ev)
            prompt_rows[ev.buf], shells[ev.buf] = nil, nil
        end,
    })
    vim.api.nvim_create_autocmd("TermOpen", {
        group = group, callback = function(ev) map_terminal(ev.buf) end,
    })
end

return M
