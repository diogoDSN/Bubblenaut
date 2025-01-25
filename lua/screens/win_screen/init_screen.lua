local router = require("lua.commons.router")

local M = {}

local beamer

M.load = function()
    print("Win screen loaded")

    beamer = router.new_beamer(
        "menu_screen",
        0.2
    )
end

M.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print("You win!", 100, 100)
    love.graphics.print("Press space to return to the menu", 100, 200)
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
