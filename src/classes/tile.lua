
tile = {}
tile.__index = tile

function tile.new(settings)
    local self = setmetatable({}, tile)

    self.parent = settings.parent or nil

    self.x = settings.x or 0
    self.y = settings.y or 0

    self.type = settings.type or 1

    return self
end

function tile:draw()
    if isinWindow(self) then
        if self.type == 1 then
            self.texture = waterTileTexture
        elseif self.type == 2 then
            self.texture = grassTileTexture
        elseif self.type == 3 then
            self.texture = sandTileTexture
        elseif self.type == 0 then
            self.texture = emptyTileTexture
        end

        love.graphics.setColor(1,1,1,1)
        if (self.mouseOver == true) then
            MouseCurrentTile = self
        end
        love.graphics.draw(self.texture, self.parent.x+(self.x*tileSize), self.parent.y+(self.y*tileSize), 0, tileSize/(self.texture:getWidth()), tileSize/(self.texture:getHeight()))
        love.graphics.setColor(1,1,1,1)
    end
end