
nation = {}
nation.__index = nation

function nation.new(settings)
    local self = setmetatable({}, nation)

    self.ownedTiles = {}

    self.color = settings.color or {1, 1, 1, 0.5}

    return self
end

function nation:draw()
    for i = 1, #self.ownedTiles do
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", self.ownedTiles[i].parent.x+(self.ownedTiles[i].x*tileSize), self.ownedTiles[i].parent.y+(self.ownedTiles[i].y*tileSize), tileSize, tileSize)
    end
end