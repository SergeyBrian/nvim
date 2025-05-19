return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
    cmd = "Telescope",
    keys = {
        { "<leader>ff", function() require("telescope.builtin").find_files() end,                   desc = "Find Files" },
        { "<leader>fw", function() require("telescope.builtin").live_grep() end,                    desc = "Live Grep" },
        { "<leader>fd", function() require("telescope.builtin").lsp_document_symbols() end,         desc = "LSP Document Symbols" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end,                    desc = "Help Tags" },
        { "<leader>fu", function() require("telescope.builtin").lsp_references() end,               desc = "LSP References" },

        { "gB",         function() require("telescope.builtin").lsp_definitions() end,              desc = "LSP Definitions" },
        { "gi",         function() require("telescope.builtin").lsp_implementations() end,          desc = "LSP Implementations" },
        { "gI",         function() require("telescope.builtin").lsp_references() end,               desc = "LSP References" },

        { "<space>fb",  function() require("telescope").extensions.file_browser.file_browser() end, desc = "File Browser" },
    },
    config = function()
        local telescope = require("telescope")
        local te_actions = require("telescope.actions")
        local fb_actions = require "telescope._extensions.file_browser.actions"

        telescope.setup({
            defaults = {
                layout_config = {
                    width = 0.99,
                    height = 0.99,
                    preview_cutoff = 1,
                    prompt_position = "bottom",
                },
                sorting_strategy = "ascending",
                mappings = {
                    n = {
                        ["l"] = te_actions.select_default,
                    }
                },
                pickers = {
                    find_files = {
                        hidden = true
                    }
                },
            },
            extensions = {
                file_browser = {
                    hidden = { file_browser = true, folder_browser = true },
                    dir_icon = "+",
                    hide_parent_dir = true,
                    display_stats = { date = false, size = false, mode = false },
                    mappings = {
                        ["n"] = {
                            ["h"] = fb_actions.goto_parent_dir,
                        },
                    },
                },
            },
        })

        telescope.load_extension("file_browser")
    end,
}

