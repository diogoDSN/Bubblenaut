local state = require("lua.state")
local conf = require("conf")

function love.update(dt)
    if conf.debug_fps then
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
