local state = require("lua.state")

function love.draw()
    state.current_screen.draw()
end
