require "classes.classes"
require "utils"

function love.load()
    math.randomseed(os.clock())
    WindowWidth, WindowHeight = love.window.getMode()
    World = world.new({x = 100, y = 100})
    UI = ui.new({x = 0, y = 0})

    font = love.graphics.newFont("fonts/baseFont.ttf", 20)
    font:setFilter("nearest")
    love.graphics.setFont(font)
    loadTextures()
    tileSize = 10
    placingEntity = nil

    worldEntities = {}

    buttons = {}

    button_1_Text = "PLAY"
    buttons[1] = button.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(button_1_Text)/2), y = (WindowHeight/2)-(font:getHeight()/2), text = button_1_Text, bgColor = {1,1,1,1}, static = true}) 
    button_2_Text = "START"
    buttons[2] = button.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(button_2_Text)/2), y = (WindowHeight/2)-(font:getHeight()/2)+font:getHeight()+2, text = button_2_Text, bgColor = {1,1,1,1}, static = true})

    textBoxs = {}
    blankText = "Input Nation Amount"
    textBoxs[1] = textBox.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(blankText)/2), y = (WindowHeight/2)-(font:getHeight()/2), text = blankText, bgColor = {1,1,1,1}, static = true, width = font:getWidth(blankText)})

    labels = {}
    label_1_text = "Generating Map"
    labels[1] = label.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(label_1_text)/2), y = ((WindowHeight/2)-(font:getHeight()/2)), text = label_1_text, bgColor = {0,0,0,0}, fgColor = {1,1,1,1}, static = true})
    label_2_text = "Generating Nations"
    labels[2] = label.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(label_2_text)/2), y = ((WindowHeight/2)-(font:getHeight()/2)), text = label_2_text, bgColor = {0,0,0,0}, fgColor = {1,1,1,1}, static = true})
    label_3_text = "World Settings"
    labels[3] = label.new({parent = UI, x = (WindowWidth/2)-(font:getWidth(label_3_text)/2), y = ((WindowHeight/2)-(font:getHeight()/2))-font:getHeight()-2, text = label_3_text, bgColor = {0,0,0,0}, fgColor = {1,1,1,1}, static = true})

    nations = {}

    MouseCurrentTile = nil

    nationAmount = 0

    mainMenu = true
    loadingMap = false
    loadingNations = false
end

function GenMap()
    MapWidth = 100
    MapHeight = 100

    map = {}

    for y = 1, MapHeight do
        map[y] = {}
        for x = 1, MapWidth do
            if math.random(1, 100) == 1 then
                map[y][x] = tile.new({type = math.random(1, 2), parent = World, x = x, y = y})
            else
                map[y][x] = tile.new({type = 0, parent = World, x = x, y = y})
            end
        end
    end
end

function love.update(dt)
    mouseDelta = dt
    WindowWidth, WindowHeight = love.window.getMode()
    MouseX, MouseY = love.mouse.getPosition()

    if mainMenu == true then
        buttons[1]:update(dt)
        if buttons[1].pressed == true then
            mainMenu = false
            worldSettings = true
            textBoxs[1].buttonCooldown = 0.5
        end

    elseif worldSettings == true then
        textBoxs[1]:update(dt)

        buttons[2]:update(dt)
        if buttons[2].pressed == true then
            if not (tonumber(textBoxs[1].text) == nil) then
                nationAmount = tonumber(textBoxs[1].text)
                worldSettings = false
                loadingMap = true
                genLand = true
                GenMap()
            end
        end
    elseif loadingMap == true then
        if genLand == true then
            emptyFound = false
            for y = 1, MapHeight do
                for x = 1, MapWidth do
                    if map[y][x].type == 0 then
                        emptyFound = true
                        Nx = math.random(-1, 1)
                        Ny = math.random(-1, 1)

                        if (isValidTilePos(x+Nx, y+Ny, map)) and (not (map[y+Ny][x+Nx].type == 0)) then
                            map[y][x].type = map[y+Ny][x+Nx].type
                        end
                    end
                end
            end

            if emptyFound == false then
                genLand = false
            end
        else
            for y = 1, MapHeight do
                for x = 1, MapWidth do
                    if map[y][x].type == 2 then
                        if (isValidTilePos(x, y+1, map)) and (map[y+1][x].type == 1) then
                            map[y][x].type = 3
                        end
                        if (isValidTilePos(x, y-1, map)) and (map[y-1][x].type == 1) then
                            map[y][x].type = 3
                        end
                        if (isValidTilePos(x+1, y, map)) and (map[y][x+1].type == 1) then
                            map[y][x].type = 3
                        end
                        if (isValidTilePos(x-1, y, map)) and (map[y][x-1].type == 1) then
                            map[y][x].type = 3
                        end
                    end
                end
            end

            if emptyFound == false then
                loadingMap = false
                loadingNations = true
            end
        end

    elseif loadingNations == true then
        for i = 1, nationAmount do
            randomTile = map[math.random(1, MapHeight)][math.random(1, MapWidth)]
            while randomTile.type == 1 do
                randomTile = map[math.random(1, MapHeight)][math.random(1, MapWidth)]
            end
            nations[#nations+1] = nation.new({color = {math.random(0, 100)/100, math.random(0, 100)/100, math.random(0, 100)/100, 0.8}})
            nations[#nations].ownedTiles[#nations[#nations].ownedTiles+1] = randomTile
        end
        loadingNations = false
    else
        if love.keyboard.isDown("a") then
            World.x = World.x + 200 * dt
        end
        if love.keyboard.isDown("d") then
            World.x = World.x - 200 * dt
        end
        if love.keyboard.isDown("w") then
            World.y = World.y + 200 * dt
        end
        if love.keyboard.isDown("s") then
            World.y = World.y - 200 * dt
        end

        for i = 1, #nations do
            nations[i]:update()
        end
    end
end

function love.keypressed(key)
    if textBoxs[1].selected == true then
        if key == "backspace" then
            textBoxs[1].text = textBoxs[1].text:sub(1, -2)
        elseif key == "return" then
        else
            textBoxs[1].text = textBoxs[1].text..key
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

function love.wheelmoved(x, y)
    if (mainMenu == false) and (loadingMap == false) then
        if y > 0 then
            tileSize = tileSize + 50 * mouseDelta
        elseif y < 0 then
            tileSize = tileSize - 50 * mouseDelta
        end

        if tileSize < 1 then
            tileSize = 1
        end
        if tileSize > 25 then
            tileSize = 25
        end
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
        labels[1]:draw()
    elseif loadingNations == true then
        labels[2]:draw()
    else
        for y = 1, MapHeight do
            for x = 1, MapWidth do
                map[y][x]:draw()
            end
        end

        for i = 1, #nations do
            nations[i]:draw()
        end
    end
end