local objects = require("lua.screens.game_screen.components.objects")

local M = {}

local function colides_with_spike(spike)
	local distance = math.sqrt(
		math.pow(spike[1] - objects.bubble.center_x, 2) +
		math.pow(spike[2] - objects.bubble.center_y, 2)
	)
	return distance < objects.bubble.radius + objects.spike_radius
end

local function colides_with_little_girl()
	--print(objects.little_girl.pos_x, objects.little_girl.pos_y, objects.bubble.center_x, objects.bubble.center_y)
	return objects.bubble.center_y + objects.bubble.radius >= objects.little_girl.pos_y and
		objects.bubble.center_x + objects.bubble.radius >= objects.little_girl.pos_x and
		objects.bubble.center_x - objects.bubble.radius <= objects.little_girl.pos_x + objects.little_girl.width
end

M.applyColisions = function()
	for _, spike in ipairs(objects.obstacles) do
		if colides_with_spike(spike) then
			return true
		end
	end

	return colides_with_little_girl()
end



return M
