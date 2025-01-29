local router = require("lua.commons.router")
local conf = require("conf")
local button = require("lua.widgets.button")

local M = {}
local buttons = {}

local beamer
local button_text

M.load = function(level_name)
    print("Win screen loaded")

	local level = require("lua.screens.game_screen.levels." .. level_name)
	if level.next_level ~= nil then
		beamer = router.new_beamer(
			"game_screen",
			0.2,
			level.next_level
		)

        button_text = "NEXT"
	else
		beamer = router.new_beamer(
			"menu_screen",
			0.2
		)

        button_text = "MENU"
	end

    table.insert(buttons, button.new_button(
        219, 84,
        144, 522, 
        button_text,
        {r = 1, g = 1, b = 1},      --button is blue by default 
        {r = 0.2, g = 0.2, b = 0.4},
        function()
            if conf.debug then
                print("Menu button clicked")
            end
            beamer:activate()
        end
    ))

    M.background = love.graphics.newImage("archive/win-background.png")
end

M.draw = function()
    love.graphics.draw(M.background, 0, 0)
    for _, btn in ipairs(buttons) do
        btn:draw()
    end
    if conf.debug then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.print("Win screen", 10, 10)
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

return M
