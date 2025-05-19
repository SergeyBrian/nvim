return {
    "NeogitOrg/neogit",
    keys = {
        vim.keymap.set("n", "<leader>gg", function() require("neogit").open() end, { desc = "Open Neogit" })
    },
    dependencies = {
        "nvim-lua/plenary.nvim",  -- required
        "sindrets/diffview.nvim", -- optional - Diff integration

        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim", -- optional
        "ibhagwan/fzf-lua",              -- optional
        "echasnovski/mini.pick",         -- optional
    },
    config = function()
        require('neogit').setup({
            integrations = {
                diffview = true,                -- Enables diffview.nvim integration
            },
            disable_commit_confirmation = true, -- Optional: Removes extra commit confirmation step
            auto_refresh = true,                -- Ensures UI refreshes properly
            on_checkout = function()
                -- Automatically reload all open buffers after switching branches
                vim.cmd("checktime")
            end
        })

        -- Also ensure buffer reloads on Neogit status refresh
        vim.api.nvim_create_autocmd("User", {
            pattern = {
                "NeogitBranchCheckout",
                "NeogitPullComplete",
                "NeogitBranchCreate",
                "NeogitBranchReset",
                "NeogitCherryPick",
                "NeogitMerge",
                "NeogitStash"
            },
            callback = function()
                vim.cmd("checktime") -- Reloads buffers if changed externally
            end,
        })
    end
}
