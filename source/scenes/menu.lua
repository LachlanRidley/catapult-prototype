local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Menu
Menu = class("Menu").extends() or Menu

function Menu:init()
    self.selectedLevelIndex = 1
    self.levelTexts = {}

    for level in All(LEVELS) do
        local levelText = gfx.imageWithText(level.name, SCREEN_WIDTH, SCREEN_HEIGHT)

        table.insert(self.levelTexts, levelText)
    end

    self.menuText = gfx.sprite.new(self.levelTexts[self.selectedLevelIndex])
    self.menuText:setCenter(0, 0)
    self.menuText:moveTo(10, 10)
    self.menuText:add()
end

function Menu:update()
    if pd.buttonJustPressed(pd.kButtonDown) then
        self.selectedLevelIndex = self.selectedLevelIndex + 1
        if self.selectedLevelIndex > #LEVELS then
            self.selectedLevelIndex = 1
        end
        self.menuText:setImage(self.levelTexts[self.selectedLevelIndex])
    elseif pd.buttonIsPressed(pd.kButtonA) then
        self.menuText:remove()
        LoadLevel(self.selectedLevelIndex)
    end

    gfx.sprite.update()
end
