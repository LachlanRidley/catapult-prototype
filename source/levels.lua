local function loadJump()
    local level = {}

    level.slime = Slime(10, 10)

    local wallWidth = SCREEN_WIDTH / 2 - 45
    local wallHeight = SCREEN_HEIGHT * 0.6
    level.walls = {
        Wall(0, SCREEN_HEIGHT - wallHeight, wallWidth, wallHeight),
        Wall(SCREEN_WIDTH - wallWidth, SCREEN_HEIGHT - wallHeight, wallWidth, SCREEN_HEIGHT)
    }

    level.goal = Goal(SCREEN_WIDTH - 30, 76, 40, 40)

    return level
end

local function loadTheClimb()
    local level = {}

    level.slime = Slime(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 20)

    local wallWidth = SCREEN_WIDTH / 2 - 45
    level.walls = {
        Wall(0, 0, wallWidth, SCREEN_HEIGHT),
        Wall(SCREEN_WIDTH - wallWidth, 0, wallWidth, SCREEN_HEIGHT)
    }

    level.goal = Goal(SCREEN_WIDTH / 2, 10, SCREEN_WIDTH - (wallWidth * 2), 20)

    return level
end

local function loadPlayground()
    local level = {}

    level.slime = Slime(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT / 2)

    level.walls = {
        Wall(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 25, 25, 25),
        Wall(SCREEN_WIDTH / 2 + 25, SCREEN_HEIGHT - 25 - 25, 25, 25),
        Wall(SCREEN_WIDTH / 2 + (25 * 2), SCREEN_HEIGHT - 25 - (25 * 2), 25, 25),
        Wall(SCREEN_WIDTH / 2 + (25 * 3), SCREEN_HEIGHT - 25 - (25 * 3), 25, 25),
        Wall(SCREEN_WIDTH / 2 + (25 * 4), SCREEN_HEIGHT - 25 - (25 * 4), 25, 25),
        Wall(SCREEN_WIDTH / 2 + (25 * 5), SCREEN_HEIGHT - 25 - (25 * 5), 25, 25)
    }

    level.spikes = { Spike(10, 10, 20, SCREEN_HEIGHT - 20) }

    level.goal = Goal(SCREEN_WIDTH - 60, 150, 50, 50)

    return level
end

---@class Level
---@field order integer
---@field name string
---@field load function


---@type Level[]
LEVELS = { {
    order = 1,
    name = "Jump!",
    load = loadJump
}, {
    order = 2,
    name = "The Climb",
    load = loadTheClimb
}, {
    order = 3,
    name = "Playground",
    load = loadPlayground
} }
