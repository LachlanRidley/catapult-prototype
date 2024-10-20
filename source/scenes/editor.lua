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
    gfx.sprite.update()
    timer.updateTimers()
end
