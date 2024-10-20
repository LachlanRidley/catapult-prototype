import "levels"

local pd <const> = playdate
local gfx <const> = pd.graphics
local timer <const> = pd.timer

---@class Game
Game = class("Game").extends() or Game

function Game:init(selectedLevelIndex)
    self.selectedLevelIndex = selectedLevelIndex
    self.level = LEVELS[self.selectedLevelIndex].loader()
end

function Game:update()
    if self.level.goal:getBoundsRect():containsPoint(self.level.slime:getPosition()) then
        self.selectedLevelIndex += 1
        if self.selectedLevelIndex > #LEVELS then
            self.selectedLevelIndex = 1
        end

        UnloadLevel(self.level)
        self.level = LEVELS[self.selectedLevelIndex].loader()

        return
    end

    for spike in All(self.level.spikes or {}) do
        if spike:getBoundsRect():containsPoint(self.level.slime:getPosition()) then
            UnloadLevel(self.level)
            self.level = LEVELS[self.selectedLevelIndex].loader()
        end
    end

    gfx.sprite.update()

    if DEBUG then
        gfx.drawText("angle " .. self.level.slime.angle, 10, 10)
        gfx.drawText("dx " .. self.level.slime.velocity.dx, 10, 30)
        gfx.drawText("stuck " .. tostring(self.level.slime.stuck), 10, 50)
    end

    timer.updateTimers()
end
