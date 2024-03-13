local composer = require( "composer" )

local doValidation = false
if (doValidation) then
    local dataValidation = require( "src.tools.dataValidation" )
    dataValidation.new()
end

display.setStatusBar( display.HiddenStatusBar )

composer.gotoScene( "multiRecord" )

