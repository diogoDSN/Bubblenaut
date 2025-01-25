local sounds = require("lua.screens.game_over_screen.sounds")
local animations = require("lua.commons.animations")
local router = require("lua.commons.router")

local M = {}

local game_over_sound = {
    countdown = 0.2,
    played = false,
    track = math.random() < 0.5 and sounds.game_over or sounds.game_over_deep,
}

local beamer = router.new_beamer(
    "game_screen",
    0.2
)

local pop_animation = animations.new_animation(
    love.graphics.newImage("archive/bubble_pop.png"),
    128,
    128,
    200,
    200,
    0.2,
    false,
    false,
    sounds.pop_cut
)

M.load = function()
    print("Menu screen loaded")
end


M.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Game Over :(", 0, love.graphics.getHeight() / 8, love.graphics.getWidth(), "center")
    love.graphics.printf("Press SPACE to try again", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")


    pop_animation:draw()
end


M.update = function(dt)
    if love.keyboard.isDown("space") then
        beamer:activate()
        pop_animation:start()
    end

    local next_screen = beamer:update(dt)
    if next_screen ~= nil then
        return next_screen
    end

    game_over_sound.countdown = game_over_sound.countdown - dt
    if game_over_sound.countdown < 0 and not game_over_sound.track:isPlaying() and not game_over_sound.played then
        love.audio.play(game_over_sound.track)
        game_over_sound.played = true
    end

    pop_animation:update(dt)

    return nil
end

return M
