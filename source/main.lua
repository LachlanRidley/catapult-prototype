import("luaunit/playdate_luaunit_fix")
import("luaunit/luaunit")

import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")

import("test")

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

-- globals
local SCREEN_WIDTH <const> = 400
local SCREEN_HEIGHT <const> = 240
local FRAME_RATE <const> = 50
local DT <const> = 1 / FRAME_RATE

local MAX_VELOCITY = 280
local GRAVITY_CONSTANT = 1680
local GRAVITY_STEP = pd.geometry.vector2D.new(0, GRAVITY_CONSTANT * DT)

local HOP_VELOCITY = 890

local FRICTION_CONSTANT <const> = 0.1

local won = false
local dead = false

---@type Spikes[]
local SpikesList = {}

---@class Wall: _Sprite
Wall = class("Wall").extends(gfx.sprite) or Wall

---creates a new wall object
---@param x integer
---@param y integer
---@param w integer
---@param h integer
function Wall:init(x, y, w, h)
	Wall.super.init(self)

	local wallImage = gfx.image.new(w, h)
	gfx.pushContext(wallImage)
	gfx.drawRect(0, 0, w, h)
	gfx.popContext()

	self:setImage(wallImage)

	self:setCenter(0, 0)
	self:moveTo(x, y)
	self:setSize(w, h)
	self:setCollideRect(0, 0, self:getSize())

	self:add()
end

---@class Spikes: _Sprite
Spikes = class("Spikes").extends(gfx.sprite) or Spikes

function Spikes:init(x, y, w, h)
	Spikes.super.init(self)

	local spikesImage = gfx.image.new(w, h)
	gfx.pushContext(spikesImage)
	gfx.drawRect(0, 0, w, h)
	gfx.popContext()

	self:setImage(spikesImage)

	self:setCenter(0, 0)
	self:moveTo(x, y)
	self:setSize(w, h)

	self:add()
end

---@class Goal: _Sprite
Goal = class("Goal").extends(gfx.sprite) or Goal

function Goal:init(x, y, w, h)
	Goal.super.init(self)
	self:moveTo(x, y)
	self:setSize(w, h)

	local goalImage = gfx.image.new(w, h)
	gfx.pushContext(goalImage)
	gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer2x2)
	gfx.fillRect(0, 0, w, h)
	gfx.popContext()

	self:setImage(goalImage)

	self:add()
end

---@class Slime: _Sprite
---@field angle number
---@field stuck boolean
Slime = class("Slime").extends(gfx.sprite) or Slime

---@type Slime
local slime = nil

---@type Goal
local goal = nil

function Slime:init(x, y)
	Slime.super.init(self)
	self.velocity = pd.geometry.vector2D.new(0, 0)
	self:moveTo(x, y)

	self.angle = 0
	self.stuck = false

	self:setSize(40, 40)
	self:setCollideRect(15, 15, 10, 10)

	self:add()
end

function Slime:update()
	if not pd:isCrankDocked() and self.stuck then
		local newAngle = pd.getCrankPosition()

		if newAngle ~= self.angle then
			-- sprites don't automatically get marked as dirty unless they move
			self:markDirty()
		end

		self.angle = newAngle
	end

	if not self.stuck then
		-- gravity
		self.velocity = self.velocity + GRAVITY_STEP

		-- friction
		self.velocity = self.velocity + self.velocity:scaledBy(-FRICTION_CONSTANT)

		local velocityStep = self.velocity * DT
		local _, _, _, collisionCount = self:moveWithCollisions(self.x + velocityStep.dx, self.y + velocityStep.dy)

		if collisionCount > 0 then
			self.stuck = true
			self.velocity.dx = 0
			self.velocity.dy = 0
		end

		if self.y >= SCREEN_HEIGHT then
			self.stuck = true
			self.velocity.dy = 0
			self.velocity.dx = 0
			self:moveTo(self.x, SCREEN_HEIGHT)
		end

		if self.x <= 0 then
			self:moveTo(0, self.y)
			self.velocity.dx = -self.velocity.dx
		elseif self.x >= SCREEN_WIDTH then
			self:moveTo(SCREEN_WIDTH, self.y)
			self.velocity.dx = -self.velocity.dx
		end
	end

	if self.stuck and pd.buttonJustPressed(pd.kButtonB) then
		self.stuck = false
		self.velocity.dx = HOP_VELOCITY * math.sin(math.rad(self.angle))
		self.velocity.dy = HOP_VELOCITY * -math.cos(math.rad(self.angle))
	end
end

function Slime:draw()
	if self.stuck then
		local pointerOffsetX = 20 * math.sin(math.rad(self.angle))
		local pointerOffsetY = 20 * -math.cos(math.rad(self.angle))

		gfx.drawLine(20, 20, 20 + pointerOffsetX, 20 + pointerOffsetY)
	end

	gfx.fillCircleAtPoint(20, 20, 5)
end

function Setup()
	-- set the game up
	pd.display.setRefreshRate(FRAME_RATE)

	LoadTheClimb()

	-- set up game menu
	local menu = playdate.getSystemMenu()
end

function LoadTheClimb()
	slime = Slime(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 20)

	local wallWidth = SCREEN_WIDTH / 2 - 45
	Wall(0, 0, wallWidth, SCREEN_HEIGHT)
	Wall(SCREEN_WIDTH - wallWidth, 0, wallWidth, SCREEN_HEIGHT)

	goal = Goal(SCREEN_WIDTH / 2, 10, SCREEN_WIDTH - (wallWidth * 2), 20)
end

function LoadPlayground()
	slime = Slime(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT / 2)

	Wall(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 25, 25, 25)
	Wall(SCREEN_WIDTH / 2 + 25, SCREEN_HEIGHT - 25 - 25, 25, 25)
	Wall(SCREEN_WIDTH / 2 + (25 * 2), SCREEN_HEIGHT - 25 - (25 * 2), 25, 25)
	Wall(SCREEN_WIDTH / 2 + (25 * 3), SCREEN_HEIGHT - 25 - (25 * 3), 25, 25)
	Wall(SCREEN_WIDTH / 2 + (25 * 4), SCREEN_HEIGHT - 25 - (25 * 4), 25, 25)
	Wall(SCREEN_WIDTH / 2 + (25 * 5), SCREEN_HEIGHT - 25 - (25 * 5), 25, 25)

	SpikesList = {Spikes(10, 10, 20, SCREEN_HEIGHT - 20)}

	goal = Goal(SCREEN_WIDTH - 60, 150, 50, 50)
end

function pd.update()
	if goal:getBoundsRect():containsPoint(slime:getPosition()) then
		goal:remove()
		won = true
	else
		goal:add()
	end

	for _, spike in ipairs(SpikesList) do
		if spike:getBoundsRect():containsPoint(slime:getPosition()) then
			dead = true
			slime:remove()
		end	
	end

	gfx.sprite.update()

	gfx.drawText("angle " .. slime.angle, 10, 10)
	gfx.drawText("dx " .. slime.velocity.dx, 10, 30)
	gfx.drawText("stuck " .. tostring(slime.stuck), 10, 50)
	gfx.drawText("won? " .. tostring(won), 10, 70)
	gfx.drawText("dead? " .. tostring(dead), 10, 90)

	timer.updateTimers()
end

Setup()
