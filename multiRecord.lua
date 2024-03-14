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

 local headerControlPosY = scrollViewAnchorTop - 50

 local textColor1 = { 0.16, 0.29, 0.38, 1 }
 local buttonColorRegular = { 0.09, 0.72, 0.69, 1 }
 local buttonColorDown = { 1 }
 local dueColor = { 1, 0, 0}
 local outstandingColor = { .9, .7, 0}

 local model

 local function detailedItemRenderer( group, index, width, height )
    local contentImage = display.newImageRect( group, "img/rounded_rectangle_glow.png", width+20, height+20)
    contentImage.alpha = 0.25
    local innerImage = display.newImageRect( group, "img/rounded_rectangle.png", width, height )
    innerImage:setFillColor(0.95)

    local entry = model.data[ index ]

    local avatarImage = display.newImageRect( group, "img/avatar.png", 80, 80 )
    avatarImage.x = -width * 0.5 + 60

    local marginLeft = 110
    local nameText = display.newText( 
        {
            parent = group,
            text = entry.noTitleName,
            x = marginLeft,
            y = -10,
            width = width,
            font = native.systemFont,
            fontSize = 18,
            align = "left"
        }
    )
    nameText:setFillColor(unpack(textColor1))

    local roomText = display.newText( 
        {
            parent = group,
            text = entry.room,
            x = marginLeft,
            y = nameText.y + nameText.height + 3,
            width = width,
            font = native.systemFont,
            fontSize = 14,
            align = "left"
        }
    )
    roomText:setFillColor(unpack(textColor1))

    if (entry.due > 0) then
        local dueBackground = display.newRoundedRect( group, width / 2 - 30, -36, 28, 20, 5 )
        dueBackground:setFillColor(unpack(dueColor))

        local dueText = display.newText( group, tostring(entry.due), dueBackground.x, dueBackground.y, native.systemFont, 12)
    end

    if (entry.oustanding > 0) then
        local positionX = width / 2 - 30
        if entry.due > 0 then
            positionX = positionX - 36
        end
        local dueBackground = display.newRoundedRect( group, positionX, -36, 28, 20, 5 )
        dueBackground:setFillColor(unpack(outstandingColor))

        local dueText = display.newText( group, tostring(entry.oustanding), dueBackground.x, dueBackground.y, native.systemFont, 12)
    end

    return contentImage
 end

 local function createSortButton( labelText, positionLeft, width, onClick )
    widget.newButton(
        {
            left = positionLeft,
            top = headerControlPosY,
            width = width,
            height = 32,
            label = labelText,
            shape = "roundedRect",
            labelColor = { default={ 1 }, over=buttonColorRegular },
            fillColor = { default=buttonColorRegular, over=buttonColorDown },
            strokeColor = {default=buttonColorRegular, over=buttonColorRegular},
            strokeWidth = 2,
            onEvent = onClick
        }
    )
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
    local buttonWidthPlusSpacing = buttonWidth + buttonSpacing
    local buttonStartPos = scrollViewAnchorLeft + 10

    -- TODO - place these into a horizontal layout group so that the position of each button doesn't need to be specified and maintained
    -- Sort A-z button
    createSortButton( "Name A-z", buttonStartPos, buttonWidth, function( event ) sortButtonEvent( "nameAZ", event) end)
    -- Sort Z-a button
    createSortButton( "Name Z-a", buttonStartPos + buttonWidthPlusSpacing, buttonWidth, function( event ) sortButtonEvent( "nameZA", event) end)
    -- Sort due ascending button
    createSortButton( "Due >", buttonStartPos + buttonWidthPlusSpacing * 2, buttonWidth, function( event ) sortButtonEvent( "dueAZ", event) end)
    -- Sort due descending button
    createSortButton( "Due <", buttonStartPos + buttonWidthPlusSpacing * 3, buttonWidth, function( event ) sortButtonEvent( "dueZA", event) end)
    -- Sort outstanding ascending button
    createSortButton( "Outstanding >", buttonStartPos + buttonWidthPlusSpacing * 4, buttonWidth, function( event ) sortButtonEvent( "outstandingAZ", event) end)
    -- Sort outstanding descending button
    createSortButton( "Outstanding <", buttonStartPos + buttonWidthPlusSpacing * 5, buttonWidth, function( event ) sortButtonEvent( "outstandingZA", event) end)
 end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    local background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0.9 )

    local headerGroup = display.newGroup()
    local headerBackground = display.newRoundedRect( headerGroup, display.contentCenterX, scrollViewAnchorTop * 0.5, display.contentWidth - 20, scrollViewAnchorTop - 20, 5 )
    headerBackground:setFillColor( 1 )

    local logo = display.newImageRect( headerGroup, "img/company_logo.png", 54, 49 )
    logo.x = 50
    logo.y = 40

    -- Title text
    local titleText = display.newText( 
        {
            parent = headerGroup,
            text = "Multi-Record",
            x = 230,
            y = 40,
            font = native.systemFont,
            fontSize = 48,
            align = "left"
        }
    )
    titleText:setFillColor(unpack(textColor1))

    model = dataProvider.new()

    local gridView = gridViewControl.new(
        {
            top = scrollViewAnchorTop,
            left = scrollViewAnchorLeft,
            width = scrollViewWidth,
            height = scrollViewHeight,
            itemWidth = 242,
            itemHeight = 120,
            spacingX = 5,
            spacingY = 5,
            numItems = model:getNumEntries(),
            itemRenderer = detailedItemRenderer
        }
    )

    createSortButtons( gridView )

    local function filterInputListener( event )
        if ( "submitted" == event.phase or "ended" == event.phase ) then
            model:filterData( event.target.text )
            gridView:refresh(model:getNumEntries())
        end
    end

    local filterWidth = 300
    local filterField = native.newTextField( display.contentWidth - filterWidth / 2 - 20, headerControlPosY + 16, filterWidth, 32 )
    filterField:addEventListener( "userInput", filterInputListener)

    local sortHeaderText = display.newText( 
        {
            parent = headerGroup,
            text = "Sort",
            x = 40,
            y = 88,
            font = native.systemFont,
            fontSize = 18,
            align = "left"
        }
    )
    sortHeaderText:setFillColor(unpack(textColor1))

    local filterHeaderText = display.newText( 
        {
            parent = headerGroup,
            text = "Filter",
            x = display.contentWidth - 300,
            y = 88,
            font = native.systemFont,
            fontSize = 18,
            align = "left"
        }
    )
    filterHeaderText:setFillColor(unpack(textColor1))
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