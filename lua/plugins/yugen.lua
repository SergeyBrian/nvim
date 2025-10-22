return {
    'bettervim/yugen.nvim',
    config = function()
        -- vim.cmd.colorscheme('yugen')

        -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#19191C" })

        -- vim.api.nvim_set_hl(0, "DiagnosticFloatTitle", { fg = "#C8C093", bold = true })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = "#FF204E" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = "#FFCC00" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = "#7FB4CA" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = "#98BB6C" })

        vim.api.nvim_set_hl(0, "String", { fg = "#7bd1ba" })
        vim.api.nvim_set_hl(0, "Type", { fg = "#d6a35e" })

        vim.api.nvim_set_hl(0, "Comment", { fg = "#7e7e7e", italic = true })

        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#19191C", fg = "#DCD7BA" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2A2A37", fg = "#DCD7BA" })


        vim.api.nvim_set_hl(0, "Search", { bg = "#3E4452", fg = "#FFFFFF", bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#FFCC00", fg = "#000000", bold = true })

        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98BB6C" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7FB4CA" })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#FF204E" })

        vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#98BB6C", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#7FB4CA", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#FF204E", bold = true })

        vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#1E2A1E" })
        vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#1B2730" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = "#2A1B1E" })

        vim.api.nvim_set_hl(0, "GitSignsAddInline", { fg = "#98BB6C" })
        vim.api.nvim_set_hl(0, "GitSignsChangeInline", { fg = "#7FB4CA" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { fg = "#FF204E" })

        vim.api.nvim_set_hl(0, "Normal", { bg = "#171c17", fg = "#ded5bd" })

        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#b5ae9c", fg = "#232419" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#1a1a1a", fg = "#777777" })
    end,
}
