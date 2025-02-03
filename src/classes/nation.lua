
nation = {}
nation.__index = nation

function nation.new(settings)
    local self = setmetatable({}, nation)

    self.ownedTiles = {}

    self.color = settings.color or {1, 1, 1, 0.5}

    return self
end

function nation:update()
    decision = math.random(1, 100)

    if decision == 1 then
        for i = 1, #self.ownedTiles do
            Nx = math.random(-1, 1)
            Ny = math.random(-1, 1)

            if (isValidTilePos(self.ownedTiles[i].x+Nx, self.ownedTiles[i].y+Ny, map)) and (not (map[self.ownedTiles[i].y+Ny][self.ownedTiles[i].x+Nx].type == 1) and (self:isOwnedTile(self.ownedTiles[i].x+Nx, self.ownedTiles[i].y+Ny, map) == false)) then
                self.ownedTiles[#self.ownedTiles+1] = map[self.ownedTiles[i].y+Ny][self.ownedTiles[i].x+Nx]
            end
        end
    end
end

function nation:isOwnedTile(x, y, array)
    for i = 1, #self.ownedTiles do
        if self.ownedTiles[i] == array[y][x] then
            return true
        end
    end

    for i = 1, #nations do
        for k = 1, #nations[i].ownedTiles do
            if nations[i].ownedTiles[k] == array[y][x] then
                return true
            end
        end
    end

    return false
end

function nation:draw()
    for i = 1, #self.ownedTiles do
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", self.ownedTiles[i].parent.x+(self.ownedTiles[i].x*tileSize), self.ownedTiles[i].parent.y+(self.ownedTiles[i].y*tileSize), tileSize, tileSize)
    end
end