vim.opt.number = true
vim.opt.relativenumber = true

-- Position of window after split
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

-- Indentation options
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Clipboard stuff
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "cp1251", "ucs-bom", "latin1" }

-- Centered cursor
vim.opt.scrolloff = 999

vim.cmd("language en_US")

-- Allow block select be longer than text on line
vim.opt.virtualedit = "block"

-- Enable find and replace preview
vim.opt.inccommand = "split"

-- Enable extended colors
vim.opt.termguicolors = true

vim.opt.title = true
vim.opt.titlelen = 0
vim.opt.titlestring = "nvim - " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

vim.opt.statusline = "%f > %{%v:lua.require'nvim-navic'.get_location()%} %m %= %p%% [%{fnamemodify(getcwd(), ':t')}]"

-- Extended timeout after leader key
vim.opt.timeout = true
vim.opt.timeoutlen = 60000
