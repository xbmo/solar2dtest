local widget = require( "widget" )

local M = {}

local function defaultItemRenderer( group, index, width, height )
    local contentImage = display.newRect( group, 0, 0, width, height )
    if index % 2 == 0 then
        contentImage:setFillColor(1, 0, 0)
    else
        contentImage:setFillColor(0, 1, 0)
    end
end

function M.new(options)

    options = options or {}
    local left = options.left or 0
    local top = options.top or 0
    local width = options.width or 100
    local height = options.height or 100
    local itemWidth = options.itemWidth or 100
    local itemHeight = options.itemHeight or 100
    local spacingX = options.spacingX or 0
    local spacingY = options.spacingY or 0
    local numItems = options.numItems or 0
    local itemRenderer = options.itemRenderer or defaultItemRenderer

    local scrollView = widget.newScrollView(
        {
            top = top,
            left = left,
            width = width,
            height = height,
            horizontalScrollDisabled = true
        }
    )

    scrollView.itemRenderer = itemRenderer

    local startOffsetX = 0
    local startOffsetY = 0

    function scrollView:refresh( numItems )

        self.contentItems = self.contentItems or {}
        numItems = numItems or #self.contentItems

        for i=#self.contentItems,1,-1 do
            local item = self.contentItems[i]
            self:remove( item )
            item:removeSelf()
        end

        self.contentItems = {}

        local itemsPerRow = math.floor(width / itemWidth)
        local numRows = math.ceil(numItems / itemsPerRow)
    
        local contentHeight = numRows * itemHeight + (numRows * spacingY)
        self:setScrollHeight(contentHeight)

        for i=1,numItems do 
            local contentGroup = display.newGroup()
    
            -- Set up anchors for child objects
            contentGroup.anchorX = 0
            contentGroup.anchorY = 0
            contentGroup.anchorChildren = true
    
            -- Calculate the position of this item
            local index = i - 1
            local row = math.floor(index / itemsPerRow)
            contentGroup.x = startOffsetX + (index % itemsPerRow) * (itemWidth + spacingX)
            contentGroup.y = startOffsetY + row * (itemHeight + spacingY)
    
            -- Use a callback to display content for this item
            self.itemRenderer( contentGroup, i, itemWidth, itemHeight )
    
            -- Insert into the scroll view widget visuals, and data structure
            self:insert( contentGroup )
            table.insert( self.contentItems, contentGroup )
        end
        
        -- Move the scroll position if the new content is shorter than the current scroll position
        local scrollX, scrollY = self:getContentPosition()
        if math.abs(scrollY) > contentHeight then
            self:scrollToPosition( { y = 0, time = 100 })
        end
    end

    scrollView:refresh( numItems )

    return scrollView
end

return M