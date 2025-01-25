local movement = require("lua.screens.game_screen.components.movement")
local objects = require("lua.screens.game_screen.components.objects")
local graphics = require("lua.screens.game_screen.components.graphics")
local background = require("lua.screens.game_screen.components.background")

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
end

-- function to run when love draws the game screen
M.draw = function()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    -- Background
	background.draw_backgroud()

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
