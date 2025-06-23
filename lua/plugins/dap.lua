return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"
            local default_keys = {}

            require("dapui").setup({
                layouts = {
                    -- {
                    --     elements = {
                    --         { id = "stacks", size = 0.3 },
                    --     },
                    --     size = 40,
                    --     position = "left",
                    -- },
                    {
                        elements = {
                            { id = "scopes", size = 0.5 },
                            { id = "repl",   size = 0.5 },
                        },
                        size = 20,
                        position = "bottom",
                    },
                },
                controls = {
                    enabled = false,
                    element = "repl",
                },
                floating = {
                    max_height = nil,
                    max_width = nil,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc><Esc>" },
                    },
                },
                render = {
                    max_type_length = 0,
                }
            })

            require("dap-go").setup()

            require("nvim-dap-virtual-text").setup {
                display_callback = function(variable)
                    if #variable.value > 15 then
                        return " " .. string.sub(variable.value, 1, 15) .. "... "
                    end

                    return " " .. variable.value
                end,
            }

            -- Handled by nvim-dap-go
            -- dap.adapters.go = {
            --   type = "server",
            --   port = "${port}",
            --   executable = {
            --     command = "dlv",
            --     args = { "dap", "-l", "127.0.0.1:${port}" },
            --   },
            -- }

            vim.keymap.set("n", "<space><C-B>", function()
                local cond = vim.fn.input("Condition: ")
                dap.toggle_breakpoint(cond)
            end)
            vim.keymap.set("n", "<space>B", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gB", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<leader>9", dap.continue)
            vim.keymap.set("n", "<leader>7", dap.step_into)
            vim.keymap.set("n", "<leader>8", dap.step_over)
            vim.keymap.set("n", "<leader>(", dap.restart)
            vim.keymap.set("n", "<leader>)", dap.terminate)

            vim.keymap.set('n', '<leader>dkj', dap.down)
            vim.keymap.set('n', '<leader>dkk', dap.up)

            vim.keymap.set("n", "<leader>db", function()
                local breakpoints = {}

                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    local buf_bps = dap.list_breakpoints(bufnr)
                    if buf_bps and #buf_bps > 0 then
                        local filename = vim.api.nvim_buf_get_name(bufnr)
                        for _, bp in ipairs(buf_bps) do
                            local text = "Breakpoint"
                            if bp.condition then
                                text = text .. " (cond: " .. bp.condition .. ")"
                            elseif bp.log_message then
                                text = text .. " (log: " .. bp.log_message .. ")"
                            end
                            table.insert(breakpoints, {
                                filename = filename,
                                lnum = bp.line,
                                col = 1,
                                text = text,
                            })
                        end
                    end
                end

                if #breakpoints == 0 then
                    vim.notify("No breakpoints set", vim.log.levels.INFO)
                    return
                end

                vim.fn.setqflist({}, ' ', {
                    title = 'DAP Breakpoints',
                    items = breakpoints,
                })
                vim.cmd("copen")
            end, { desc = "Show DAP breakpoints in quickfix" })


            vim.keymap.set("n", "<leader>dg", function()
                local uv = vim.loop

                local function get_targets()
                    local results = {}
                    local handle = uv.fs_scandir("cmd")
                    if handle then
                        while true do
                            local name, t = uv.fs_scandir_next(handle)
                            if not name then break end
                            if t == "directory" then
                                table.insert(results, "cmd/" .. name)
                            end
                        end
                    end
                    return results
                end

                local targets = get_targets()
                if #targets == 0 then
                    vim.notify("No targets found in ./cmd/", vim.log.levels.WARN)
                    return
                end

                vim.ui.select(targets, { prompt = "Select Go target to debug" }, function(choice)
                    if not choice then return end

                    dap.run({
                        type = "go",
                        name = "Debug " .. choice,
                        request = "launch",
                        program = "${workspaceFolder}/" .. choice,
                        outputMode = "remote",
                    })
                end)
            end, { desc = "DAP: Choose Go debug target" })


            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
