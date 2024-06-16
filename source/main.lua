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

local VELOCITY <const> = 10

local angle = 0
local dx = 0
local dy = 0

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

	if not pd:isCrankDocked() then
		angle = pd.getCrankPosition()
	end

	slimeX += dx
	slimeY += dy

	-- TODO friction needs to be proportional to direction
	if dx < 0 then
		dx = math.min(0, dx + 0.2)
	elseif dx > 0 then
		dx = math.max(0, dx - 0.2)
	end

	if slimeY >= SCREEN_HEIGHT then
		dy = 0
		slimeY = SCREEN_HEIGHT
	else
		dy = math.min(dy + 0.2, 10)
	end

	if slimeY >= SCREEN_HEIGHT then
		slimeY = SCREEN_HEIGHT
	end

	if slimeX <= 0 then
		slimeX = 0
		dx = -dx
	elseif slimeX >= SCREEN_WIDTH then
		slimeX = SCREEN_WIDTH
		dx = -dx
	end

	gfx.drawText("angle " .. angle, 10, 10)
	gfx.drawText("dx " .. dx, 10, 20)

	if pd.buttonJustPressed(pd.kButtonB) then
		dx = VELOCITY * math.sin(math.rad(angle))
		dy = VELOCITY * -math.cos(math.rad(angle))
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
