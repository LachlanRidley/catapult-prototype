import 'luaunit/playdate_luaunit_fix'
import 'luaunit/luaunit'

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "test"

local pd <const> = playdate
local gfx <const> = pd.graphics
local snd <const> = pd.sound
local timer <const> = pd.timer

pd.stop()

-- TODO probably want to make these only run in simulator
luaunit.PRINT_TABLE_REF_IN_ERROR_MSG = true
local luaunit_args = { '--output', 'text', '--verbose', '-r' }

local returnValue = luaunit.LuaUnit.run(table.unpack(luaunit_args))

print("unit test return value = " .. returnValue);

pd.start()

-- globals
local SCREEN_WIDTH <const> = 400
local SCREEN_HEIGHT <const> = 240

function Setup()
	-- set the game up
	pd.display.setRefreshRate(50)

	-- set up game menu
	local menu = playdate.getSystemMenu()

	-- menu:addMenuItem("Restart game", function()
	-- 	RestartGame()
	-- end)
end

function pd.update()
	gfx.drawText('Hello world!', 30, 30)

	gfx.sprite.redrawBackground()
	gfx.sprite.update()
	timer.updateTimers()
end

Setup()
