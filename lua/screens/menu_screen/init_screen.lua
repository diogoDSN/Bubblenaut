local love = require("love")
local M = {}
local conf = require "conf"

M.load = function ()
    print("Menu screen loaded")
    M.background = love.graphics.newImage("archive/menu-background.png")
end

M.draw = function ()
    love.graphics.draw(M.background, 0, 0)
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Welcome to", 0, conf.gameHeight / 8, conf.gameWidth, "center")
    love.graphics.printf("Bubblenaut", 0, conf.gameHeight / 4, conf.gameWidth, "center")
    love.graphics.printf("Press SPACE to Start :)", 0, conf.gameHeight / 2, conf.gameWidth, "center")
end


M.update = function ()
    if love.keyboard.isDown("space") then
        return "game_screen"
    end
end

return M

