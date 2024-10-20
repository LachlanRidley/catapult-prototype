local pd <const> = playdate
local gfx <const> = pd.graphics

---@class LevelSwitcher
LevelSwitcher = class("LevelSwitcher").extends() or LevelSwitcher

function LevelSwitcher:init(x, y)
    self.selectedLevelIndex = 1
    self.levelTexts = {}

    for level in All(LEVELS) do
        local levelText = gfx.imageWithText(level.name, SCREEN_WIDTH, SCREEN_HEIGHT)

        table.insert(self.levelTexts, levelText)
    end

    self.menuText = gfx.sprite.new(self.levelTexts[self.selectedLevelIndex])
    self.menuText:setCenter(0, 0)
    self.menuText:moveTo(x, y)
    self.menuText:add()
end

function LevelSwitcher:next()
    self.selectedLevelIndex = self.selectedLevelIndex + 1
    if self.selectedLevelIndex > #LEVELS then
        self.selectedLevelIndex = 1
    end

    self.menuText:setImage(self.levelTexts[self.selectedLevelIndex])
end

function LevelSwitcher:previous()
    self.selectedLevelIndex = self.selectedLevelIndex - 1
    if self.selectedLevelIndex < 1 then
        self.selectedLevelIndex = #LEVELS
    end

    self.menuText:setImage(self.levelTexts[self.selectedLevelIndex])
end

function LevelSwitcher:remove()
    self.menuText:remove()
end
