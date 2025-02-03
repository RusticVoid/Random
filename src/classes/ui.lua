
ui = {}
ui.__index = ui

function ui.new(settings)
    local self = setmetatable({}, ui)

    self.x = settings.x or 0
    self.y = settings.y or 0

    return self
end