local movement = require("lua.screens.game_screen.components.movement.movement")
local objects = require("lua.screens.game_screen.components.objects")
local graphics = require("lua.screens.game_screen.components.graphics")
local background = require("lua.screens.game_screen.components.background")
local conf = require "conf"

local M = {}

-- runs once when opening the game screen
M.load = function()
	objects.setupGame()
	background.setup_background()
end

-- function to run when love updates the game state, runs before drawing
M.update = function(dt)
    movement.handle_movement(dt)
	background.update_background()

    local game_state = movement.game_state
    if game_state.running then
        return nil
    else
        return "game_over"
    end
end

-- function to run when love draws the game screen
M.draw = function()
    local width = conf.gameWidth
    local height = conf.gameHeight

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    -- Background
	background.draw_backgroud()

    -- Bubble
    objects.draw_bubble()

    -- Obstacles
    objects.draw_obstacles()
end

return M
