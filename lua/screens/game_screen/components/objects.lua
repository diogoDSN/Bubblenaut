local M = {}

M.bubble = {
    center_x = 0,
    center_y = 0,
    inner_radius = 0,
    outer_radius = 0,
    step = 0,
}

local bubble_y_offset = love.graphics.getHeight() / 3

M.setupGame = function()
	M.bubble.center_x = love.graphics.getWidth() / 2
	M.bubble.center_y = love.graphics.getHeight() / 2 + bubble_y_offset 
	M.bubble.inner_radius = 50
	M.bubble.outer_radius = 52
	M.bubble.step = 50

	M.spike = {
		center_x = 800,
		center_y = 200,
		inner_radius = 50,
		outer_radius = 52,
		step = 50,
		fill_color = {1, 0, 0, 0.5},
		line_color = {1, 0, 0},
	}
end

return M
