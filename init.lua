vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true


vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "cp1251", "ucs-bom", "latin1" }

vim.opt.scrolloff = 999
vim.cmd("language en_US")

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.termguicolors = true

require("config.lazy")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fd", builtin.lsp_document_symbols, { desc = "Telescope lsp document symbols" })
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
-- vim.cmd.colorscheme("material")
-- require("material.functions").change_style("deep ocean")
vim.cmd.colorscheme("kanagawa-dragon")

vim.keymap.set("n", "<Esc>", function()
    vim.cmd.nohlsearch() -- clear highlights
    vim.cmd.echo()       -- clear short-message
end)

require("plugins.plugins")
vim.keymap.set('n', '<leader>fu', ':lua require("telescope.builtin").lsp_references()<CR>',
    { noremap = true, silent = true })
vim.keymap.set('n', 'gB', ':lua require("telescope.builtin").lsp_definitions()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gi', ':lua require("telescope.builtin").lsp_implementations()<CR>',
    { noremap = true, silent = true })
vim.keymap.set('n', 'gI', ':lua require("telescope.builtin").lsp_references()<CR>',
    { noremap = true, silent = true })
-- vim.keymap.set('n', 'gd', ':lua require("telescope.builtin").lsp_references()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cd', function() vim.diagnostic.open_float() end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>gd', ':lua require("gitsigns").preview_hunk()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gb', ':lua require("gitsigns").blame_line()<CR>',
    { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gz', ':lua require("gitsigns").reset_hunk()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>m', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<space>fb", function()
    require("telescope").extensions.file_browser.file_browser()
end)

vim.keymap.set("n", "<leader>r", function()
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
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>R", function()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace with: ", "")
    if replacement ~= "" then
        vim.cmd(string.format("%%s/%s/%s/g", word, replacement))
    end
end, { noremap = true, silent = true })


vim.keymap.set("n", "<leader>wR", function()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace with: ", "")
    if replacement ~= "" then
        vim.cmd(string.format("%%s/\\<%s\\>/%s/g", word, replacement))
    end
end, { noremap = true, silent = true })


local function paste_without_comments()
    local text = vim.fn.getreg("+")
    local commentstring = vim.api.nvim_buf_get_option(0, 'commentstring')

    local prefix = commentstring:match("^(.-)%s*%%s")

    if prefix == nil or prefix == '' then
        prefix = "#"
    end

    local filtered = {}
    for line in text:gmatch("[^\r\n]+") do
        if not line:match("^%s*" .. vim.pesc(prefix)) then
            table.insert(filtered, line)
        end
    end

    local cleaned = table.concat(filtered, "\n")
    vim.api.nvim_put(vim.split(cleaned, '\n'), 'l', true, true)
end

vim.keymap.set('n', '<leader>pc', paste_without_comments,
    { noremap = true, silent = true, desc = 'Paste without comments' })

vim.keymap.set('n', '<leader>G', ':ClangdSwitchSourceHeader<CR>',
    { noremap = true, silent = true, desc = 'Switch between header and source files' })

vim.keymap.set('n', '<leader>gg', ':Neogit<CR>')

vim.keymap.set('n', '<leader>dx', ':DiffviewClose<CR>', { noremap = true, silent = true })

vim.o.title = true
vim.o.titlelen = 0
vim.o.titlestring = "nvim - " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

vim.o.statusline = "%f > %{%v:lua.require'nvim-navic'.get_location()%} %m %= %p%% [%{fnamemodify(getcwd(), ':t')}]"

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.tex",
    callback = function()
        local template = vim.fn.expand("~/.config/nvim/templates/latex.tex")
        vim.cmd("0r " .. template)
    end
})

vim.o.timeout = true
vim.o.timeoutlen = 60000

vim.api.nvim_set_keymap('n', '<leader>ww', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
