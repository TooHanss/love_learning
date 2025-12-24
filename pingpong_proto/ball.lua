local utils = require("utils")
local Ball = {}
Ball.__index = Ball

function Ball.new()
	local self = setmetatable({}, Ball)
	self.shape = "circle"
	self.rad = 10
	self.pos = { x = 100, y = 100 }
	self.angle = 0.0
	self.speed = 100.0
	self.block_movement = false
	self.targetPos = { x = 0, y = 0 }
	self.colliding = true
	return self
end

function Ball:update(dt)
	self.pos.x = self.pos.x + math.cos(self.angle) * self.speed * dt
	self.pos.y = self.pos.y + math.sin(self.angle) * self.speed * dt
	if utils.float_eq(self.pos.x, self.targetPos.x, 0.5) then
		print("------------------------------")
		self:onTargetReached()
	end
end

function Ball:draw()
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.rad)
	love.graphics.circle("fill", self.targetPos.x, self.targetPos.y, self.rad)
end

function Ball:onCollision(other)
	if self.colliding == false then
		return
	end
	if other.player then
		self.colliding = false
		local newPos = {
			x = math.random(other.oppRegion.tl.x, other.oppRegion.br.x),
			y = math.random(other.oppRegion.tl.y, other.oppRegion.br.y),
		}
		self:setTargetPos(newPos)
	end
end

function Ball:onTargetReached()
	self.colliding = true
	print("Ball reached the target")
end

function Ball:setTargetPos(pos)
	self.angle = math.atan2(pos.y - self.pos.y, pos.x - self.pos.x)
	self.targetPos.x = pos.x
	self.targetPos.y = pos.y
end

return Ball
