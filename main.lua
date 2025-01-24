require "lua.draw"
require "lua.update"
local state = require "lua.state"

function love.load()
    love.window.setMode(1024, 1024)
    state.screen.load()
end
