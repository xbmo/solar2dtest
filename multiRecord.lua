local composer = require( "composer" )
local widget = require( "widget" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local scrollViewAnchorLeft = 10
 local scrollViewAnchorTop = 100
 local scrollViewWidth = display.contentWidth - scrollViewAnchorLeft - 10
 local scrollViewHeight = display.contentHeight - scrollViewAnchorTop - 10
 local scrollViewPadding = 10
 local scrollViewPaddingHorizontal = scrollViewPadding * 2
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    local background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0.5 )

    local scrollView = widget.newScrollView(
        {
            top = scrollViewAnchorTop,
            left = scrollViewAnchorLeft,
            width = scrollViewWidth,
            height = scrollViewHeight,
            horizontalScrollDisabled = true
        }
    )

    local contentHeight = 120
    for i=1,10 do
        local contentImage = display.newImageRect( sceneGroup, "img/rounded_rectangle.png", scrollViewWidth - scrollViewPaddingHorizontal, contentHeight )
        contentImage.x = contentImage.width * 0.5
        contentImage.y = contentHeight * 0.5 + ((i - 1) * contentHeight + 10)
        contentImage:setFillColor(1, 0, 0)
        scrollView:insert(contentImage)
    end
 
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