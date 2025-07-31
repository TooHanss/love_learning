function love.load()
	Object = require("lib.classic")
	require("rectangle")
	r1 = Rectangle(100, 200, 30, 50, 40, "line")
	r2 = Rectangle(100, 300, 40, 50, 100, "fill")
end

function love.update(dt)
	r1:update(dt)
	r2:update(dt)
end

function love.draw()
	r1:draw()
	r2:draw()
end
