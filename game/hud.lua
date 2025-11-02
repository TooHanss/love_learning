local hud = {}
local player = require("player")

function hud.update(dt) end

function hud.draw(dt)
	for i = 1, player.lives, 1 do
		local x = 10 + (player.texture:getWidth() * i)
		love.graphics.draw(player.texture, x, 10)
	end
end

return hud
