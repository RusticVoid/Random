
player = {}
player.__index = player

function player.new(settings)
    local self = setmetatable({}, player)

    self.x = WindowWidth/2
    self.y = WindowHeight/2

    self.texture = ship_1

    self.width = self.texture:getWidth()
    self.height = self.texture:getHeight()

    self.speed = 100

    self.worldMoveRad = 200

    self.rot = 0

    return self
end

function player:update(dt)
    LastX = self.x
    LastY = self.y

    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
        self.rot = 3.14159
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
        self.rot = 0
    end
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
        self.rot = 4.71239
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
        self.rot = 1.5708
    end

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
    love.graphics.draw(self.texture, self.x, self.y, self.rot, 1, 1, self.width/2, self.height/2)
    love.graphics.setColor(1,1,1,1)
end