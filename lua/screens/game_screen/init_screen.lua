local movement = require("lua.screens.game_screen.components.movement")
local objects = require("lua.screens.game_screen.components.objects")
local graphics = require("lua.screens.game_screen.components.graphics")

local M = {}

-- runs once when opening the game screen
M.load = function()
    objects.bubble.center_x = love.graphics.getWidth() / 2
    objects.bubble.center_y = love.graphics.getHeight() / 2
end

-- function to run when love updates the game state, runs before drawing
M.update = function(dt)
    movement.handle_movement(dt)
end

-- function to run when love draws the game screen
M.draw = function()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()


    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(graphics.bubble_outer_line_width(objects.bubble))
    love.graphics.circle("line", objects.bubble.center_x, objects.bubble.center_y, objects.bubble.outer_radius)
    love.graphics.setColor(0.2, 0.2, 1, 0.5)
    love.graphics.circle("fill", objects.bubble.center_x, objects.bubble.center_y, objects.bubble.inner_radius)
end

return M
