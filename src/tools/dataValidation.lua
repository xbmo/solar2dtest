local json = require( "json" )
local stringExt = require( "src.utils.stringExtensions")

local M  = {}

function M.new()

    local path = system.pathForFile( "data/SampleJson.json", system.ResourceDirectory )

    local file, errorString = io.open( path, "r" )

    if not file then
        print("File error: " .. errorString )
        return
    end

    local jsonString = file:read( "*a" )

    io.close( file )
    file = nil

    local jsonData, pos, msg = json.decode( jsonString )
    if not jsonData then
        print( "Failed to decode json. Error at "..tostring(pos)..": "..tostring(msg) )
        return
    end

    -- Stores all the titles used in the document. Used to check for new titles being added, or to see if some names are entered without a title
    local titleTable = {}

    for i=1,#jsonData do
        local entry = jsonData[i]
        local split = stringExt.split(entry.name, " ")
        local title = split[1]
        local count = titleTable[title] or 0
        titleTable[title] = count + 1
    end

    print("Printing all titles used in the JSON file.")
    for key, val in pairs( titleTable ) do
        print(key.." = "..tostring(val))
    end
end

return M