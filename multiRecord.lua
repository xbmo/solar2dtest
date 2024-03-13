local composer = require( "composer" )
local widget = require( "widget" )
local gridViewControl = require ( "src.controls.gridView" )
local dataProvider = require( "src.model.dataProvider" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local scrollViewAnchorLeft = 10
 local scrollViewAnchorTop = 150
 local scrollViewWidth = display.contentWidth - scrollViewAnchorLeft - 10
 local scrollViewHeight = display.contentHeight - scrollViewAnchorTop - 10

 local model

 local function detailedItemRenderer( group, index, width, height )
    local contentImage = display.newImageRect( group, "img/rounded_rectangle.png", width, height )
    contentImage:setFillColor(0.75)

    local entry = model.data[ index ]

    local marginLeft = 20
    display.newText( 
        {
            parent = group,
            text = entry.noTitleName,
            x = marginLeft,
            y = -16,
            width = width,
            font = native.systemFont,
            fontSize = 24,
            align = "left"
        }
    )

    return contentImage
 end

 local function createSortButtons( gridView )

    local function sortButtonEvent( sortType, event )
        if "ended" == event.phase then
            model:sort( sortType )
            gridView:refresh(model:getNumEntries())
        end
    end

    local buttonWidth = 100
    local buttonSpacing = 10
    local buttonPos = scrollViewAnchorLeft
    -- Sort A-z button
    widget.newButton(
        {
            left = buttonPos,
            top = scrollViewAnchorTop - 40,
            width = 100,
            height = 32,
            label = "Name A-z",
            shape = "roundedRect",
            fillColor = { default={0.9}, over={0.1} },
            onEvent = function( event ) sortButtonEvent( "nameAZ", event ) end
        }
    )

    buttonPos = buttonPos + buttonWidth + buttonSpacing
    -- Sort Z-a button
    widget.newButton(
        {
            left = buttonPos,
            top = scrollViewAnchorTop - 40,
            width = 100,
            height = 32,
            label = "Name Z-a",
            shape = "roundedRect",
            fillColor = { default={0.9}, over={0.1} },
            onEvent = function( event ) sortButtonEvent( "nameZA", event ) end
        }
    )

    buttonPos = buttonPos + buttonWidth + buttonSpacing
    -- Sort Due ascending button
    widget.newButton(
        {
            left = buttonPos,
            top = scrollViewAnchorTop - 40,
            width = 100,
            height = 32,
            label = "Due >",
            shape = "roundedRect",
            fillColor = { default={0.9}, over={0.1} },
            onEvent = function( event ) sortButtonEvent( "dueAZ", event ) end
        }
    )

    buttonPos = buttonPos + buttonWidth + buttonSpacing
    -- Sort Due descending button
    widget.newButton(
        {
            left = buttonPos,
            top = scrollViewAnchorTop - 40,
            width = 100,
            height = 32,
            label = "Due <",
            shape = "roundedRect",
            fillColor = { default={0.9}, over={0.1} },
            onEvent = function( event ) sortButtonEvent( "dueZA", event ) end
        }
    )

    buttonPos = buttonPos + buttonWidth + buttonSpacing
    -- Sort outstanding ascending button
    widget.newButton(
        {
            left = buttonPos,
            top = scrollViewAnchorTop - 40,
            width = 100,
            height = 32,
            label = "Outstanding >",
            shape = "roundedRect",
            fillColor = { default={0.9}, over={0.1} },
            onEvent = function( event ) sortButtonEvent( "outstandingAZ", event ) end
        }
    )

    buttonPos = buttonPos + buttonWidth + buttonSpacing
    -- Sort outstanding ascending button
    widget.newButton(
        {
            left = buttonPos,
            top = scrollViewAnchorTop - 40,
            width = 100,
            height = 32,
            label = "Outstanding <",
            shape = "roundedRect",
            fillColor = { default={0.9}, over={0.1} },
            onEvent = function( event ) sortButtonEvent( "outstandingZA", event ) end
        }
    )
 end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    local background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0.5 )

    model = dataProvider.new()

    local gridView = gridViewControl.new(
        {
            top = scrollViewAnchorTop,
            left = scrollViewAnchorLeft,
            width = scrollViewWidth,
            height = scrollViewHeight,
            itemWidth = 320,
            itemHeight = 120,
            spacingX = 10,
            spacingY = 10,
            numItems = model:getNumEntries(),
            itemRenderer = detailedItemRenderer
        }
    )

    createSortButtons( gridView )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene