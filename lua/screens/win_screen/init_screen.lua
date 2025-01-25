local M = {}

M.load = function ()
    print("Win screen loaded")
    M.background = love.graphics.newImage("archive/menu-background.png")
end

M.draw = function ()
    love.graphics.draw(M.background, 0, 0)
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print("You win!", 100, 100)
    love.graphics.print("Press space to return to the menu", 100, 200)
end


M.update = function (dt)
    if love.keyboard.isDown("space") then
        return "menu_screen"
    end

	return nil
end

return M

