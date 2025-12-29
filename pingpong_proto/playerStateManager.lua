local PlayerStateManager = {}
PlayerStateManager.__index = PlayerStateManager

--@return PlayerState
function PlayerStateManager.new()
	local self = setmetatable({}, PlayerStateManager)
	self.states = { "IDLE", "MOVE", "HIT" }
	return self
end

return PlayerStateManager
