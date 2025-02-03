label = {}
label.__index = label

function label.new(settings)
    local self = setmetatable({}, label)

    self.parent = settings.parent

    self.x = settings.x
    self.y = settings.y

    self.text = settings.text

    self.bgColor = settings.bgColor
    self.fgColor = settings.fgColor or {0, 0, 0, 1}

    self.static = (settings.static == true)

    return self
end

function label:isStatic(XorY)
    if XorY == "x" then
        if self.static == true then
            return 0
        else
            return self.parent.x
        end
    end

    if XorY == "y" then
        if self.static == true then
            return 0
        else
            return self.parent.y
        end
    end
end

function label:draw()

    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x+self:isStatic("x"), self.y+self:isStatic("y"), font:getWidth(self.text), (font:getHeight()))
    love.graphics.setColor(self.fgColor)
    love.graphics.print(self.text, self.x+self:isStatic("x"), self.y+self:isStatic("y"))

    love.graphics.setColor(1, 1, 1, 1)
end