local router = require("lua.commons.router")
local conf = require "conf"

local M = {}


local beamer = router.new_beamer(
    "game_screen",
    0.2
)

M.load = function()
    print("Menu screen loaded")
    M.background = love.graphics.newImage("archive/menu-background.png")
end

M.draw = function()
    love.graphics.draw(M.background, 0, 0)
end


M.update = function(dt)
    if love.keyboard.isDown("space") then
        beamer:activate()
    end

    local next_screen = beamer:update(dt)
    if next_screen ~= nil then
        return next_screen
    end

    return nil
end

return M
