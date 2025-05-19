local funcs = require("utils.funcs")
local build = require("utils.build")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<Esc>", function()
    vim.cmd.nohlsearch() -- clear highlights
    vim.cmd.echo()       -- clear short-message
end)

-- LSP Actions
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action", silent = true })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show Diagnostics", silent = true })
vim.keymap.set("n", "<leader>m", vim.lsp.buf.format, { desc = "LSP Format", silent = true })
vim.keymap.set('n', '<leader>ww', '<C-w>w', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set("n", "<leader>T", funcs.open_project_terminal, { desc = "Open Project Terminal" })

-- Better renaming
vim.keymap.set("n", "<leader>r", funcs.refactor_rename, { noremap = true, silent = true, desc = "LSP rename" })
vim.keymap.set("n", "<leader>R", funcs.rename_under_cursor,
    { noremap = true, silent = true, desc = "Find and replace under cursor" })
vim.keymap.set("n", "<leader>wR", funcs.rename_under_cursor_full_words_only,
    { noremap = true, silent = true, desc = "Find and replace under cursor full words only" })

vim.keymap.set("n", "<leader>gf", function()
    local word = vim.fn.expand("<cWORD>")
    funcs.jump_to_file_location(word)
end, { desc = "Jump to file:line:col" })

vim.keymap.set('n', '<leader>b', function()
    build.run_build()
end, { desc = "Build project" })
vim.keymap.set('n', '<leader>B', function()
    build.reset_target()
    build.run_build()
end, { desc = "Clean build" })
