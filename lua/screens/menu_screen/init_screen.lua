local router = require("lua.commons.router")
local conf = require "conf"

local M = {}
local buttons = {}

local beamer

M.load = function()
    print("Menu screen loaded")

    beamer = router.new_beamer(
        "game_screen",
        0.2
    )
    
    M.background = love.graphics.newImage("archive/menu-background.png")
end

local function newButton(id, x, y, width, height, onClick)
    return {
        id = id,
        x = x,
        y = y,
        width = width,
        height = height,
        onClick = onClick
    }
end

table.insert(buttons, newButton("start", 60, 260, 390, 150, function()
    if conf.debug then
        print("Start button clicked")
    end
    beamer:activate()
end))

table.insert(buttons, newButton("quit", 60, 446, 390, 150, function()
    if conf.debug then
        print("Quit button clicked")
    end
    love.event.quit()
end))


M.draw = function()
    love.graphics.draw(M.background, 0, 0)
    if conf.debug then
        for _, btn in ipairs(buttons) do
            love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.print("Menu screen", 10, 10)
    end
end


M.update = function(dt)
    if conf.debug then
        local x, y = love.mouse.getPosition()
        x = x * conf.gameWidth / love.graphics.getWidth()
        y = y * conf.gameHeight / love.graphics.getHeight()
        print(x, y)
    end
    
    if love.keyboard.isDown("space") then
        beamer:activate()
    end

    if love.keyboard.isDown("escape") or love.keyboard.isDown("q") then
        love.event.quit()
    end

    if love.mouse.isDown(1) then
        local x, y = love.mouse.getPosition()
        x = x * conf.gameWidth / love.graphics.getWidth()
        y = y * conf.gameHeight / love.graphics.getHeight()
        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.onClick()
            end
        end
    end

    local next_screen = beamer:update(dt)
    if next_screen ~= nil then
        return next_screen
    end

    return nil
end

return M
