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
import("scenes/menu")

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

local CurrentScene = nil

function Setup()
	-- set the game up
	pd.display.setRefreshRate(FRAME_RATE)

	CurrentScene = Menu()

	-- set up game menu
	local menu = playdate.getSystemMenu()
end

function LoadLevel(levelIndex)
	local selectedLevel = LEVELS[levelIndex]
	assert(selectedLevel, "Level with index " .. levelIndex .. " does not exist")

	CurrentScene = Game(selectedLevel)
end

function CompleteLevel(level)
	local nextLevelIndex = level.order + 1
	if nextLevelIndex > #LEVELS then
		nextLevelIndex = 1
	end

	LoadLevel(nextLevelIndex)
end

function pd.update()
	assert(CurrentScene ~= nil, "CurrentScene must be set before first update, have you called Setup()?")

	CurrentScene:update()
end

Setup()
