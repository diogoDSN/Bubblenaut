require "lua.draw"
require "lua.update"
require "lua.audio.mic"
local state = require "lua.state"
local push = require "push"

local gameWidth, gameHeight = 540, 540 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowHeight*.9, windowHeight*.9 --make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

function love.load()
    state.current_screen.load()
end
