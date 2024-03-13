local widget = require( "widget" )

local M = {}

local function provideContent( group, index, width, height )
    local contentImage = display.newImageRect( group, "img/rounded_rectangle.png", width, height )
    if index % 2 == 0 then
        contentImage:setFillColor(1, 0, 0)
    else
        contentImage:setFillColor(0, 1, 0)
    end

    local marginLeft = 20
    display.newText( 
        {
            parent = group,
            text = "Item " .. index,
            x = marginLeft,
            y = 0,
            width = width,
            font = native.systemFont,
            fontSize = 24,
            align = "left"
        }
    )

    return contentImage
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

    local scrollView = widget.newScrollView(
        {
            top = top,
            left = left,
            width = width,
            height = height,
            horizontalScrollDisabled = true
        }
    )

    local itemsPerRow = math.floor(width / itemWidth)
    local numRows = math.ceil(numItems / itemsPerRow)

    scrollView:setScrollHeight(numRows * itemHeight + (numRows * spacingY))

    local startOffsetX = 0
    local startOffsetY = 0

    scrollView.contentItems = {}

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
        provideContent( contentGroup, i, itemWidth, itemHeight )

        -- Insert into the scroll view widget visuals, and data structure
        scrollView:insert(contentGroup)
        table.insert( scrollView.contentItems, contentGroup )
    end

    return scrollView
end

return M