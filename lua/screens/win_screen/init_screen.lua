local router = require("lua.commons.router")

local M = {}

local beamer

M.load = function()
    print("Win screen loaded")
    M.background = love.graphics.newImage("archive/win-background.png")

    beamer = router.new_beamer(
        "menu_screen",
        0.2
    )
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
