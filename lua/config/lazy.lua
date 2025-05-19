-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "python" },
                sync_install = false,
                highlight = { enable = true },
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
    },

    {
        "slugbyte/lackluster.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("lackluster-hack")
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        init = function()
            local telescope = require("telescope")
            local te_actions = require("telescope.actions")
            local fb_actions = require "telescope._extensions.file_browser.actions"

            telescope.setup {
                defaults = {
                    mappings = {
                        n = {
                            ["l"] = te_actions.select_default,
                        }
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true
                    }
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
            }
        end,
    },

    -- Treesitter Textobjects
    {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "pylsp", "lua_ls" },
                automatic_installation = true,
            })
        end
    },

    {
        "jayp0521/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = { "prettier", "autoflake", "mypy", "clang-format" },
                automatic_installation = true,
            })
        end
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.mypy.with({
                        extra_args = { "--check-untyped-defs" },
                    }),
                    -- null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.autoflake,
                    null_ls.builtins.formatting.clang_format.with({
                        -- extra_args = { "-style={"BasedOnStyle": "Google", "IndentWidth": 4, "TabWidth": 4, "IndentAccessModifiers": false, "AccessModifierOffset": -4, "DerivePointerAlignment": false, "PointerAlignment": "Right"}" },
                    }),
                },
                on_attach = on_attach,
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    })
                }
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                    { name = "cmdline" }
                })
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.documentFormattingProvider = false
            capabilities.documentRangeFormattingProvider = false

            lspconfig.bashls.setup({})

            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    fallbackFlags = { "--std=c++20" },
                },
            })

            lspconfig.csharp_ls.setup {
                cmd = { "csharp-ls" },
                on_attach = function(client, bufnr)
                end,
            }
            lspconfig.gopls.setup({})

            lspconfig.jdtls.setup({
                cmd = { 'jdtls' },
                root_dir = require('lspconfig').util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
                settings = {
                    java = {
                        project = {
                            referencedLibraries = {
                            }
                        }
                    }
                }
            })
            -- lspconfig.mypy.setup({
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            --     init_options = {
            --         args = { "--check-untyped-defs" },
            --     },
            -- })

            -- lspconfig.jedi_language_server.setup({
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            -- })
            lspconfig.pylsp.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
    },

    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon").setup()
        end,
        keys = {
            { "<leader>A", function() require("harpoon"):list():add() end,     desc = "harpoon file", },
            {
                "<leader>a",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "harpoon quick menu",
            },
            { "<leader>h", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1", },
            { "<leader>j", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2", },
            { "<leader>k", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3", },
            { "<leader>l", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4", },
            { "<leader>;", function() require("harpoon"):list():select(5) end, desc = "harpoon to file 5", },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                signs                        = {
                    add          = { text = "┃" },
                    change       = { text = "┃" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                signs_staged                 = {
                    add          = { text = "┃" },
                    change       = { text = "┃" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                signs_staged_enable          = true,
                signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir                 = {
                    follow_files = true
                },
                auto_attach                  = true,
                attach_to_untracked          = false,
                current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts      = {
                    virt_text = true,
                    virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                    use_focus = true,
                },
                current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
                sign_priority                = 6,
                update_debounce              = 100,
                status_formatter             = nil,   -- Use default
                max_file_length              = 40000, -- Disable if file is longer than this (in lines)
                preview_config               = {
                    -- Options passed to nvim_open_win
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1
                },
            }
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        init = function()
            require("telescope").load_extension("file_browser")
        end,
    },
    {
        "marko-cerovac/material.nvim"
    },
    {
        "rebelot/kanagawa.nvim"
    },
    {
        "NeogitOrg/neogit",
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
    },
    {
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
    },
    {
        'SmiteshP/nvim-navic',
    },
    {
        "lervag/vimtex",
        ft = { "tex" },
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                build_dir = "",
                callback = 1,
                continuous = 1,
                executable = "latexmk",
                options = {
                    "-pdf",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }
        end,
    },
    {
        'vuciv/golf'
    },
})
