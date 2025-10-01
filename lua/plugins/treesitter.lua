return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "go", "toml", "yaml", "bash", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "python" },
            sync_install = false,
            highlight = { enable = false },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Leader>ss",
                    node_incremental = "<Leader>si",
                    scope_incremental = "<Leader>sc",
                    node_decremental = "<Leader>sd",
                },
            },
        })
    end
}
