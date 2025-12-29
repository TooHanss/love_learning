--@class Player
--@field pos { x:number, y:number }
--@field speed number
--@field rad number
--@field texture love.Image
local Player = {}
Player.__index = Player

--@return Player
function Player:new()
	local self = setmetatable({}, Player)
	self.pos = { x = 250, y = 250 }
	self.prevPos = { x = 250, y = 250 }
	self.speed = 100
	self.shape = "circle"
	self.rad = 35
	self.inputMap = { left = "left", right = "right", up = "up", down = "down" }
	self.idleTexture = love.graphics.newImage("assets/tx_player.png")
	self.hitTexture = love.graphics.newImage("assets/tx_player_hit.png")
	self.currentTexture = self.idleTexture
	self.blockMovement = false
	self.canHit = true
	self.hitCD = 0.3
	self.lastHitTime = -1000
	self.currentTime = 0
	self.hitting = false
	self.player = true
	self.oppRegion = { tl = { x = 0, y = 0 }, br = { x = 0, r = 0 } }
	self.debugCollision = false
	return self
end

--@param dt number
function Player:update(dt)
	if love.keyboard.isDown("r") then
		love.event.quit("restart")
	end
	self.currentTime = dt + self.currentTime
	self:handleHit(dt)
	self:handleMove(dt)
end

function Player:handleHit(dt)
	if self.hitting then
		self.hitting = false
	end
	if self.lastHitTime + self.hitCD <= self.currentTime then
		self.canHit = true
		self.currentTexture = self.idleTexture
	else
		self.canHit = false
	end
	if not self.canHit then
		return
	end
	if love.keyboard.isDown("space") then
		self.lastHitTime = self.currentTime
		self.hitting = true
		self.currentTexture = self.hitTexture
	end
end

function Player:handleMove(dt)
	self.prevPos.x = self.pos.x
	self.prevPos.y = self.pos.y
	if love.keyboard.isDown(self.inputMap.left) then
		self.pos.x = self.pos.x - self.speed * dt
	end
	if love.keyboard.isDown(self.inputMap.right) then
		self.pos.x = self.pos.x + self.speed * dt
	end
	if love.keyboard.isDown(self.inputMap.up) then
		self.pos.y = self.pos.y - self.speed * dt
	end
	if love.keyboard.isDown(self.inputMap.down) then
		self.pos.y = self.pos.y + self.speed * dt
	end
end

function Player:draw()
	w = self.currentTexture:getWidth()
	h = self.currentTexture:getHeight()
	love.graphics.draw(self.currentTexture, self.pos.x, self.pos.y, 0, 1, 1, w / 2, h / 2)
	love.graphics.setColor(1, 1, 1, 1)
	if self.debugCollision then
		love.graphics.circle("fill", self.pos.x, self.pos.y, self.rad)
	end
end

function Player:onCollision(other)
	-- ideally resolve x and y separately in the world i guess. so we can slide.
	if other.blockMovement then
		self.pos.x = self.prevPos.x
		self.pos.y = self.prevPos.y
	end
end

function Player:setOppRegion(in_tl, in_br)
	self.oppRegion = { tl = in_tl, br = in_br }
end

return Player
