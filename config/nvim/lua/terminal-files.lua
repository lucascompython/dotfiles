local M = {}

local function restore_terminal(data)
    vim.schedule(function()
        if data.restored or not data.terminal or not vim.api.nvim_buf_is_valid(data.terminal) then return end
        -- QuitPre also fires for a quit that gets rejected, such as E37.
        -- Keep the file focused until its window has actually been closed.
        if data.edit_window and vim.api.nvim_win_is_valid(data.edit_window)
            and vim.api.nvim_win_get_buf(data.edit_window) == data.edit_buffer then return end
        data.restored = true
        local win = data.window
        if not win or not vim.api.nvim_win_is_valid(win)
            or vim.api.nvim_win_get_buf(win) ~= data.terminal then
            win = vim.fn.win_findbuf(data.terminal)[1]
        end
        if win then
            vim.api.nvim_set_current_win(win)
        else
            vim.cmd.tabnew()
            vim.api.nvim_win_set_buf(0, data.terminal)
        end
        vim.cmd.startinsert()
    end)
end

local function find_terminal(pid)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" then
            local ok, job_pid = pcall(vim.fn.jobpid, vim.bo[buf].channel)
            if ok and job_pid == pid then return buf end
        end
    end
end

function M.setup()
    require("flatten").setup({
        -- Keep the terminal tab alive, so :wq closes only the file edit.
        window = { open = "tab" },
        hooks = {
            should_block = function() return true end,
            guest_data = function()
                return { shell_pid = vim.uv.os_getppid() }
            end,
            pre_open = function(opts)
                local data = opts.data
                local terminal = find_terminal(data.shell_pid)
                if not terminal and vim.bo.buftype == "terminal" then
                    terminal = vim.api.nvim_get_current_buf()
                end
                if terminal then
                    data.terminal = terminal
                    data.window = vim.fn.win_findbuf(terminal)[1]
                end
                vim.cmd.stopinsert()
            end,
            post_open = function(opts)
                vim.cmd.stopinsert()
                opts.data.edit_window, opts.data.edit_buffer = opts.winnr, opts.bufnr
                vim.api.nvim_create_autocmd("WinClosed", {
                    pattern = tostring(opts.winnr), once = true,
                    callback = function() restore_terminal(opts.data) end,
                })
            end,
            block_end = function(opts)
                restore_terminal(opts.data)
            end,
        },
    })
end

return M
