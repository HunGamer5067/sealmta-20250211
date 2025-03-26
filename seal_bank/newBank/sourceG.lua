pedPositions = {
    {1176.9976806641, -1433.5056152344, 22.867500305176, 90, "George White"},
}


function formatMoney(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end