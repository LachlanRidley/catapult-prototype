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

local slimeX = SCREEN_WIDTH / 2
local slimeY = SCREEN_HEIGHT / 2
local velocity = 0
local angle = 0

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

	if not pd:isCrankDocked() and velocity == 0 then
		angle = pd.getCrankPosition()
	end

	local dx = velocity * math.sin(math.rad(angle))
	local dy = velocity * -math.cos(math.rad(angle))

	slimeX += dx
	slimeY += dy

	if pd.buttonJustPressed(pd.kButtonB) and velocity == 0 then
		velocity = 10
	end

	if velocity > 0 then
		velocity = math.max(0, velocity - 0.2)
	end

	local pointerOffsetX = 20 * math.sin(math.rad(angle))
	local pointerOffsetY = 20 * -math.cos(math.rad(angle))

	gfx.drawLine(slimeX, slimeY, slimeX + pointerOffsetX, slimeY + pointerOffsetY)
	gfx.fillCircleAtPoint(slimeX, slimeY, 5)

	gfx.sprite.redrawBackground()
	gfx.sprite.update()
	timer.updateTimers()
end

Setup()
