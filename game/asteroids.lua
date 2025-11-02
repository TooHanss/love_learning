local window = require("window")
local player = require("player")
local asteroids = {}
local spawn_cooldown = 2
local spawn_cooldown_default = 2
local max_asteroids = 20

function asteroids.spawn(pos, angle)
	local asteroid = {
		pos = { x = pos.x, y = pos.y },
		speed = math.random(20, 50),
		angle = angle,
		rot = 0,
		rot_speed = math.random(-1, 1),
		img = love.graphics.newImage("assets/tx_asteroid.png"),
		life = 20,
		dead = false,
	}
	table.insert(asteroids, asteroid)
end

function asteroids.update(dt)
	spawn_cooldown = math.max(0, spawn_cooldown - dt)
	if #asteroids < max_asteroids then
		if spawn_cooldown <= 0 then
			local new_pos = getRandomSpawnPosition()
			asteroids.spawn(new_pos, getLookatRotation(new_pos.x, new_pos.y, player.pos.x, player.pos.y))
			spawn_cooldown = spawn_cooldown_default
		end
	end
	for i = #asteroids, 1, -1 do
		local a = asteroids[i]
		a.rot = a.rot + a.rot_speed * dt
		a.pos.x = a.pos.x + math.cos(a.angle) * a.speed * dt
		a.pos.y = a.pos.y + math.sin(a.angle) * a.speed * dt
		a.life = a.life - dt
		if a.life <= 0 then
			a.dead = true
		end
		-- Wrapping
		if a.pos.x > window.width then
			a.pos.x = 0
		end

		if a.pos.x < 0 then
			a.pos.x = window.width
		end

		if a.pos.y > window.height then
			a.pos.y = 0
		end

		if a.pos.y < 0 then
			a.pos.y = window.height
		end

		if a.dead then
			table.remove(asteroids, i)
		end
	end
end

function asteroids.draw()
	for _, a in ipairs(asteroids) do
		w = a.img:getWidth()
		h = a.img:getHeight()
		love.graphics.draw(a.img, a.pos.x, a.pos.y, a.rot, 1, 1, w / 2, h / 2)
	end
end

function getLookatRotation(x1, y1, x2, y2)
	local angle = math.atan2(y2 - y1, x2 - x1)
	return angle
end

function getRandomSpawnPosition()
	local edge = math.random(1, 4) -- 1=top, 2=bottom, 3=left, 4=right
	local x, y

	if edge == 1 then
		-- Top edge
		x = math.random(0, window.width)
		y = -20
	elseif edge == 2 then
		-- Bottom edge
		x = math.random(0, window.width)
		y = window.height + 20
	elseif edge == 3 then
		-- Left edge
		x = -20
		y = math.random(0, window.height)
	elseif edge == 4 then
		-- Right edge
		x = window.width + 20
		y = math.random(0, window.height)
	end

	return { x = x, y = y }
end

return asteroids
