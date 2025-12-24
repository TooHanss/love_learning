local PPTable = {}
PPTable.__index = PPTable

function PPTable.new()
	local self = setmetatable({}, PPTable)
	self.shape = "rect"
	self.pos = { x = 400, y = 250 }
	self.size = { x = 111, y = 200 }
	self.block_movement = true
	return self
end

function PPTable:draw()
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line", self.pos.x, self.pos.y, self.size.x, self.size.y)
	love.graphics.rectangle("line", self.pos.x, self.pos.y, self.size.x / 2, self.size.y)
	love.graphics.setColor(0.5, 0.5, 0.5, 1)
	local net_pos = { x = self.pos.x, y = self.pos.y + self.size.y / 2 }
	local net_height = 10
	love.graphics.rectangle("fill", net_pos.x, net_pos.y - net_height, self.size.x, net_height)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", net_pos.x, net_pos.y - net_height, self.size.x, net_height)
	love.graphics.setColor(1, 1, 1, 1)
end

function PPTable:onCollision(other) end

return PPTable
