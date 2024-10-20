import "levels"
import "utils/LDtk"

local pd <const> = playdate
local gfx <const> = pd.graphics
local timer <const> = pd.timer

---@class Game
---@field level Level
---@field slime Slime | nil
---@field walls Wall[] | nil
---@field spikes Spikes[] | nil
---@field goal Goal | nil
GameBetter = class("GameBetter").extends() or GameBetter

---Runs a level
---@param level Level
function GameBetter:init(level)
    self.level = level

    self:startLevel()
end

function GameBetter:update()
    gfx.sprite.update()

    if DEBUG then
        gfx.drawText("angle " .. self.slime.angle, 10, 10)
        gfx.drawText("dx " .. self.slime.velocity.dx, 10, 30)
        gfx.drawText("stuck " .. tostring(self.slime.stuck), 10, 50)
    end

    self.tilemap:draw(0, 0)

    timer.updateTimers()
end

function GameBetter:unload()
    self:clearLevel()
end

function GameBetter:startLevel()
    -- self:clearLevel()

    -- local levelContent = self.level.load()
    -- self.slime = levelContent.slime
    -- self.walls = levelContent.walls
    -- self.spikes = levelContent.spikes
    -- self.goal = levelContent.goal
    LDtk.load("world.ldtk")
    LDtk.load_level("Level_0")
    self.tilemap = LDtk.create_tilemap("Level_0")
end

function GameBetter:clearLevel()

end
