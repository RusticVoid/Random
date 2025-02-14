
player = {}
player.__index = player

function player.new(settings)
    local self = setmetatable({}, player)

    self.x = WindowWidth/2
    self.y = WindowHeight/2

    self.width = 20
    self.height = 20

    self.speed = 100

    self.worldMoveRad = 200

    return self
end

function player:update(dt)
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end

    chunkX = math.floor((((-World.x)+self.x)/chunkSize)/tileSize)
    chunkY = math.floor((((-World.y)+self.y)/chunkSize)/tileSize)

    tileX = chunkSize + (math.floor((((-World.x)+self.x)/tileSize)-chunkSize)+1)-(chunkX*chunkSize)
    tileY = chunkSize + (math.floor((((-World.y)+self.y)/tileSize)-chunkSize)+1)-(chunkY*chunkSize)

    map[chunkY][chunkX].tiles[tileY][tileX].color = {1,0,0,1}

    --print(math.floor(chunkX)..":"..math.floor(chunkY))

    if self.x+(self.width/2) < self.worldMoveRad then
        World.x = World.x + self.speed * dt
        self.x = self.x + self.speed * dt
    end
    if self.x+(self.width/2) > WindowWidth-self.worldMoveRad then
        World.x = World.x - self.speed * dt
        self.x = self.x - self.speed * dt
    end

    if self.y+(self.height/2) < self.worldMoveRad then
        World.y = World.y + self.speed * dt
        self.y = self.y + self.speed * dt
    end
    if self.y+(self.height/2) > WindowHeight-self.worldMoveRad then
        World.y = World.y - self.speed * dt
        self.y = self.y - self.speed * dt
    end
end

function player:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1,1,1,1)
end