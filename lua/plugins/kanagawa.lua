return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    config = function()
        require("kanagawa").setup({
            -- любые параметры
        })
        vim.cmd.colorscheme("kanagawa-dragon")
    end,
}
