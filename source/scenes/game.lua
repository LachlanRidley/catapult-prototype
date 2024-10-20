import "levels"

local pd <const> = playdate
local gfx <const> = pd.graphics
local timer <const> = pd.timer

---@class Game
---@field level Level
---@field slime Slime | nil
---@field walls Wall[] | nil
---@field spikes Spikes[] | nil
---@field goal Goal | nil
Game = class("Game").extends() or Game

---Runs a level
---@param level Level
function Game:init(level)
    self.level = level

    self:startLevel()
end

function Game:update()
    if self.goal:getBoundsRect():containsPoint(self.slime:getPosition()) then
        self:clearLevel()
        CompleteLevel(self.level)

        return
    end

    for spike in All(self.spikes or {}) do
        if spike:getBoundsRect():containsPoint(self.slime:getPosition()) then
            self:startLevel()
        end
    end

    gfx.sprite.update()

    if DEBUG then
        gfx.drawText("angle " .. self.slime.angle, 10, 10)
        gfx.drawText("dx " .. self.slime.velocity.dx, 10, 30)
        gfx.drawText("stuck " .. tostring(self.slime.stuck), 10, 50)
    end

    timer.updateTimers()
end

function Game:unload()
    self:clearLevel()
end

function Game:startLevel()
    self:clearLevel()

    local levelContent = self.level.load()
    self.slime = levelContent.slime
    self.walls = levelContent.walls
    self.spikes = levelContent.spikes
    self.goal = levelContent.goal
end

function Game:clearLevel()
    if self.slime then gfx.sprite.removeSprite(self.slime) end
    if self.walls then gfx.sprite.removeSprites(self.walls) end
    if self.spikes then gfx.sprite.removeSprites(self.spikes) end
    if self.goal then gfx.sprite.removeSprite(self.goal) end
end
