---Iterate over a table. Unlike ipairs, does not return an index.
---@param t table
---@return function
function All(t)
    local i = 0
    local n = #t
    return function()
        i = i + 1
        if i <= n then return t[i] end
    end
end
