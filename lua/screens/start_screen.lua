local M = {}

BUTTON_BORDER_COLOR = {
	1, 1, 1 
}

BUTTON_FILL_COLOR = {
	0.141, 0.941, 0.098
}

local BORDER_PERCENTAGE = 0.10

M.drawButton = function (x, y, width, height)
	local borderPercentage = BORDER_PERCENTAGE * math.min(width, height)

	love.graphics.setColor(BUTTON_FILL_COLOR)
	love.graphics.setLineWidth(10)
	love.graphics.rectangle(
		"fill", x, y, width, height,
		 borderPercentage, borderPercentage, 100
	)
	love.graphics.setColor(BUTTON_BORDER_COLOR)
	love.graphics.rectangle(
		"line", x, y, width, height,
		 borderPercentage, borderPercentage, 100
	)
end

M.load = function ()
end

M.draw = function ()
	M.drawButton(100, 100, 600, 600)
end

-- Update functions should return a new screen in case we change screen
M.update = function (dt)
	return nil
end

return M
