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

-- play state
local won = false
local dead = false
---@type Slime
local slime = nil
---@type Goal
local goal = nil
---@type Spikes[]
local spikes = {}
---@type Wall[]
local walls = {}

local currentScene
function Setup()
	-- set the game up
	pd.display.setRefreshRate(FRAME_RATE)

	currentScene = Menu()

	-- set up game menu
	local menu = playdate.getSystemMenu()
end

function LoadJump()
	slime = Slime(10, 10)

	local wallWidth = SCREEN_WIDTH / 2 - 45
	local wallHeight = SCREEN_HEIGHT * 0.6
	walls = {
		Wall(0, SCREEN_HEIGHT - wallHeight, wallWidth, wallHeight),
		Wall(SCREEN_WIDTH - wallWidth, SCREEN_HEIGHT - wallHeight, wallWidth, SCREEN_HEIGHT)
	}

	goal = Goal(SCREEN_WIDTH - 30, 76, 40, 40)
end

function LoadTheClimb()
	slime = Slime(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 20)

	local wallWidth = SCREEN_WIDTH / 2 - 45
	walls = {
		Wall(0, 0, wallWidth, SCREEN_HEIGHT),
		Wall(SCREEN_WIDTH - wallWidth, 0, wallWidth, SCREEN_HEIGHT)
	}

	goal = Goal(SCREEN_WIDTH / 2, 10, SCREEN_WIDTH - (wallWidth * 2), 20)
end

function LoadPlayground()
	slime = Slime(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT / 2)

	walls = {
		Wall(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 25, 25, 25),
		Wall(SCREEN_WIDTH / 2 + 25, SCREEN_HEIGHT - 25 - 25, 25, 25),
		Wall(SCREEN_WIDTH / 2 + (25 * 2), SCREEN_HEIGHT - 25 - (25 * 2), 25, 25),
		Wall(SCREEN_WIDTH / 2 + (25 * 3), SCREEN_HEIGHT - 25 - (25 * 3), 25, 25),
		Wall(SCREEN_WIDTH / 2 + (25 * 4), SCREEN_HEIGHT - 25 - (25 * 4), 25, 25),
		Wall(SCREEN_WIDTH / 2 + (25 * 5), SCREEN_HEIGHT - 25 - (25 * 5), 25, 25)
	}

	spikes = { Spike(10, 10, 20, SCREEN_HEIGHT - 20) }

	goal = Goal(SCREEN_WIDTH - 60, 150, 50, 50)
end

function UnloadLevel()
	gfx.sprite.removeSprite(slime)
	gfx.sprite.removeSprites(walls)
	gfx.sprite.removeSprites(spikes)
	gfx.sprite.removeSprite(goal)
end

---@class Scene
Scene = class("Scene").extends() or Scene

function Scene:init(selectedLevelIndex)
	self.selectedLevelIndex = selectedLevelIndex
	LEVELS[self.selectedLevelIndex].loader()
end

function Scene:update()
	if goal:getBoundsRect():containsPoint(slime:getPosition()) then
		won = true
		UnloadLevel()
		self.selectedLevelIndex += 1
		if self.selectedLevelIndex > #LEVELS then
			self.selectedLevelIndex = 1
		end

		LEVELS[self.selectedLevelIndex].loader()
	else
		goal:add()
	end

	for spike in All(spikes) do
		if spike:getBoundsRect():containsPoint(slime:getPosition()) then
			dead = true
			slime:remove()
		end
	end

	gfx.sprite.update()

	if DEBUG then
		gfx.drawText("angle " .. slime.angle, 10, 10)
		gfx.drawText("dx " .. slime.velocity.dx, 10, 30)
		gfx.drawText("stuck " .. tostring(slime.stuck), 10, 50)
		gfx.drawText("won? " .. tostring(won), 10, 70)
		gfx.drawText("dead? " .. tostring(dead), 10, 90)
	end

	timer.updateTimers()
end

LEVELS = { {
	name = "Jump!",
	loader = LoadJump
}, {
	name = "The Climb",
	loader = LoadTheClimb
}, {
	name = "Playground",
	loader = LoadPlayground
} }

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
		currentScene = Scene(self.selectedLevelIndex)
	end

	gfx.sprite.update()
end

function pd.update()
	currentScene:update()
end

Setup()
