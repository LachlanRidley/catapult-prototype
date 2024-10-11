local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Level: _Sprite
Level = class("Level").extends(gfx.sprite) or Level

function Level:init(tilemap)
    Level.super.init(self)
    self:setTilemap(tilemap)
    self:moveTo(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

    self:add()
end
