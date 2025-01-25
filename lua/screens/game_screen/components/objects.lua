local M = {}

M.bubble = {
    center_x = 0,
    center_y = 0,
    inner_radius = 0,
    outer_radius = 0,
    step = 0,
}

M.draw_bubble = function()
	local bubble_sprite_width = M.bubble.sprite:getWidth()
	local bubble_sprite_height = M.bubble.sprite:getHeight()
	
	-- Calculate center of the image
	local center_x = bubble_sprite_width / 2
	local center_y = bubble_sprite_height / 2

	local scale_factor = (M.bubble.outer_radius / bubble_sprite_width) * 2

	love.graphics.draw(
		M.bubble.sprite,               -- sprite
		M.bubble.center_x, M.bubble.center_y, -- position
		0,                                    -- rotation
		scale_factor, scale_factor,           -- scaling
		center_x, center_y                    -- pivot
	)
end

local bubble_y_offset = love.graphics.getHeight() / 3

M.setupGame = function()
	M.bubble.sprite = love.graphics.newImage("archive/bubble.png")

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
