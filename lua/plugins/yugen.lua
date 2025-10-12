return {
    'bettervim/yugen.nvim',
    config = function()
        vim.cmd.colorscheme('yugen')

        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#19191C" })

        vim.api.nvim_set_hl(0, "DiagnosticFloatTitle", { fg = "#C8C093", bold = true })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = "#FF204E" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = "#FFCC00" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = "#7FB4CA" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = "#98BB6C" })

        vim.api.nvim_set_hl(0, "Comment", { fg = "#636363", italic = true })

        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#19191C", fg = "#DCD7BA" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2A2A37", fg = "#DCD7BA" })


        vim.api.nvim_set_hl(0, "Search", { bg = "#3E4452", fg = "#FFFFFF", bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#FFCC00", fg = "#000000", bold = true })

        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98BB6C" })    -- зелёный
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7FB4CA" }) -- голубой
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#FF204E" }) -- красный

        vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#98BB6C", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#7FB4CA", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#FF204E", bold = true })

        vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#1E2A1E" })    -- тёмно-зелёный фон
        vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#1B2730" }) -- тёмно-сине-серый
        vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = "#2A1B1E" }) -- тёмно-красный

        vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#243424" })
        vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#22303A" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#3A2226" })
    end,
}
