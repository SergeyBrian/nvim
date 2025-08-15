local on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "cs" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end
    if client.server_capabilities.documentSymbolProvider then
        local navic = require("nvim-navic")
        navic.attach(client, bufnr)
    end
    if client.supports_method("textDocument/formatting") then
        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    async = false,
                })
            end,
        })
    end
end

require("mason").setup()

local lspconfig = require("lspconfig")

local servers = {
    gopls = { on_attach = on_attach },
    clangd = {
        on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
            on_attach(client, bufnr)
        end,
        init_options = {
            fallbackFlags = { "--std=c++20" },
        },
    },
    pyright = { on_attach = on_attach },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
                format = { enable = true },
            },
        },
        on_attach = on_attach,
    },
    jsonls = { on_attach = on_attach },
    ts_ls = { on_attach = on_attach },
}

for server, config in pairs(servers) do
    lspconfig[server].setup(config)
end

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,     -- JS, JSON
        null_ls.builtins.formatting.black,        -- Python
        null_ls.builtins.formatting.clang_format, -- C/C++
    },
})

require("mason-null-ls").setup({
    ensure_installed = { "clang-format" },
    automatic_installation = true,
})
