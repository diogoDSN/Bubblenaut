local sounds = require("lua.commons.sound_sources")
local animations = require("lua.commons.animations")
local router = require("lua.commons.router")
local conf = require("conf")
local button = require("lua.widgets.button")

local beamer

local M = {}

local buttons = {}

local screen_name = "Game Over"

local game_over_sound
local pop_animation

M.load = function()
    if conf.debug then
        print(screen_name .. " Screen loaded")
    end

    M.background = love.graphics.newImage("archive/game-over-background.png")

    beamer = router.new_beamer(
        "game_screen",
        0.3
    )

    game_over_sound = {
        countdown = 0.2,
        played = false,
        track = math.random() < 0.5 and sounds.game_over or sounds.game_over_deep,
    }

    pop_animation = animations.new_animation(
        love.graphics.newImage("archive/bubble_pop.png"),
        128, 128, -- sprite size
        200, 200, -- position
        1, 1,     -- pivot
        0.2,      -- duration
        false,    -- started
        false,    -- repeatable
        sounds.pop_cut
    )
end

table.insert(buttons, button.new_button(
    219, 84,
    144, 413, 
    "PLAY",
    {r = 1, g = 1, b = 1},      --button is blue by default 
    {r = 0.2, g = 0.2, b = 0.4},
    function()
        if conf.debug then
            print("Start button clicked")
        end
        beamer:activate()
        pop_animation:start()
    end
))

table.insert(buttons, button.new_button(
    219, 84,
    144, 517, 
    "MENU",
    {r = 1, g = 1, b = 1},      --button is blue by default 
    {r = 0.2, g = 0.2, b = 0.4},
    function()
        if conf.debug then
            print("Quit button clicked")
        end
        beamer:activate("menu_screen")
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
        love.graphics.print(screen_name, 10, 10)
    end
end


M.update = function(dt)
    if conf.debug then
        local x, y = love.mouse.getPosition()
        x = x * conf.gameWidth / love.graphics.getWidth()
        y = y * conf.gameHeight / love.graphics.getHeight()
        print(x, y)
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

    if love.keyboard.isDown("space") then
        beamer:activate()
        pop_animation:start()
    end

    if love.keyboard.isDown("m") then
        beamer:activate("menu_screen")
    end

    if love.keyboard.isDown("escape") or love.keyboard.isDown("q") then
        love.event.quit()
    end


    game_over_sound.countdown = game_over_sound.countdown - dt
    if game_over_sound.countdown < 0 and not game_over_sound.track:isPlaying() and not game_over_sound.played then
        love.audio.play(game_over_sound.track)
        game_over_sound.played = true
    end

    pop_animation:update(dt)

    return beamer:update(dt)
end

return M
