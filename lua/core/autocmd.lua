vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.tex",
    callback = function()
        local template = vim.fn.expand("~/.config/nvim/templates/latex.tex")
        vim.cmd("0r " .. template)
    end
})
