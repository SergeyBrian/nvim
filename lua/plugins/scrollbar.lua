return {
    'petertriho/nvim-scrollbar',
    dependencies = {
        "kevinhwang91/nvim-hlslens", -- Optional: Makes search highlights visible in scrollbar
    },
    config = function()
        require("scrollbar").setup({
            handle = {
                text = " ",  -- Makes the scrollbar itself invisible
                blend = 100, -- 100% transparency (completely hides the scrollbar)
            },
            marks = {
                Cursor = {
                    text = "–",
                    priority = 0,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "Normal",
                },
                Search = {
                    text = { "-", "=" },
                    priority = 1,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "Search",
                },
                Error = {
                    text = { "!", "=" },
                    priority = 2,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "DiagnosticVirtualTextError",
                },
                Warn = {
                    text = { "!", "=" },
                    priority = 3,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "DiagnosticVirtualTextWarn",
                },
                Info = {
                    text = { "-", "=" },
                    priority = 4,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "DiagnosticVirtualTextInfo",
                },
                Hint = {
                    text = { "-", "=" },
                    priority = 5,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "DiagnosticVirtualTextHint",
                },
                Misc = {
                    text = { "-", "=" },
                    priority = 6,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "Normal",
                },
                GitAdd = {
                    text = "+",
                    priority = 7,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "GitSignsAdd",
                },
                GitChange = {
                    text = "*",
                    priority = 7,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "GitSignsChange",
                },
                GitDelete = {
                    text = "-",
                    priority = 7,
                    gui = nil,
                    color = nil,
                    cterm = nil,
                    color_nr = nil, -- cterm
                    highlight = "GitSignsDelete",
                },
            },
            handlers = {
                diagnostic = true, -- Show LSP errors/warnings
                gitsigns = true,   -- Show Git changes
                search = true,     -- Show search results
            }
        })
    end
}
