local collision = {}

function collision.collide(a, b)
	if not a.shape or not b.shape then
		return false
	end
	if a.shape == "rect" and b.shape == "rect" then
		return collision.rectangleVsRectangle(a, b)
	end
	if a.shape == "circle" and b.shape == "rect" then
		return collision.circleVsRectangle(a, b)
	end
	if a.shape == "rect" and b.shape == "circle" then
		return collision.circleVsRectangle(b, a)
	end
	if a.shape == "circle" and b.shape == "circle" then
		return collision.circleVsCircle(a, b)
	end
end

function collision.circleVsRectangle(c, r)
	local closestX = math.max(r.pos.x, math.min(c.pos.x, r.pos.x + r.size.x))
	local closestY = math.max(r.pos.y, math.min(c.pos.y, r.pos.y + r.size.y))

	local dx = c.pos.x - closestX
	local dy = c.pos.y - closestY

	return (dx * dx + dy * dy) <= c.rad * c.rad
end

function collision.circleVsCircle(a, b)
	local dx = a.pos.x - b.pos.x
	local dy = a.pos.y - b.pos.y
	local r = a.rad + b.rad
	return dx * dx + dy * dy < r * r
end

function collision.rectangleVsRectangle(a, b)
	return a.pos.x < b.pos.x + b.size.x
		and a.pos.x + a.size.x > b.pos.x
		and a.pos.y < b.pos.y + b.size.y
		and a.pos.y + a.size.y > b.pos.y
end

return collision
