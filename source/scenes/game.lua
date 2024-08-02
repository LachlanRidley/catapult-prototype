import "levels"

local pd <const> = playdate
local gfx <const> = pd.graphics
local timer <const> = pd.timer

---@class LevelInstance
---@field slime Slime
---@field walls Wall[]
---@field spikes Spikes[]
---@field goal Goal

---Clears everything related to a given level instance. Should be run before starting a level or changing scene
---@param level LevelInstance
local function UnloadLevel(level)
    gfx.sprite.removeSprite(level.slime)
    gfx.sprite.removeSprites(level.walls)
    gfx.sprite.removeSprites(level.spikes or {})
    gfx.sprite.removeSprite(level.goal)
end


---@class Game
---@field level Level
---@field levelInstance LevelInstance | nil
Game = class("Game").extends() or Game

---Runs a level
---@param level Level
function Game:init(level)
    self.level = level

    self:StartLevel()
end

function Game:update()
    if self.levelInstance.goal:getBoundsRect():containsPoint(self.levelInstance.slime:getPosition()) then
        UnloadLevel(self.levelInstance)
        CompleteLevel(self.level)

        return
    end

    for spike in All(self.levelInstance.spikes or {}) do
        if spike:getBoundsRect():containsPoint(self.levelInstance.slime:getPosition()) then
            self:StartLevel()
        end
    end

    gfx.sprite.update()

    if DEBUG then
        gfx.drawText("angle " .. self.levelInstance.slime.angle, 10, 10)
        gfx.drawText("dx " .. self.levelInstance.slime.velocity.dx, 10, 30)
        gfx.drawText("stuck " .. tostring(self.levelInstance.slime.stuck), 10, 50)
    end

    timer.updateTimers()
end

function Game:StartLevel()
    if self.levelInstance then
        UnloadLevel(self.levelInstance)
    end

    self.levelInstance = self.level.load()
end
