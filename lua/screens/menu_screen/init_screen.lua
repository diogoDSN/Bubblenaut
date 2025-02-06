local router = require("lua.commons.router")
local conf = require "conf"
local configs = require("lua.screens.game_screen.config")
local button = require("lua.widgets.button")

local M = {}
local buttons = {}
local test_button = {}

local beamer

M.load = function()
    if conf.debug then
        print("Menu screen loaded")
    end

    beamer = router.new_beamer(
        "game_screen",
        0.2
    )

    M.background = love.graphics.newImage("archive/menu-background.png")
end

table.insert(buttons, button.new_button(
    400, 160,
    60, 260, 
    "START",
    {r = 1, g = 1, b = 1},      --button is blue by default 
    {r = 0.2, g = 0.2, b = 0.4},
    function()
        if conf.debug then
            print("Start button clicked")
        end
        beamer:activate()
    end
))

table.insert(buttons, button.new_button(
    400, 160,
    60, 446, 
    "QUIT",
    {r = 1, g = 1, b = 1},      --button is blue by default 
    {r = 0.2, g = 0.2, b = 0.4},
    function()
        if conf.debug then
            print("Quit button clicked")
        end
        love.event.quit()
    end
))

M.draw = function()
    love.graphics.draw(M.background, 0, 0)
    for _, btn in ipairs(buttons) do
        btn:draw()
    end
    if conf.debug then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.print("Menu screen", 10, 10)
    end

    love.graphics.setFont(love.graphics.newFont(20))
    if configs.controls.single_player then
        love.graphics.print("Single Player Mode: Active", 0, 0)
    else
        love.graphics.print("Single Player Mode: Inactive", 0, 0)
    end
    love.graphics.print("Press 'P' to change mode", 0, 20)
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
    
    local x, y = love.mouse.getPosition()

    x = x * conf.gameWidth / love.graphics.getWidth()
    y = y * conf.gameHeight / love.graphics.getHeight()

    for _, btn in ipairs(buttons) do
        if love.mouse.isDown(1) then
            btn:pressed(x, y)
        else
            btn:hover(x, y)
        end
    end

    return beamer:update(dt)
end

M.keypressed = function(key)
    if key == "p" then
        configs.controls.single_player = not configs.controls.single_player
        if configs.controls.single_player then
            configs.controls.move_left_key = "left"
            configs.controls.move_right_key = "right"
            configs.controls.grow_key = "up"
            configs.controls.shrink_key = "down"
        else
            configs.controls.move_left_key = "lshift"
            configs.controls.move_right_key = "space"
            configs.controls.grow_key = "return"
            configs.controls.shrink_key = "down"
        end
    end
end

return M
