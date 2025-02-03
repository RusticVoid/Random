
world = {}
world.__index = world

function world.new(settings)
    local self = setmetatable({}, world)

    self.x = settings.x or 0
    self.y = settings.y or 0

    return self
end

function world:update()
end

function world:draw()
end