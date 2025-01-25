require "lua.draw"
require "lua.update"
local state = require "lua.state"

math.randomseed(os.time())

function love.load()
    love.window.setMode(1024, 1024)
    state.current_screen.load()
end
