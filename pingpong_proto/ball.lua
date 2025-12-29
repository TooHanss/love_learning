local utils = require("utils")
local Ball = {}
Ball.__index = Ball

function Ball.new()
	local self = setmetatable({}, Ball)
	self.shape = "circle"
	self.defaultRad = 5
	self.rad = 3
	self.pos = { x = 100, y = 100 }
	self.startPos = { x = self.pos.x, y = self.pos.y }
	self.angle = 0.0
	self.speed = 100
	self.maxSpeed = 200
	self.blockMovement = false
	self.oneBounce = false
	self.targetPos = { x = 0, y = 0 }
	self.colliding = true
	self.hittable = true
	self.onTable = false
	self.debugTargetPos = false
	self.lastHitter = nil
	self.served = false
	self.server = nil
	self.height = 0.0 --Do something here like get distance to target pos and make the height go up and down
	self.heightScale = 0.5
	self.startHeight = 0.0
	self.maxHeight = 20
	self.vPhase = 0
	self.hPhase = 0
	self.currentDist = 0
	return self
end

function Ball:startNewArc(tx, ty)
	-- 1. Capture where we are NOW
	self.startPos.x, self.startPos.y = self.pos.x, self.pos.y
	self.startHeight = self.height

	-- 2. Set where we are GOING
	self:setTargetPos({ x = tx, y = ty })

	-- 3. Calculate the difference (Delta)
	local dx = self.targetPos.x - self.startPos.x -- FIXED
	local dy = self.targetPos.y - self.startPos.y -- FIXED

	-- 4. Get the true distance for the journey
	self.currentDist = math.sqrt(dx * dx + dy * dy)

	-- 5. Reset phases
	self.hPhase = 0
	self.vPhase = 0
end

function Ball:update(dt)
	if not self.served then
		if not self.server then
			return
		end
		self.height = 0
		self.pos.x = self.server.pos.x
		self.pos.y = self.server.pos.y
		return
	end

	self.hPhase = math.min(self.hPhase + self.speed * dt / self.currentDist, 1)
	self.vPhase = math.min(self.vPhase + self.speed * dt / self.currentDist, 1)
	self.pos.x = self.startPos.x + (self.targetPos.x - self.startPos.x) * self.hPhase
	self.pos.y = self.startPos.y + (self.targetPos.y - self.startPos.y) * self.hPhase
	local linearHeight = self.startHeight * (1 - self.vPhase)
	local arcHeight = self.heightScale * 4 * self.vPhase * (1 - self.vPhase)
	self.height = linearHeight + arcHeight
	if utils.float_eq(self.hPhase, 1.0, 0.01) then
		self:onTargetReached()
	end
end

function Ball:draw()
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.rad + (self.height * 5))
	if self.debugTargetPos then
		love.graphics.circle("fill", self.targetPos.x, self.targetPos.y, self.rad)
	end
end

function Ball:onCollision(other)
	if self.colliding == false then
		return
	end
	if other.table then
		self.onTable = true
	else
		self.onTable = false
	end
	if other.player then
		if not self.served then
			self.server = other
		end
		if other.hitting then
			self.served = true
			self.hittable = false
			self.oneBounce = false
			self.hPhase = 0
			self.lastHitter = other
			local newTarget = {
				x = math.random(other.oppRegion.tl.x, other.oppRegion.br.x),
				y = math.random(other.oppRegion.tl.y, other.oppRegion.br.y),
			}
			self:startNewArc(newTarget.x, newTarget.y)
			self.speed = utils.clamp(self.speed * 1.6, 0, self.maxSpeed)
		end
	end
end

function Ball:onTargetReached()
	if self.oneBounce then
		self.speed = 0
		self.hittable = false
		self.colliding = false
	end
	if self.onTable and not self.oneBounce then
		self.hittable = true
		self.oneBounce = true
		self.speed = self.speed * 0.8
	end
	local newTargetPos = { x = 0, y = 0 }
	newTargetPos.x = self.pos.x + math.cos(self.angle) * self.speed
	newTargetPos.y = self.pos.y + math.sin(self.angle) * self.speed
	self:startNewArc(newTargetPos.x, newTargetPos.y)
end

function Ball:setTargetPos(pos)
	self.angle = math.atan2(pos.y - self.pos.y, pos.x - self.pos.x)
	self.targetPos.x = pos.x
	self.targetPos.y = pos.y
end

return Ball
