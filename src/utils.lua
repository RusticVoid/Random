function loadTextures()
    love.graphics.setDefaultFilter("nearest")

    waterTileTexture = love.graphics.newImage("assets/tiles/water.png")
    grassTileTexture = love.graphics.newImage("assets/tiles/grass.png")
    emptyTileTexture = love.graphics.newImage("assets/tiles/air.png")
    sandTileTexture = love.graphics.newImage("assets/tiles/sand.png")

end

function isValidTilePos(x, y, Array2D)
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

function isinWindow(tile)
    if (tile.x < WindowWidth)
    and (tile.x+tileSize > 0)
    and (tile.y < WindowHeight)
    and (tile.y+tileSize > 0) then
        isInWindow = true
    else
        isInWindow = false
    end

    return isInWindow
end