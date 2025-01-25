local state = require("lua.state")
local push = require("push")

function love.draw()
    push:start()
    state.current_screen.draw()
    push:finish()
end
