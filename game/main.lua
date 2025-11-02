local player = require("player")

function love.load()
  love.window.setTitle("Asteroids")
  love.window.setMode(500, 500)

  player.load()
end


function love.update(dt)
  player.update(dt)
end


function love.draw()
  player.draw()
end
