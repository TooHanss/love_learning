
local player = {}
local bullets = require("bullets")

function player.load()
  player.thrust = 500
  player.friciton = 0.98
  player.velocity_x = 0.0
  player.velocity_y = 0.0
  player.rot_speed = 3.0
  player.rot = 0
  player.pos = {x = 250, y = 250}
  player.bullet_cooldown = 0
  player.bullet_cooldown_default = 0.25
  player.texture = love.graphics.newImage("assets/tx_player.png")
end


function player.update(dt)
  if love.keyboard.isDown("left") then
    player.rot = player.rot - player.rot_speed  * dt
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

end


function player.draw()
  w = player.texture:getWidth()
  h = player.texture:getHeight()
  love.graphics.draw(player.texture, player.pos.x, player.pos.y, player.rot, 1, 1, w / 2, h / 2)

  bullets.draw()
end

return player
