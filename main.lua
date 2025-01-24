require "lua.draw"
require "lua.update"
local state = require "lua.state"

function love.load()
    love.window.setMode(1200, 800)
    state.set_bubble_initial_state()
end

