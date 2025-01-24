local state = require("lua.state")

function love.update(dt)
	local newScreen = state.screen.update(dt)
	if newScreen ~= nil then
		state.screen = newScreen
		state.screen.load()
	end
end
