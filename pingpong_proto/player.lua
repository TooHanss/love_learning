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
	self.rad = 10
	self.inputMap = { left = "left", right = "right", up = "up", down = "down" }
	self.texture = love.graphics.newImage("assets/tx_player.png")
	self.blockMovement = false
	self.player = true
	self.oppRegion = { tl = { x = 0, y = 0 }, br = { x = 0, r = 0 } }
	return self
end

--@param dt number
function Player:update(dt)
	self:handleMove(dt)
	if love.keyboard.isDown("space") then
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
	w = self.texture:getWidth()
	h = self.texture:getHeight()
	love.graphics.draw(self.texture, self.pos.x, self.pos.y, 0, 1, 1, w / 2, h / 2)
	love.graphics.setColor(1, 1, 1, 1)
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
