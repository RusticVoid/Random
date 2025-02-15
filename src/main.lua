require "classes.classes"
require "utils"

function love.load()
    math.randomseed(os.clock())
    WindowWidth, WindowHeight = love.window.getMode()
    loadTextures()
    
    MapWidth = 10
    MapHeight = 10
    tileSize = 20
    chunkSize = 16
    World = world.new({x = ((-((MapWidth*(tileSize*chunkSize))/2))+(WindowWidth/2))-(tileSize*chunkSize), y = (-((MapHeight*(tileSize*chunkSize))/2))+(WindowHeight/2)-(tileSize*chunkSize)})

    Player = player.new()
    
    UI = ui.new({x = 0, y = 0})

    font = love.graphics.newFont("fonts/baseFont.ttf", 20)
    font:setFilter("nearest")
    love.graphics.setFont(font)
    debug = false

    worldEntities = {}

    InitUI()

    selectedTextBox = nil

    MouseCurrentTile = nil

    mainMenu = true
    loadingMap = false
    gameRunning = false

    viewingMode = 1
end

function GenMap()
    map = {}
    for y = 1, MapHeight do
        map[y] = {}
        for x = 1, MapWidth do
            map[y][x] = chunk.new({parent = World, x = x*(chunkSize*tileSize), y = y*(chunkSize*tileSize)})
        end
    end
end

