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

CurrentScene = nil

function Setup()
	-- set the game up
	pd.display.setRefreshRate(FRAME_RATE)

	CurrentScene = Menu()

	-- set up game menu
	local menu = playdate.getSystemMenu()
end

function UnloadLevel(level)
	gfx.sprite.removeSprite(level.slime)
	gfx.sprite.removeSprites(level.walls)
	gfx.sprite.removeSprites(level.spikes or {})
	gfx.sprite.removeSprite(level.goal)
end

function pd.update()
	CurrentScene:update()
end

Setup()
