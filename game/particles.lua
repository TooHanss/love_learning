local particles = {}

function particles.spawn(parent_pos, min_spawn, max_spawn, min_speed, max_speed, min_life, max_life)
	for i = 1, math.random(min_spawn, max_spawn) do
		local particle = {
			pos = { x = parent_pos.x, y = parent_pos.y },
			speed = math.random(min_speed, max_speed),
			angle = math.random(0.0, 6.2),
			life = math.random(min_life, max_life),
		}
		table.insert(particles, particle)
	end
end

function particles.update(dt)
	for i = #particles, 1, -1 do
		local particle = particles[i]

		particle.pos.x = particle.pos.x + math.cos(particle.angle) * particle.speed * dt
		particle.pos.y = particle.pos.y + math.sin(particle.angle) * particle.speed * dt

		particle.life = particle.life - dt
		if particle.life <= 0 then
			table.remove(particles, i)
		end
	end
end

function particles.draw()
	for _, particle in ipairs(particles) do
		love.graphics.circle("fill", particle.pos.x, particle.pos.y, 2)
	end
end

return particles
