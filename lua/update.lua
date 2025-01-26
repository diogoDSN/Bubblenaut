local state = require("lua.state")

local debug_prints = false

function love.update(dt)
    if debug_prints then
        print(1 / dt, "fps")
    end

    local new_screen, level_played = state.current_screen.update(dt)

	if level_played ~= nil then
		state.setCurrentLevel(level_played)
	end

    if new_screen ~= nil then
        state.setScreen(new_screen)
        state.current_screen.load(state.getCurrentLevel())
    end
end
