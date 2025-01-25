local state = require("lua.state")

function love.keypressed(key)
    if state.current_screen.keypressed ~= nil then
        state.current_screen.keypressed(key)
    end
end
