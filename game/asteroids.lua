local window = require("window")
local player = require("player")
local asteroids = {}
local spawned = false
local currentLevel = 1

function asteroids.spawn(pos, angle, split_level)
	local max_speed_to_split = { 100, 75, 50 }
	local new_speed = math.random(20, max_speed_to_split[split_level])
	local asteroid = {
		pos = { x = pos.x, y = pos.y },
		speed = new_speed,
		size_to_split = { 0.50, 0.75, 1.0 },
		score_to_split = { 100, 50, 20 },
		angle = angle,
		rot = 0,
		rot_speed = math.random(-1, 1),
		img = love.graphics.newImage("assets/tx_asteroid.png"),
		split_level = split_level,
		dead = false,
	}
	table.insert(asteroids, asteroid)
end

function asteroids.update(dt)
	if not spawned then
		for _ = 1, 4, 1 do
			local new_pos = asteroids.getRandomSpawnPosition()
			asteroids.spawn(new_pos, math.random(0, 6.2), 3)
		end
		spawned = true
	end
	for i = #asteroids, 1, -1 do
		local a = asteroids[i]
		a.rot = a.rot + a.rot_speed * dt
		a.pos.x = a.pos.x + math.cos(a.angle) * a.speed * dt
		a.pos.y = a.pos.y + math.sin(a.angle) * a.speed * dt
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
			if a.split_level - 1 <= 0 then
				table.remove(asteroids, i)
				player.addScore(a.score_to_split[a.split_level])
			else
				player.addScore(a.score_to_split[a.split_level])
				asteroids.spawn(a.pos, math.random(0.0, 6.2), a.split_level - 1)
				asteroids.spawn(a.pos, math.random(0.0, 6.2), a.split_level - 1)
				table.remove(asteroids, i)
			end
		end
	end
end

function asteroids.draw()
	for _, a in ipairs(asteroids) do
		local w = a.img:getWidth()
		local h = a.img:getHeight()
		love.graphics.draw(
			a.img,
			a.pos.x,
			a.pos.y,
			a.rot,
			a.size_to_split[a.split_level],
			a.size_to_split[a.split_level],
			w / 2,
			h / 2
		)
	end
end

function asteroids.getRandomSpawnPosition()
	local edge = math.random(1, 4) -- 1=top, 2=bottom, 3=left, 4=right
	local x, y

	if edge == 1 then
		-- Top edge
		x = math.random(0, window.width)
		y = 20
	elseif edge == 2 then
		-- Bottom edge
		x = math.random(0, window.width)
		y = window.height - 20
	elseif edge == 3 then
		-- Left edge
		x = 20
		y = math.random(0, window.height)
	elseif edge == 4 then
		-- Right edge
		x = window.width - 20
		y = math.random(0, window.height)
	end

	return { x = x, y = y }
end

function asteroids.nextLevel()
	spawned = false
	currentLevel = currentLevel + 1
	if not spawned then
		for _ = 1, 4 + currentLevel - 1, 1 do
			local new_pos = asteroids.getRandomSpawnPosition()
			asteroids.spawn(new_pos, math.random(0, 6.2), 3)
		end
		spawned = true
	end
end

return asteroids
