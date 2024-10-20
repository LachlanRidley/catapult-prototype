import("luaunit/playdate_luaunit_fix")
import("luaunit/luaunit")

import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")

import('globals')

import("sprites/slime")
import("sprites/wall")
import("sprites/spike")
import("sprites/goal")

import("scenes/game")

import("levels")

import("test")
import("utils/all")

local pd <const> = playdate
local gfx <const> = pd.graphics
local snd <const> = pd.sound
local timer <const> = pd.timer

pd.stop()

-- TODO probably want to make these only run in simulator
luaunit.PRINT_TABLE_REF_IN_ERROR_MSG = true
local luaunit_args = { "--output", "text", "--verbose", "-r" }

local returnValue = luaunit.LuaUnit.run(table.unpack(luaunit_args))

print("unit test return value = " .. returnValue)

pd.start()

local currentScene
function Setup()
	-- set the game up
	pd.display.setRefreshRate(FRAME_RATE)

	currentScene = Menu()

	-- set up game menu
	local menu = playdate.getSystemMenu()
end

function UnloadLevel(level)
	gfx.sprite.removeSprite(level.slime)
	gfx.sprite.removeSprites(level.walls)
	gfx.sprite.removeSprites(level.spikes or {})
	gfx.sprite.removeSprite(level.goal)
end

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
		currentScene = Game(self.selectedLevelIndex)
	end

	gfx.sprite.update()
end

function pd.update()
	currentScene:update()
end

Setup()
