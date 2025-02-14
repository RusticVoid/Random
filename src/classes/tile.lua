
tile = {}
tile.__index = tile

function tile.new(settings)
    local self = setmetatable({}, tile)

    self.parent = settings.parent or nil

    self.x = settings.x or 0
    self.y = settings.y or 0

    self.type = settings.type or 1

    self.nation = settings.nation

    self.popCooldown = 0

    self.color = {1,1,1,1}

    return self
end

function tile:update(dt)
end

function tile:draw(offsetX, offsetY)
    if self.type == 1 then
        self.texture = waterTileTexture
    elseif self.type == 2 then
        self.texture = grassTileTexture
    elseif self.type == 3 then
        self.texture = sandTileTexture
    elseif self.type == 4 then
        self.texture = stoneTileTexture
    elseif self.type == 0 then
        self.texture = emptyTileTexture
    end

    love.graphics.setColor(self.color)
    love.graphics.draw(self.texture, offsetX+self.parent.x+(self.x*tileSize), offsetY+self.parent.y+(self.y*tileSize), 0, tileSize/(self.texture:getWidth()), tileSize/(self.texture:getHeight()))    

    love.graphics.setColor(1,1,1,1)
end