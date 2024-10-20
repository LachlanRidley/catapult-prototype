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

local clearLevel = false
local startLevel = false
local state = GameState.SetupMenu
local currentLevelIndex = nil

function Setup()
	pd.display.setRefreshRate(FRAME_RATE)

	-- set up game menu
	local menu = playdate.getSystemMenu()
	menu:addMenuItem("Level Select", function()
		if state == GameState.GoGame then
			state = GameState.SetupMenu
		end
	end)
end

function pd.update()
	if state == GameState.SetupMenu then
		clearLevel = true
		levelSwitcher = LevelSwitcher(10, 10)
		state = GameState.Menu
	end

	if clearLevel then
		if slime then slime:remove() end
		if walls then gfx.sprite.removeSprites(walls) end
		if spikes then gfx.sprite.removeSprites(spikes) end
		if goal then gfx.sprite.removeSprite(goal) end

		clearLevel = false
	end

	if startLevel then
		assert(currentLevelIndex ~= nil)

		local levelContent = LEVELS[currentLevelIndex].load()
		slime = levelContent.slime
		walls = levelContent.walls
		spikes = levelContent.spikes
		goal = levelContent.goal

		startLevel = false
	end

	if state == GameState.Menu then
		assert(levelSwitcher ~= nil)

		if pd.buttonJustPressed(pd.kButtonDown) then
			levelSwitcher:next()
		elseif pd.buttonJustPressed(pd.kButtonUp) then
			levelSwitcher:previous()
		elseif pd.buttonIsPressed(pd.kButtonA) or pd.buttonIsPressed(pd.kButtonB) then
			currentLevelIndex = levelSwitcher.selectedLevelIndex
			startLevel = true

			levelSwitcher:remove()
			levelSwitcher = nil
			state = GameState.GoGame
		end
	elseif state == GameState.GoGame then
		assert(goal ~= nil)
		assert(slime ~= nil)
		if goal:getBoundsRect():containsPoint(slime:getPosition()) then
			currentLevelIndex = currentLevelIndex + 1
			if currentLevelIndex > #LEVELS then
				currentLevelIndex = 1
			end

			clearLevel = true
			startLevel = true
		end

		for spike in All(spikes or {}) do
			if spike:getBoundsRect():containsPoint(slime:getPosition()) then
				startLevel = true
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
