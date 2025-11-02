local bullets = {}

function bullets.spawn(angle, pos)
  local bullet = {
    speed = 500,
    angle = angle,
    pos = {x = pos.x, y = pos.y},
    life = 2,
  }

  table.insert(bullets, bullet)
end

function bullets.update(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.pos.x = b.pos.x + math.cos(b.angle - math.pi/2) * b.speed * dt
        b.pos.y = b.pos.y + math.sin(b.angle - math.pi/2) * b.speed * dt
        b.life = b.life - dt
        if b.life <= 0 then
            table.remove(bullets, i)
        end
    end
end

function bullets.draw()
  for _, b in ipairs(bullets) do
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", b.pos.x, b.pos.y, 5)
  end
end

return bullets
