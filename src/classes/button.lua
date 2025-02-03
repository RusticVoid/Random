button = {}
button.__index = button

function button.new(settings)
    local self = setmetatable({}, button)

    self.parent = settings.parent

    self.x = settings.x
    self.y = settings.y

    self.text = settings.text

    self.bgColor = settings.bgColor

    self.pressed = false

    self.static = (settings.static == true)

    self.hover = false
    self.soundPlayed = false

    self.buttonCooldown = 0

    return self
end

function button:isStatic(XorY)
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

function button:update(dt)
    self.pressed = false
    self.buttonCooldown = self.buttonCooldown - (0.5 * dt)

    if mouseCollid(self.x+self:isStatic("x"), self.y+self:isStatic("y"), font:getWidth(self.text), (font:getHeight())) then
        if self.buttonCooldown <= 0 then
            if MouseDown == true then
                --click_sound:play()
                self.pressed = true
                self.buttonCooldown = 0.1
            end
        end
    end
    self.hover = false
    if mouseCollid(self.x+self:isStatic("x"), self.y+self:isStatic("y"), font:getWidth(self.text), (font:getHeight())) then
        self.hover = true
        if self.soundPlayed == false then
            --hover_sound:play()
        end
    end

    if self.hover == true then
        self.soundPlayed = true
    else
        self.soundPlayed = false
    end
end

function button:draw()

    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x+self:isStatic("x"), self.y+self:isStatic("y"), font:getWidth(self.text), (font:getHeight()))
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(self.text, self.x+self:isStatic("x"), self.y+self:isStatic("y"))

    if self.hover == true then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", self.x+self:isStatic("x"), self.y+self:isStatic("y"), font:getWidth(self.text), (font:getHeight()))
    end

    love.graphics.setColor(1, 1, 1, 1)
end