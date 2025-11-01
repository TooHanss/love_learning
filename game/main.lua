function love.load()
  love.window.setTitle("Asteroids")
  love.window.setMode(500, 500)

  Player = {
    thrust = 500,
    friciton = 0.98,
    velocity_x = 0.0,
    velocity_y = 0.0,
    rot_speed = 3.0,
    rot = 0,
    pos = {x = 250, y = 250},
    texture = love.graphics.newImage("assets/tx_player.png"),
  }

end


function love.update(dt)
  if love.keyboard.isDown("left") then
    Player.rot = Player.rot - Player.rot_speed  * dt
  end
  if love.keyboard.isDown("right") then
    Player.rot = Player.rot + Player.rot_speed * dt
  end
  if love.keyboard.isDown("up") then
    -- Player.pos.x = Player.pos.x + 10
    Player.velocity_x = Player.velocity_x - math.cos(Player.rot + math.pi / 2) * Player.thrust * dt
    Player.velocity_y = Player.velocity_y - math.sin(Player.rot + math.pi / 2) * Player.thrust * dt
  end

  Player.velocity_x = Player.velocity_x * Player.friciton
  Player.velocity_y = Player.velocity_y * Player.friciton

  Player.pos.x = Player.pos.x + Player.velocity_x * dt
  Player.pos.y = Player.pos.y + Player.velocity_y * dt

end


function love.draw()
  w = Player.texture:getWidth()
  h = Player.texture:getHeight()
  love.graphics.draw(Player.texture, Player.pos.x, Player.pos.y, Player.rot, 1, 1, w / 2, h / 2)
end
