require "lua.draw"
require "lua.update"
require "lua.audio.mic"
require "lua.inputs"
local state = require "lua.state"
local push = require "push"
local conf = require "conf"

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowHeight*.7, windowHeight*.7*5/4 --make the window a bit smaller than the screen itself

push:setupScreen(conf.gameWidth, conf.gameHeight, windowWidth, windowHeight, {fullscreen = false})

math.randomseed(os.time())

function love.load()
    state.current_screen.load()
end
