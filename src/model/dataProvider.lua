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

    for i=1,#jsonData do
        local entry = jsonData[i]
        local split = stringExt.split(entry.name, " ")
        entry.noTitleName = table.concat(split, " ", 2, #split)
    end

    local dataObject = 
    {
        jsonData = jsonData,
        data = jsonData
    }

    print(dataObject.data[1].noTitleName)

    function dataObject:sort( sortType )
        -- always copy the data being sorted rather than working on the source JSON data
        local sortedData = {}
        for k,v in ipairs(self.data) do
            sortedData[k] = v
        end
        self.data = sortedData
        print( sortedData[1] )
        if ( "nameAZ" == sortType ) then
            table.sort( sortedData, function(a, b) 
                return a.noTitleName < b.noTitleName
            end )
        elseif ( "nameZA" == sortType ) then
                table.sort( sortedData, function(a, b) 
                    return a.noTitleName > b.noTitleName
                end )
        elseif ( "dueAZ" == sortType ) then
            table.sort( sortedData, function(a, b) 
                return a.due < b.due
            end )
        elseif ( "dueZA" == sortType) then
            table.sort( sortedData, function(a, b) 
                return a.due > b.due
            end )
        elseif ( "outstandingAZ" == sortType ) then
            table.sort( sortedData, function(a, b) 
                return a.outstanding < b.outstanding
            end )
        elseif ( "outstandingZA" == sortType) then
            table.sort( sortedData, function(a, b) 
                return a.outstanding > b.outstanding
            end )
        end
    end

    dataObject:sort( "nameAZ" )

    for i=1,#dataObject.data do
        local entry = dataObject.data[i]
        local encoded = json.encode( entry, { withIndent=true} )
        print( encoded )
    end

    return dataObject
end

return M