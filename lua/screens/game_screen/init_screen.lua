local movement = require("lua.screens.game_screen.components.movement.movement")
local objects = require("lua.screens.game_screen.components.objects")
local graphics = require("lua.screens.game_screen.components.graphics")
local background = require("lua.screens.game_screen.components.background")

local M = {}

-- runs once when opening the game screen
M.load = function()
    objects.setupGame()
end

-- function to run when love updates the game state, runs before drawing
M.update = function(dt)
    movement.handle_movement(dt)

    local game_state = movement.game_state
    if game_state.running then
        return nil
    else
        return "game_over"
    end
end

-- function to run when love draws the game screen
M.draw = function()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    -- Background
    --local game_background_image = love.graphics.newImage("archive/game-background.png")
    --love.graphics.draw(game_background_image, background.background.center_x, background.background.center_y, 0, 1, 1, background.background.width / 2, background.background.height)

    -- Bubble
    objects.draw_bubble()

    -- Spike
    love.graphics.setColor(graphics.spike_line_color(objects.spike))
    love.graphics.setLineWidth(graphics.spike_outer_line_width(objects.spike))
    love.graphics.circle("line", objects.spike.center_x, objects.spike.center_y, objects.spike.outer_radius)
    love.graphics.setColor(graphics.spike_fill_color(objects.spike))
    love.graphics.circle("fill", objects.spike.center_x, objects.spike.center_y, objects.spike.inner_radius)
end

return M
