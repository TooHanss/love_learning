local Player = require("player")
local World = require("world")
local PPTable = require("pp_table")
local Window = require("window")
local Ball = require("ball")
local collision = require("collision")

local world
local player_1
local pptable
local ball
local window

function love.load()
	window = Window.new()
	love.window.setMode(window.size.x, window.size.y)
	love.window.setTitle(window.title)

	world = World.new()
	player_1 = Player.new()
	player_2 = Player.new()
	player_2.inputMap = { left = "a", right = "d", up = "w", down = "s" }
	pptable = PPTable.new()
	ball = Ball.new()

	player_1.pos = { x = window.size.x / 2 - pptable.size.x / 2, y = window.size.y / 2 + pptable.size.y / 2 + 20 }
	player_2.pos = { x = window.size.x / 2 + pptable.size.x / 2, y = window.size.y / 2 - pptable.size.y / 2 - 20 }
	pptable.pos = { x = window.size.x / 2 - pptable.size.x / 2, y = window.size.y / 2 - pptable.size.y / 2 }
	ball.pos = { x = window.size.x / 2, y = window.size.y / 2 }

	player_1:setOppRegion(pptable.pos, { x = pptable.pos.x + pptable.size.x, y = pptable.pos.y + pptable.size.y / 2 })
	player_2:setOppRegion(
		{ x = pptable.pos.x, y = pptable.pos.y + pptable.size.y / 2 },
		{ x = pptable.pos.x + pptable.size.x, y = pptable.pos.y + pptable.size.y }
	)

	ball:setTargetPos(player_1.pos)

	world:add(player_2)
	world:add(pptable)
	world:add(ball)
	world:add(player_1)
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	world:draw()
end
