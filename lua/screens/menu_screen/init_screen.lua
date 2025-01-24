local M = {}

game_screen = require "lua/screens/game_screen/init_screen"

M.load = function ()
    print("Menu screen loaded")
end

M.draw = function ()
    local background = love.graphics.newImage("archive/menu-background.png")
    M.draw = function ()
        love.graphics.draw(background, 0, 0)
        love.graphics.setColor(1, 1, 1, 1) 
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.printf("Welcome to", 0, love.graphics.getHeight() / 8, love.graphics.getWidth(), "center")
        love.graphics.printf("Bubblenaut", 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center")
        love.graphics.printf("Press SPACE to Start :)", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end


M.update = function (dt)
    if love.keyboard.isDown("space") then
        return game_screen
    end

	return nil
end

return M

