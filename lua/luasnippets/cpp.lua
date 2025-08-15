local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

local function guard_from_path()
    local full = vim.fn.expand("%:p")
    local cwd  = vim.fn.getcwd()
    local esc  = cwd:gsub("([^%w])", "%%%1")

    local rel  = full:gsub("^" .. esc .. "/?", "")
    rel        = rel:gsub("%.[Hh][Pp]?[Pp]$", "")
    local mid  = rel:gsub("[\\%.%-]", "_")
    return ("H" .. mid:upper())
end

return {
    s("gua", {
        trig = "gua",
        snippetType = "autosnippet",
        t("#ifndef "),
        f(guard_from_path, {}),
        t({ "", "#define " }),
        f(guard_from_path, {}),
        t({ "", "", "" }),
        i(0),
        t({ "", "", "#endif // " }),
        f(guard_from_path, {}),
    }),
}