function love.update(dt)
    GlobalDelta = dt
    
    CurrentWindowWidth, CurrentWindowHeight = love.window.getMode()
    if (not (CurrentWindowWidth == WindowWidth)) or (not (CurrentWindowHeight == WindowHeight)) then
        WindowWidth, WindowHeight = love.window.getMode()

        InitUI()

        if gameRunning == false then
            World = world.new({x = ((-((MapWidth*(tileSize*chunkSize))/2))+(WindowWidth/2))-(tileSize*chunkSize), y = (-((MapHeight*(tileSize*chunkSize))/2))+(WindowHeight/2)-(tileSize*chunkSize)})
        end
    end

    mouseDelta = dt
    WindowWidth, WindowHeight = love.window.getMode()
    MouseX, MouseY = love.mouse.getPosition()
    fps = love.timer.getFPS()

    if mainMenu == true then
        buttons[1]:update(dt)
        if buttons[1].pressed == true then
            mainMenu = false
            worldSettings = true
            textBoxs[1].buttonCooldown = 0.1
        end
    elseif worldSettings == true then
        buttons[2]:update(dt)
        textBoxs[1]:update(dt)
        if textBoxs[1].selected == true then
            selectedTextBox = textBoxs[1]
        end
        if buttons[2].pressed == true then
            if not (tonumber(textBoxs[1].text) == nil) then
                if (tonumber(textBoxs[1].text) < 10) then
                    MapHeight = 10
                    MapWidth = 10
                else
                    MapHeight = tonumber(textBoxs[1].text)
                    MapWidth = tonumber(textBoxs[1].text)
                end
                worldSettings = false
                loadingMap = true
                genLand = true
                GenMap()
            end
        end
    elseif loadingMap == true then
        if genLand == true then
            emptyFound = false
            for ChunkY = 1, MapHeight do
                for ChunkX = 1, MapWidth do
                    for TileY = 1, chunkSize do
                        for TileX = 1, chunkSize do
                            
                            if map[ChunkY][ChunkX].tiles[TileY][TileX].type == 0 then
                                emptyFound = true
                                Nx = math.random(-1, 1)
                                Ny = math.random(-1, 1)
                                
                                if (isValidArrayPos(TileX+Nx, TileY+Ny, map[ChunkY][ChunkX].tiles)) and (not (map[ChunkY][ChunkX].tiles[TileY+Ny][TileX+Nx].type == 0)) then
                                    map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY][ChunkX].tiles[TileY+Ny][TileX+Nx].type
                                elseif not (isValidArrayPos(TileX+Nx, TileY+Ny, map[ChunkY][ChunkX].tiles)) then
                                    if Nx == -1 then
                                        if isValidArrayPos(ChunkX-1, ChunkY, map) then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY][ChunkX-1].tiles[TileY][chunkSize].type
                                        end
                                    end
                                    if Nx == 1 then
                                        if isValidArrayPos(ChunkX+1, ChunkY, map) then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY][ChunkX+1].tiles[TileY][1].type
                                        end
                                    end
                                    if Ny == -1 then
                                        if isValidArrayPos(ChunkX, ChunkY-1, map) then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY-1][ChunkX].tiles[chunkSize][TileX].type
                                        end
                                    end
                                    if Ny == 1 then
                                        if isValidArrayPos(ChunkX, ChunkY+1, map) then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY+1][ChunkX].tiles[1][TileX].type
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if emptyFound == false then
                genLand = false
            end
        else

            for ChunkY = 1, MapHeight do
                for ChunkX = 1, MapWidth do
                    for TileY = 1, chunkSize do
                        for TileX = 1, chunkSize do
                            if not (map[ChunkY][ChunkX].tiles[TileY][TileX].type == 3) then

                                sameTileDown = true
                                if (isValidArrayPos(TileX, TileY+1, map[ChunkY][ChunkX].tiles)) and (not (map[ChunkY][ChunkX].tiles[TileY+1][TileX].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type)) then
                                    sameTileDown = false
                                elseif not (isValidArrayPos(TileX, TileY+1, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX, ChunkY+1, map) then
                                        if not (map[ChunkY+1][ChunkX].tiles[1][TileX].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type) then
                                            sameTileDown = false
                                        end
                                    end
                                end

                                sameTileUp = true
                                if (isValidArrayPos(TileX, TileY-1, map[ChunkY][ChunkX].tiles)) and (not (map[ChunkY][ChunkX].tiles[TileY-1][TileX].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type)) then
                                    sameTileUp = false
                                elseif not (isValidArrayPos(TileX, TileY-1, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX, ChunkY-1, map) then
                                        if not (map[ChunkY-1][ChunkX].tiles[chunkSize][TileX].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type) then
                                            sameTileUp = false
                                        end
                                    end
                                end

                                sameTileRight = true
                                if (isValidArrayPos(TileX+1, TileY, map[ChunkY][ChunkX].tiles)) and (not (map[ChunkY][ChunkX].tiles[TileY][TileX+1].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type)) then
                                    sameTileRight = false
                                elseif not (isValidArrayPos(TileX+1, TileY, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX+1, ChunkY, map) then
                                        if not (map[ChunkY][ChunkX+1].tiles[TileY][1].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type) then
                                            sameTileRight = false
                                        end
                                    end
                                end

                                sameTileLeft = true
                                if (isValidArrayPos(TileX-1, TileY, map[ChunkY][ChunkX].tiles)) and (not (map[ChunkY][ChunkX].tiles[TileY][TileX-1].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type)) then
                                    sameTileLeft = false
                                elseif not (isValidArrayPos(TileX-1, TileY, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX-1, ChunkY, map) then
                                        if not (map[ChunkY][ChunkX-1].tiles[TileY][chunkSize].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type) then
                                            sameTileLeft = false
                                        end
                                    end
                                end

                                sameTileAmount = 0
                                if sameTileUp == true then
                                    sameTileAmount = sameTileAmount + 1
                                end
                                if sameTileDown == true then
                                    sameTileAmount = sameTileAmount + 1
                                end
                                if sameTileLeft == true then
                                    sameTileAmount = sameTileAmount + 1
                                end
                                if sameTileRight == true then
                                    sameTileAmount = sameTileAmount + 1
                                end

                                if sameTileAmount <= 1 then
                                    if (isValidArrayPos(TileX-1, TileY, map[ChunkY][ChunkX].tiles)) and (not (map[ChunkY][ChunkX].tiles[TileY][TileX-1].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type)) then
                                    map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY][ChunkX].tiles[TileY][TileX-1].type
                                    elseif not (isValidArrayPos(TileX-1, TileY, map[ChunkY][ChunkX].tiles)) then
                                        if isValidArrayPos(ChunkX-1, ChunkY, map) then
                                            if not (map[ChunkY][ChunkX-1].tiles[TileY][chunkSize].type == map[ChunkY][ChunkX].tiles[TileY][TileX].type) then
                                                map[ChunkY][ChunkX].tiles[TileY][TileX].type = map[ChunkY][ChunkX-1].tiles[TileY][chunkSize].type
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            for ChunkY = 1, MapHeight do
                for ChunkX = 1, MapWidth do
                    for TileY = 1, chunkSize do
                        for TileX = 1, chunkSize do
                            if map[ChunkY][ChunkX].tiles[TileY][TileX].type == 2 then
                                if (isValidArrayPos(TileX, TileY+1, map[ChunkY][ChunkX].tiles)) and (map[ChunkY][ChunkX].tiles[TileY+1][TileX].type == 1) then
                                    map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                elseif not (isValidArrayPos(TileX, TileY+1, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX, ChunkY+1, map) then
                                        if map[ChunkY+1][ChunkX].tiles[1][TileX].type == 1 then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                        end
                                    end
                                end
                                if (isValidArrayPos(TileX, TileY-1, map[ChunkY][ChunkX].tiles)) and (map[ChunkY][ChunkX].tiles[TileY-1][TileX].type == 1) then
                                    map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                elseif not (isValidArrayPos(TileX, TileY-1, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX, ChunkY-1, map) then
                                        if map[ChunkY-1][ChunkX].tiles[chunkSize][TileX].type == 1 then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                        end
                                    end
                                end
                                if (isValidArrayPos(TileX+1, TileY, map[ChunkY][ChunkX].tiles)) and (map[ChunkY][ChunkX].tiles[TileY][TileX+1].type == 1) then
                                    map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                elseif not (isValidArrayPos(TileX+1, TileY, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX+1, ChunkY, map) then
                                        if map[ChunkY][ChunkX+1].tiles[TileY][1].type == 1 then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                        end
                                    end
                                end
                                if (isValidArrayPos(TileX-1, TileY, map[ChunkY][ChunkX].tiles)) and (map[ChunkY][ChunkX].tiles[TileY][TileX-1].type == 1) then
                                    map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                elseif not (isValidArrayPos(TileX-1, TileY, map[ChunkY][ChunkX].tiles)) then
                                    if isValidArrayPos(ChunkX-1, ChunkY, map) then
                                        if map[ChunkY][ChunkX-1].tiles[TileY][chunkSize].type == 1 then
                                            map[ChunkY][ChunkX].tiles[TileY][TileX].type = 3
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            loadingMap = false
            gameRunning = true
        end
    elseif gameRunning == true then
        Player:update(dt)
    end
end

function love.keypressed(key)
    if not (selectedTextBox == nil) then
        selectedTextBox.text = selectedTextBox.text..key
    end
    
    if gameRunning == true then
        if key == "f1" then
            debug = not debug
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        MouseDown = true
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        MouseDown = false
    end
end

function love.draw()
    if mainMenu == true then
        buttons[1]:draw()
    elseif worldSettings == true then
        labels[3]:draw()
        textBoxs[1]:draw()
        buttons[2]:draw()
    elseif loadingMap == true then
        for y = 1, MapHeight do
            for x = 1, MapWidth do
                map[y][x]:draw()
            end
        end
        labels[1]:draw()
    elseif gameRunning == true then
        for y = 1, MapHeight do
            for x = 1, MapWidth do
                map[y][x]:draw()
            end
        end
        
        Player:draw()
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.print(fps)
end
