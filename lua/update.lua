local state = require("lua.state")

local debug_prints = false

function love.update(dt)
    if debug_prints then
        print(1 / dt, "fps")
    end

    local new_screen = state.current_screen.update(dt)
    if new_screen ~= nil then
        state.setScreen(new_screen)
        state.current_screen.load()
    end
end
