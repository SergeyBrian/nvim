local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local d   = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt


local function node_text(node, bufnr)
    return vim.treesitter.get_node_text(node, bufnr)
end

local function find_enclosing_func(bufnr)
    local node = (vim.treesitter.get_node and vim.treesitter.get_node({ bufnr = bufnr }))
        or (require("nvim-treesitter.ts_utils").get_node_at_cursor())
    if not node then return nil end
    local wanted = { function_declaration = true, method_declaration = true, func_literal = true }
    while node do
        if wanted[node:type()] then return node end
        node = node:parent()
    end
    return nil
end

local function get_result_node(func_node)
    if not func_node then return nil end
    local field = func_node:field("result")
    if field and field[1] then return field[1] end

    for i = 0, func_node:named_child_count() - 1 do
        local ch = func_node:named_child(i)
        if ch:type() == "signature" then
            local r = ch:field("result")
            if r and r[1] then return r[1] end
            for j = 0, ch:named_child_count() - 1 do
                local sj = ch:named_child(j)
                if sj:type() == "parameter_list" then
                    if j == 1 then return sj end
                end
            end
        end
    end
    return nil
end

local function collect_return_types(bufnr)
    local func_node = find_enclosing_func(bufnr)
    if not func_node then return {} end
    local res = get_result_node(func_node)
    if not res then return {} end

    local types = {}
    local function add_type(n)
        table.insert(types, (node_text(n, bufnr):gsub("%s+", " ")))
    end

    if res:type() == "parameter_list" then
        for i = 0, res:named_child_count() - 1 do
            local ch = res:named_child(i)
            if ch:type() == "parameter_declaration" then
                local tnode = ch:field("type")[1]
                if tnode then add_type(tnode) end
            else
                add_type(ch)
            end
        end
    else
        add_type(res)
    end
    return types
end

local function zero_for_type(typ, errname)
    typ = typ:gsub("^%s+", ""):gsub("%s+$", "")
    local simple = typ

    if simple == "error" then
        return errname
    end

    if simple == "string" then return '""' end
    if simple == "bool" then return "false" end
    if simple == "byte" then return "0" end
    if simple == "rune" then return "0" end
    if simple == "uintptr" then return "0" end
    if simple:match("^u?int%d*$") then return "0" end
    if simple:match("^float%d+$") then return "0" end
    if simple:match("^complex%d+$") then return "0" end
    if simple == "time.Duration" then return "0" end

    if simple:match("^%*") then return "nil" end
    if simple:match("^%[%]") then return "nil" end
    if simple:match("^map%s*%[") then return "nil" end
    if simple:match("^chan[%s<%-]") then return "nil" end
    if simple:match("^func%(") then return "nil" end
    if simple == "any" then return "nil" end
    if simple:match("^interface%s*{") then return "nil" end


    if simple:match("^%b[]") and not simple:match("^%[%]") then
        return simple .. "{}"
    end


    return ("*new(%s)"):format(simple)
end

local function make_return_line(errname)
    local bufnr = vim.api.nvim_get_current_buf()
    local types = collect_return_types(bufnr)

    if #types == 0 then
        return "// TODO: handle " .. errname
    end


    local vals = {}
    for _, typ in ipairs(types) do
        table.insert(vals, zero_for_type(typ, errname))
    end


    return "return " .. table.concat(vals, ", ")
end



local function dyn_return(args)
    local errname = (args[1] and args[1][1]) or "err"
    local line = make_return_line(errname)
    return ls.sn(nil, t(line))
end

return {
    s({ trig = "ife", snippetType = "autosnippet" }, fmt([[
if {} != nil {{
	{}
}}
]], {
        i(1, "err"),
        d(2, dyn_return, { 1 }),
    })),
}
