Rectangle = Object:extend()

function Rectangle:new(x, y, width, height, speed, mode)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.speed = speed
	self.mode = mode
end

function Rectangle:update(dt)
	self.x = self.x + self.speed * dt
end

function Rectangle:draw()
	love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end
