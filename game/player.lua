local player = {}
local bullets = require("bullets")

function player.load()
	player.thrust = 500
	player.friciton = 0.98
	player.velocity_x = 0.0
	player.velocity_y = 0.0
	player.rot_speed = 3.0
	player.rot = 0
	player.pos = { x = 250, y = 250 }
	player.bullet_cooldown = 0
	player.bullet_cooldown_default = 0.25
	player.texture = love.graphics.newImage("assets/tx_player.png")
	player.dead = false
	player.lives = 3
	player.damaged_cooldown = 0
	player.damaged_cooldown_default = 3
	player.invincible = false
end

function player.update(dt)
	if player.dead then
		return
	end
	if love.keyboard.isDown("left") then
		player.rot = player.rot - player.rot_speed * dt
	end
	if love.keyboard.isDown("right") then
		player.rot = player.rot + player.rot_speed * dt
	end
	if love.keyboard.isDown("up") then
		-- player.pos.x = player.pos.x + 10
		player.velocity_x = player.velocity_x - math.cos(player.rot + math.pi / 2) * player.thrust * dt
		player.velocity_y = player.velocity_y - math.sin(player.rot + math.pi / 2) * player.thrust * dt
	end

	player.velocity_x = player.velocity_x * player.friciton
	player.velocity_y = player.velocity_y * player.friciton

	player.pos.x = player.pos.x + player.velocity_x * dt
	player.pos.y = player.pos.y + player.velocity_y * dt

	-- Wrapping
	if player.pos.x > 500 then
		player.pos.x = 0
	end

	if player.pos.x < 0 then
		player.pos.x = 500
	end

	if player.pos.y > 500 then
		player.pos.y = 0
	end

	if player.pos.y < 0 then
		player.pos.y = 500
	end

	-- bullets
	player.bullet_cooldown = math.max(0, player.bullet_cooldown - dt)

	if love.keyboard.isDown("space") then
		if player.bullet_cooldown <= 0 then
			bullets.spawn(player.rot, player.pos)
			player.bullet_cooldown = player.bullet_cooldown_default
		end
	end

	bullets.update(dt)

	-- damaged
	if player.invincible then
		player.damaged_cooldown = player.damaged_cooldown - dt
		if player.damaged_cooldown <= 0 then
			player.invincible = false
		end
	end
end

function player.draw()
	if player.dead then
		return
	end
	w = player.texture:getWidth()
	h = player.texture:getHeight()
	if player.invincible then
		love.graphics.setColor(1, 0, 0, 1)
	end
	love.graphics.draw(player.texture, player.pos.x, player.pos.y, player.rot, 1, 1, w / 2, h / 2)
	love.graphics.setColor(1, 1, 1, 1)

	bullets.draw()
end

function player.damage()
	player.invincible = true
	player.lives = player.lives - 1
	player.damaged_cooldown = player.damaged_cooldown_default
	if player.lives <= 0 then
		player.dead = true
	end
end

return player
