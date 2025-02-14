function loadTextures()
    love.graphics.setDefaultFilter("nearest")

    waterTileTexture = love.graphics.newImage("assets/tiles/water.png")
    grassTileTexture = love.graphics.newImage("assets/tiles/grass.png")
    emptyTileTexture = love.graphics.newImage("assets/tiles/air.png")
    sandTileTexture = love.graphics.newImage("assets/tiles/sand.png")
    stoneTileTexture = love.graphics.newImage("assets/tiles/stone.png")

end

function isValidArrayPos(x, y, Array2D)
    if (y > #Array2D) or (y < 1) or (x > #Array2D[1]) or (x < 1) then
        return false
    else
        return true
    end
end

function getDistance(start, stop)
    return math.sqrt((start.x-stop.x)^2+(start.y-stop.y)^2)
end

function collid(x1, y1, sizeX1, sizeY1, x2, y2, sizeX2, sizeY2)
    collided = false

    if (x1 < x2+sizeX2)
    and (x1+sizeX1 > x2)
    and (y1 < y2+sizeY2)
    and (y1+sizeY1 > y2) then
        collided = true
    end

    return collided
end

function mouseCollid(x, y, sizeX, sizeY)
    collided = false

    collid(MouseX, MouseY, 1, 1, x, y, sizeX, sizeY)

    return collided
end

function parseListString(stringList)
    local parsedCommand = {""}
    j = 1
    for i = 1, #stringList do
        if stringList[i] == " " then
            j = j + 1
            parsedCommand[j] = ""
        else
            parsedCommand[j] = parsedCommand[j]..stringList[i]
        end
    end
    return parsedCommand
end

function isinWindow(chunk)
    if (World.x+chunk.x < CurrentWindowWidth)
    and (World.x+chunk.x+(tileSize*chunkSize) > -100)
    and (World.y+chunk.y < CurrentWindowHeight)
    and (World.y+chunk.y+(tileSize*chunkSize) > -100) then
        isInWindow = true
    else
        isInWindow = false
    end

    return isInWindow
end

function InitUI()
    buttons = {}
    button_1_Text = "PLAY"
    buttons[1] = button.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(button_1_Text)/2), y = (WindowHeight/2)-(font:getHeight()/2), text = button_1_Text, bgColor = {1,1,1,1}, static = true}) 
    button_2_Text = "START"
    buttons[2] = button.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(button_2_Text)/2), y = (WindowHeight/2)-(font:getHeight()/2)+font:getHeight()+2, text = button_2_Text, bgColor = {1,1,1,1}, static = true})

    textBoxs = {}
    textBoxEmpty = "World Size"
    textBoxs[1] = textBox.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(textBoxEmpty)/2), y = (WindowHeight/2)-(font:getHeight()/2), text = textBoxEmpty, bgColor = {1,1,1,1}, static = true})

    labels = {}
    label_1_text = "Generating Map"
    labels[1] = label.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(label_1_text)/2), y = ((WindowHeight/2)-(font:getHeight()/2)), text = label_1_text, bgColor = {0,0,0,0}, fgColor = {1,1,1,1}, static = true})
    label_3_text = "World Settings"
    labels[3] = label.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(label_3_text)/2), y = ((WindowHeight/2)-(font:getHeight()/2))-font:getHeight()-2, text = label_3_text, bgColor = {0,0,0,0}, fgColor = {1,1,1,1}, static = true})
end