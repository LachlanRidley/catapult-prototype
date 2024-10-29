local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Goal: _Sprite
Goal = class("Goal").extends(gfx.sprite) or Goal

function Goal:init(x, y, w, h)
    Goal.super.init(self)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:setSize(w, h)

    local goalImage = gfx.image.new(w, h)
    gfx.pushContext(goalImage)
    gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer2x2)
    gfx.fillRect(0, 0, w, h)
    gfx.popContext()

    self:setImage(goalImage)

    self:add()
end
