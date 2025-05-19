local M = {}


function M.open_project_terminal()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local term_buf_name = "term://" .. project_name

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == term_buf_name then
            vim.api.nvim_set_current_buf(buf)
            return
        end
    end

    vim.cmd("term")
    vim.api.nvim_buf_set_name(0, term_buf_name)
end

function M.refactor_rename()
    -- when rename opens the prompt, this autocommand will trigger
    -- it will "press" CTRL-F to enter the command-line window `:h cmdwin`
    -- in this window I can use normal mode keybindings
    local cmdId
    cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
        callback = function()
            local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
            vim.api.nvim_feedkeys(key, "c", false)
            vim.api.nvim_feedkeys("0", "n", false)
            -- autocmd was triggered and so we can remove the ID and return true to delete the autocmd
            cmdId = nil
            return true
        end,
    })
    vim.lsp.buf.rename()
    -- if LPS couldn't trigger rename on the symbol, clear the autocmd
    vim.defer_fn(function()
        -- the cmdId is not nil only if the LSP failed to rename
        if cmdId then
            vim.api.nvim_del_autocmd(cmdId)
        end
    end, 500)
end

function M.rename_under_cursor()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace with: ", "")
    if replacement ~= "" then
        vim.cmd(string.format("%%s/%s/%s/g", word, replacement))
    end
end

function M.rename_under_cursor_full_words_only()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace with: ", "")
    if replacement ~= "" then
        vim.cmd(string.format("%%s/\\<%s\\>/%s/g", word, replacement))
    end
end

function M.jump_to_file_location(text)
    local file, line, col = string.match(text, "(.+):(%d+):(%d+)")
    if file and line and col then
        vim.cmd(string.format("edit +call\\ cursor(%d,%d) %s", tonumber(line), tonumber(col), file))
    else
        vim.notify("Failed to parse location: " .. text, vim.log.levels.ERROR)
    end
end

return M
