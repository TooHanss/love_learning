local collision = {}
local bullets = require("bullets")
local asteroids = require("asteroids")
local player = require("player")

function collision.checkCircleCollision(x1, y1, r1, x2, y2, r2)
	local dx = x2 - x1
	local dy = y2 - y1
	local distance = math.sqrt(dx * dx + dy * dy)
	return distance < r1 + r2
end

function collision.handleCollisions()
	-- Asteroids vs Player
	for i = #asteroids, 1, -1 do
		local a = asteroids[i]
		if
			checkCircleCollision(a.pos.x, a.pos.y, 25 * a.size_to_split[a.split_level], player.pos.x, player.pos.y, 30)
		then
			if not player.invincible then
				player.damage()
				a.dead = true
			end
		end
	end

	-- Asteroids vs Bullets
	for i = #bullets, 1, -1 do
		local b = bullets[i]
		for j = #asteroids, 1, -1 do
			local a = asteroids[j]
			if checkCircleCollision(b.pos.x, b.pos.y, 5, a.pos.x, a.pos.y, 32) then
				b.dead = true
				a.dead = true
			end
		end
	end
end

return collision
