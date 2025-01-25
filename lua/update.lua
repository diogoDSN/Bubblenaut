local state = require("lua.state")

function love.update(dt)
    local new_screen = state.current_screen.update(dt)
    if new_screen ~= nil then
		state.setScreen(new_screen)
        state.current_screen.load()
    end
end
