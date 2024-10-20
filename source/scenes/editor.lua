import "levels"

local pd <const> = playdate
local gfx <const> = pd.graphics
local timer <const> = pd.timer

---@class Editor
---@field wall Wall
---@field mode "move" | "resize"
Editor = class("Editor").extends() or Editor

function Editor:init()
    self.wall = Wall(10, 10, 40, 40)
    self.mode = "move"
    -- self:load()
end

function Editor:update()
    if self.mode == "move" then
        if pd.buttonIsPressed(pd.kButtonRight) then
            self.wall:moveBy(2, 0)
        end
        if pd.buttonIsPressed(pd.kButtonLeft) then
            self.wall:moveBy(-2, 0)
        end
        if pd.buttonIsPressed(pd.kButtonUp) then
            self.wall:moveBy(0, -2)
        end
        if pd.buttonIsPressed(pd.kButtonDown) then
            self.wall:moveBy(0, 2)
        end
    elseif self.mode == "resize" then
        if pd.buttonIsPressed(pd.kButtonRight) then
            self.wall:resizeBy(2, 0)
        end
        if pd.buttonIsPressed(pd.kButtonLeft) then
            self.wall:resizeBy(-2, 0)
        end
        if pd.buttonIsPressed(pd.kButtonUp) then
            self.wall:resizeBy(0, -2)
        end
        if pd.buttonIsPressed(pd.kButtonDown) then
            self.wall:resizeBy(0, 2)
        end
    end

    if pd.buttonJustPressed(pd.kButtonB) then
        self.mode = self.mode == "move" and "resize" or "move"
    end

    if pd.buttonIsPressed(pd.kButtonA) then
        self:save()
    end

    gfx.sprite.update()
    timer.updateTimers()
end

function Editor:load()
    local level = pd.datastore.read("custom-level")
    assert(level, "No level file found")

    self.wall = Wall(level.walls[1].x, level.walls[1].y, level.walls[1].w, level.walls[1].h)
end

function Editor:save()
    local level = {
        walls = {
            {
                x = self.wall.x,
                y = self.wall.y,
                w = self.wall.width,
                h = self.wall.height,
            }
        }
    }
    pd.datastore.write(level, "custom-level")
end
