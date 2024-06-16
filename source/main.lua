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

local CENTRE_X = SCREEN_WIDTH / 2
local CENTRE_Y = SCREEN_HEIGHT / 2

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
	gfx.clear()

	local angle = 0

	if not pd:isCrankDocked() then
		angle = pd.getCrankPosition()
	end

	local dx = 20 * math.sin(math.rad(angle))
	local dy = 20 * -math.cos(math.rad(angle))

	gfx.drawLine(CENTRE_X, CENTRE_Y, CENTRE_X + dx, CENTRE_Y + dy)

	gfx.drawText('Hello world!', 30, 30)

	gfx.sprite.redrawBackground()
	gfx.sprite.update()
	timer.updateTimers()
end

Setup()
