textBox = {}
textBox.__index = textBox

function textBox.new(settings)
    local self = setmetatable({}, textBox)

    self.parent = settings.parent

    self.x = settings.x
    self.y = settings.y

    self.text = settings.text

    self.bgColor = settings.bgColor

    self.selected = false

    self.static = (settings.static == true)

    self.hover = false
    self.soundPlayed = false

    self.buttonCooldown = 0

    self.width = settings.width or font:getWidth(textBoxEmpty)

    return self
end

function textBox:isStatic(XorY)
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

function textBox:update(dt)
    if self.selected == true then
        if not (mouseCollid(self.x+self:isStatic("x"), self.y+self:isStatic("y"), self.width, (font:getHeight()))) then
            if MouseDown == true then
                self.selected = false
            end
        end
    else
        self.selected = false
        self.buttonCooldown = self.buttonCooldown - (0.5 * dt)

        if mouseCollid(self.x+self:isStatic("x"), self.y+self:isStatic("y"), self.width, (font:getHeight())) then
            if self.buttonCooldown <= 0 then
                if MouseDown == true then
                    --click_sound:play()
                    self.selected = true
                    self.buttonCooldown = 0.1
                    self.text = ""
                end
            end
        end
        self.hover = false
        if mouseCollid(self.x+self:isStatic("x"), self.y+self:isStatic("y"), self.width, (font:getHeight())) then
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
end

function textBox:draw()

    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x+self:isStatic("x"), self.y+self:isStatic("y"), self.width, (font:getHeight()))
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(self.text, self.x+self:isStatic("x"), self.y+self:isStatic("y"))

    if self.hover == true then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", self.x+self:isStatic("x"), self.y+self:isStatic("y"), self.width, (font:getHeight()))
    end

    love.graphics.setColor(1, 1, 1, 1)
end