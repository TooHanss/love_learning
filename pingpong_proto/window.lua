local Window = {}
Window.__index = Window

function Window.new()
	local self = setmetatable({}, Window)
	self.title = "Ping Ping Pong Pong"
	self.size = { x = 1280, y = 720 }
	return self
end

return Window
