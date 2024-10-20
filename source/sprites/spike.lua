local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Spikes: _Sprite
Spike = class("Spike").extends(gfx.sprite) or Spike

function Spike:init(x, y, w, h)
    Spike.super.init(self)

    local spikesImage = gfx.image.new(w, h)
    gfx.pushContext(spikesImage)
    local spikeImage = gfx.image.new("images/spike")
    assert(spikeImage, "could not find asset images/spike")
    spikeImage:drawTiled(0, 0, w, h)
    gfx.popContext()

    self:setImage(spikesImage)

    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:setSize(w, h)

    self:add()
end
