local M = {}

local SCROLL_SPEED = 5

M.setup_background = function ()
    M.game_background_image = love.graphics.newImage("archive/game-background.png")
	M.game_background_image:setWrap("clamp", "repeat")
	M.game_background_scale_factor = love.graphics.getWidth() / M.game_background_image:getWidth()


	M.screenQuad = love.graphics.newQuad(
		0, -M.game_background_image:getHeight() + love.graphics.getHeight(),
		love.graphics.getWidth(), love.graphics.getHeight(),
		M.game_background_image
	)
	M.y = 0
end

M.update_background = function ()
	M.y = (M.y - SCROLL_SPEED) % M.game_background_image:getHeight()
	M.screenQuad:setViewport(
		0, M.y,
		love.graphics.getWidth(), love.graphics.getHeight(),
		M.game_background_image:getWidth(), M.game_background_image:getHeight()
	)
end

M.draw_backgroud = function ()
	love.graphics.draw(
		M.game_background_image,
		M.screenQuad,
		0, 0, nil,
		M.game_background_scale_factor
	)
end

return M
