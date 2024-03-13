local M = {}

function M.split( string, splitPattern )
    local outResults = {}
    local start = 1
    local splitStart, splitEnd = string.find( string, splitPattern, start )

    while splitStart do
        table.insert( outResults, string.sub( string, start, splitStart - 1) )
        start = splitEnd + 1
        splitStart, splitEnd = string.find( string, splitPattern, start )
    end

    table.insert( outResults, string.sub( string, start))
    return outResults
end

return M