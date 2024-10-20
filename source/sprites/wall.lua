local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Wall: _Sprite
Wall = class("Wall").extends(gfx.sprite) or Wall

---creates a new wall object
---@param x integer
---@param y integer
---@param w integer
---@param h integer
function Wall:init(x, y, w, h)
    Wall.super.init(self)

    local wallImage = gfx.image.new(w, h)
    gfx.pushContext(wallImage)
    gfx.drawRect(0, 0, w, h)
    gfx.popContext()

    self:setImage(wallImage)

    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:setSize(w, h)
    self:setCollideRect(0, 0, self:getSize())

    self:add()
end
