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

import("ui/level-switcher")

import("levels")

import("test")
import("utils/all")

local pd <const> = playdate
local gfx <const> = pd.graphics
local snd <const> = pd.sound
local timer <const> = pd.timer

local GameState = {
	Menu = 1,
	GoGame = 2,
	SetupMenu = 3,
}

pd.stop()

-- TODO probably want to make these only run in simulator
luaunit.PRINT_TABLE_REF_IN_ERROR_MSG = true
local luaunit_args = { "--output", "text", "--verbose", "-r" }

local returnValue = luaunit.LuaUnit.run(table.unpack(luaunit_args))

print("unit test return value = " .. returnValue)

pd.start()

local state = GameState.SetupMenu

---@type Level | nil
local level
---@type Slime | nil
local slime
---@type Wall[] | nil
local walls
---@type Spikes[] | nil
local spikes
---@type Goal | nil
local goal

---@type LevelSwitcher | nil
local levelSwitcher

function Setup()
	-- set the game up
	pd.display.setRefreshRate(FRAME_RATE)

	-- set up game menu
	local menu = playdate.getSystemMenu()
	menu:addMenuItem("Level Select", function()
		if state == GameState.GoGame then
			state = GameState.SetupMenu
		end
	end)
end

function LoadLevel(levelIndex)
	local selectedLevel = LEVELS[levelIndex]
	assert(selectedLevel, "Level with index " .. levelIndex .. " does not exist")

	level = selectedLevel
end

function AdvanceLevel()
	assert(level)

	local nextLevelIndex = level.order + 1
	if nextLevelIndex > #LEVELS then
		nextLevelIndex = 1
	end

	LoadLevel(nextLevelIndex)
end

function StartLevel()
	ClearLevel()
	assert(level ~= nil)

	local levelContent = level.load()
	slime = levelContent.slime
	walls = levelContent.walls
	spikes = levelContent.spikes
	goal = levelContent.goal
end

function ClearLevel()
	if slime then slime:remove() end
	if walls then gfx.sprite.removeSprites(walls) end
	if spikes then gfx.sprite.removeSprites(spikes) end
	if goal then gfx.sprite.removeSprite(goal) end
end

function pd.update()
	if state == GameState.SetupMenu then
		ClearLevel()
		levelSwitcher = LevelSwitcher(10, 10)
		state = GameState.Menu
	end

	if state == GameState.Menu then
		assert(levelSwitcher ~= nil)

		if pd.buttonJustPressed(pd.kButtonDown) then
			levelSwitcher:next()
		elseif pd.buttonJustPressed(pd.kButtonUp) then
			levelSwitcher:previous()
		elseif pd.buttonIsPressed(pd.kButtonA) or pd.buttonIsPressed(pd.kButtonB) then
			LoadLevel(levelSwitcher.selectedLevelIndex)
			levelSwitcher:remove()
			levelSwitcher = nil
			StartLevel()
			state = GameState.GoGame
		end
	elseif state == GameState.GoGame then
		assert(goal ~= nil)
		assert(slime ~= nil)
		if goal:getBoundsRect():containsPoint(slime:getPosition()) then
			AdvanceLevel()
			StartLevel()
		end

		for spike in All(spikes or {}) do
			if spike:getBoundsRect():containsPoint(slime:getPosition()) then
				StartLevel()
			end
		end
	end

	gfx.sprite.update()


	if DEBUG and state == GameState.GoGame then
		assert(slime)
		gfx.drawText("angle " .. slime.angle, 10, 10)
		gfx.drawText("dx " .. slime.velocity.dx, 10, 30)
		gfx.drawText("stuck " .. tostring(slime.stuck), 10, 50)
	end
	timer.updateTimers()
end

Setup()
