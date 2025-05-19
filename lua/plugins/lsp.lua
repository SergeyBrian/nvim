return {
    { "williamboman/mason.nvim",    build = ":MasonUpdate" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    },
    { "nvimtools/none-ls.nvim" },
    { "jayp0521/mason-null-ls.nvim" },
}
