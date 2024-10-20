import('globals')
import("CoreLibs/sprites")
import("utils/animatedimage")

local pd <const> = playdate
local gfx <const> = pd.graphics

local MAX_VELOCITY <const> = 280
local GRAVITY_CONSTANT <const> = 1680
local GRAVITY_STEP <const> = pd.geometry.vector2D.new(0, GRAVITY_CONSTANT * DT)

local HOP_VELOCITY = 890
local FRICTION_CONSTANT <const> = 0.1

---@class Slime: _Sprite
---@field angle number
---@field stuck boolean
Slime = class("Slime").extends(gfx.sprite) or Slime


function Slime:init(x, y)
    Slime.super.init(self)
    self.velocity = pd.geometry.vector2D.new(0, 0)
    self:moveTo(x, y)

    local slimeImage = gfx.image.new("images/slime")
    assert(slimeImage, "could not find asset images/slime")

    self:setImage(slimeImage)

    self:setCollideRect(0, 0, self:getSize())

    self.angle = 0
    self.stuck = false

    self:add()

    local eyeTable = gfx.imagetable.new("images/slime-eye")
    self.eyeAnimation = gfx.animation.loop.new(50, eyeTable, true)

    self.eyeSprite = gfx.sprite.new(self.eyeAnimation:image())
    self.eyeSprite:moveTo(10, 10)
    self.eyeSprite:add()
end

function Slime:update()
    if not pd:isCrankDocked() and self.stuck then
        local newAngle = pd.getCrankPosition()

        if newAngle ~= self.angle then
            -- sprites don't automatically get marked as dirty unless they move
            self:markDirty()
        end

        self.angle = newAngle
    end

    if not self.stuck then
        -- gravity
        self.velocity = self.velocity + GRAVITY_STEP

        -- friction
        self.velocity = self.velocity + self.velocity:scaledBy(-FRICTION_CONSTANT)

        local velocityStep = self.velocity * DT
        local _, _, _, collisionCount = self:moveWithCollisions(self.x + velocityStep.dx, self.y + velocityStep.dy)

        if collisionCount > 0 then
            self.stuck = true
            self.velocity.dx = 0
            self.velocity.dy = 0
        end

        if self.y >= SCREEN_HEIGHT then
            self.stuck = true
            self.velocity.dy = 0
            self.velocity.dx = 0
            self:moveTo(self.x, SCREEN_HEIGHT)
        end

        if self.x <= 0 then
            self:moveTo(0, self.y)
            self.velocity.dx = -self.velocity.dx
        elseif self.x >= SCREEN_WIDTH then
            self:moveTo(SCREEN_WIDTH, self.y)
            self.velocity.dx = -self.velocity.dx
        end
    end

    if self.stuck and pd.buttonJustPressed(pd.kButtonB) then
        self.stuck = false
        self.velocity.dx = HOP_VELOCITY * math.sin(math.rad(self.angle))
        self.velocity.dy = HOP_VELOCITY * -math.cos(math.rad(self.angle))
    end

    -- update eye position
    self.eyeSprite:moveTo(self.x - 6, self.y - 10)

    -- update eye animation
    self.eyeSprite:setImage(self.eyeAnimation:image())
end

function Slime:draw()
    if self.stuck then
        local pointerOffsetX = 20 * math.sin(math.rad(self.angle))
        local pointerOffsetY = 20 * -math.cos(math.rad(self.angle))

        gfx.drawLine(20, 20, 20 + pointerOffsetX, 20 + pointerOffsetY)
    end

    gfx.fillCircleAtPoint(20, 20, 5)
end

function Slime:remove()
    self.eyeSprite:remove()
    Slime.super.remove(self)
end
