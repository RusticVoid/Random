
chunk = {}
chunk.__index = chunk

function chunk.new(settings)
    local self = setmetatable({}, chunk)

    self.parent = settings.parent or nil

    self.x = settings.x or 0
    self.y = settings.y or 0

    self.tiles = {}
    for y = 1, chunkSize do
        self.tiles[y] = {}
        for x = 1, chunkSize do
            if math.random(1, 100) == 1 then
                randomType = math.random(1, 4)
                if randomType == 3 then
                    randomType = 1
                end
                if (randomType == 4) and not (math.random(1, 100) == 1) then
                    randomType = 2
                end
                if (randomType == 2) and not (math.random(1, 10) == 1) then
                    randomType = 1
                end
                self.tiles[y][x] = tile.new({type = randomType, parent = self, x = x, y = y})
            else
                self.tiles[y][x] = tile.new({type = 0, parent = self, x = x, y = y})
            end
        end
    end

    for y = 1, chunkSize do
        for x = 1, chunkSize do
            if not (self.tiles[y][x] == 0) then
                self.valid = true
            end
        end
    end

    if self.valid == false then
        randomType = math.random(1, 4)
        if randomType == 3 then
            randomType = 2
        end
        self.tiles[math.random(1, chunkSize)][math.random(1, chunkSize)] = randomType
        self.valid = true
    end

    return self
end

function chunk:draw()
    if isinWindow(self) then
        for y = 1, chunkSize do
            for x = 1, chunkSize do
                self.tiles[y][x]:draw(self.parent.x, self.parent.y)
            end
        end
        
        if debug == true then
            love.graphics.setColor(1,0,0,1)
            love.graphics.rectangle("line", (self.parent.x+self.x)+tileSize, (self.parent.y+self.y)+tileSize, tileSize*chunkSize, tileSize*chunkSize)
            love.graphics.setColor(1,1,1,1)
        end
    end
end