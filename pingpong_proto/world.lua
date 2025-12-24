local collision = require("collision")
--@class World
local World = {}
World.__index = World

--@return World
function World.new()
	local self = setmetatable({}, World)
	self.objects = {}
	return self
end

function World:add(object)
	table.insert(self.objects, object)
end

function World:update(dt)
	for _, obj in ipairs(self.objects) do
		if obj.update then
			obj:update(dt)
		end
	end

	for i = 1, #self.objects do
		local a = self.objects[i]
		for j = i + 1, #self.objects do
			local b = self.objects[j]
			if collision.collide(a, b) then
				a:onCollision(b)
				b:onCollision(a)
			end
		end
	end
end

function World:draw()
	for _, obj in ipairs(self.objects) do
		if obj.draw then
			obj:draw()
		end
	end
end

return World
