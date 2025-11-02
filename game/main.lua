local player = require("player")
local asteroids = require("asteroids")
local collision = require("collision")
local window = require("window")
local hud = require("hud")

function love.load()
	love.window.setTitle("Asteroids")
	love.window.setMode(500, 500)

	player.load()
end

function love.update(dt)
	if player.dead == true then
		if love.keyboard.isDown("r") then
			love.event.quit("restart")
		end
		return
	end
	player.update(dt)
	asteroids.update(dt)
	collision.handleCollisions()
end

function love.draw()
	if player.dead == true then
		love.graphics.print("You died! Press R to restart :)", 10, 10, 0, 2, 2)
		return
	end
	player.draw()
	asteroids.draw()
	hud.draw()
end
