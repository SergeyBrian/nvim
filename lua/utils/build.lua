local M = {}

local target_store_path = vim.fn.stdpath('data') .. '/build_targets.json'


local function load_targets()
    local ok, content = pcall(vim.fn.readfile, target_store_path)
    if not ok or not content then return {} end
    local joined = table.concat(content, "\n")
    local decoded = vim.fn.json_decode(joined)
    return decoded or {}
end

local function save_targets(targets)
    local encoded = vim.fn.json_encode(targets)
    local lines = vim.split(encoded, "\n")
    vim.fn.writefile(lines, target_store_path)
end

M.project_targets = load_targets()

M.language_build_commands = {
    go = "go build",
    cpp = "cmake --build",
}

M.project_markers = {
    go = "go.mod",
    cpp = "CMakeLists.txt",
}

local function parse_go_mod()
    local filepath = "go.mod"
    if vim.fn.filereadable(filepath) == 0 then
        return nil
    end

    for _, line in ipairs(vim.fn.readfile(filepath)) do
        local module_name = line:match("^module%s+(.+)")
        if module_name then
            return module_name
        end
    end

    return nil
end

local function empty_target(callback)
    callback("")
end

local function request_go_target(callback)
    local module_name = parse_go_mod()
    if not module_name then
        vim.notify("Failed to parse go.mod", vim.log.levels.ERROR)
        return
    end

    if vim.fn.isdirectory("cmd") == 0 then
        vim.notify("cmd/ directory not found", vim.log.levels.ERROR)
        return
    end

    local cmd_dirs = vim.fn.glob("cmd/*", 0, 1)
    if #cmd_dirs == 0 then
        vim.notify("No subdirectories found in cmd/", vim.log.levels.ERROR)
        return
    end

    vim.ui.select(cmd_dirs, { prompt = "Select build target:" }, function(choice)
        if choice then
            local rel_path = vim.fn.fnamemodify(choice, ":.")
            local full_target = module_name .. "/" .. rel_path
            if callback then
                callback(full_target)
            end
        end
    end)
end

M.target_req_funcs = {
    go = request_go_target,
    cpp = empty_target,
}

local function confirm_target(initial_command, callback)
    vim.cmd('new')
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { initial_command })

    vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = buf,
        once = true,
        callback = function()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local final_command = table.concat(lines, " ")
            if callback then
                callback(final_command)
            end
        end,
    })
end

function M.detect_language()
    for lang, marker in pairs(M.project_markers) do
        if vim.fn.filereadable(marker) == 1 or vim.fn.filereadable("./" .. marker) == 1 then
            return lang
        end
    end
    return nil
end

function M.reset_target()
    local cwd = vim.fn.getcwd()
    M.project_targets[cwd] = nil
end

function M.run_build()
    local lang = M.detect_language()
    if not lang then
        vim.notify("Failed to detect project type", vim.log.levels.WARN)
        return
    end

    local base_command = M.language_build_commands[lang]
    local cwd = vim.fn.getcwd()
    local saved_target = M.project_targets[cwd]
    local target_fn = M.target_req_funcs[lang]

    local function execute_build(final_command)
        if not final_command or final_command == "" then
            vim.notify("No build command specified", vim.log.levels.WARN)
            return
        end

        vim.notify("Running: " .. final_command, vim.log.levels.INFO)
        local all_output = {}

        vim.fn.jobstart(final_command, {
            stdout_buffered = true,
            stderr_buffered = true,
            on_stdout = function(_, data)
                for _, line in ipairs(data or {}) do
                    if line and line ~= "" then
                        table.insert(all_output, line)
                    end
                end
            end,
            on_stderr = function(_, data)
                for _, line in ipairs(data or {}) do
                    if line and line ~= "" then
                        table.insert(all_output, line)
                    end
                end
            end,
            on_exit = function(_, exit_code)
                if exit_code == 0 then
                    vim.cmd('cclose')
                    vim.notify("Successfully built", vim.log.levels.OKAY)
                else
                    vim.notify("Build failed!", vim.log.levels.ERROR)
                    if #all_output > 0 then
                        vim.fn.setqflist({}, 'r', { title = 'Build Output', lines = all_output })
                        vim.cmd('copen')
                    end
                end
            end,
        })
    end

    if saved_target then
        execute_build(saved_target)
    else
        target_fn(function(target)
            if target then
                confirm_target(base_command .. " " .. target, function(res)
                    M.project_targets[cwd] = res
                    save_targets(M.project_targets)
                    execute_build(res)
                end)
            end
        end)
    end
end

return M
