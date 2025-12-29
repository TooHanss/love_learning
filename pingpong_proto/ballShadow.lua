local utils = require("utils")
local BallShadow = {}
BallShadow.__index = BallShadow

function BallShadow.new(ball)
	local self = setmetatable({}, BallShadow)
	self.ball = ball
	self.pos = { x = ball.pos.x, y = ball.pos.y }
	self.shadowOffsetRatio = 100
	return self
end

function BallShadow:update(dt)
	self.pos = { x = self.ball.pos.x + (self.ball.height * self.shadowOffsetRatio), y = self.ball.pos.y }
end

function BallShadow:draw()
	love.graphics.setColor(0.0, 0.0, 0.0, 1.0)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.ball.defaultRad)
	love.graphics.setColor(1, 1, 1, 1)
end

return BallShadow
