local sounds = require("lua.commons.sound_sources")
local animations = require("lua.commons.animations")
local router = require("lua.commons.router")
local conf = require("conf")

local M = {}

local game_over_sound
local beamer
local pop_animation

M.load = function()
    print("Game over screen loaded")

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
        128,
        128,
        200,
        200,
        0.2,
        1,
        1,
        false,
        false,
        sounds.pop_cut
    )
end


M.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Game Over :(", 0, conf.gameHeight / 8, conf.gameWidth, "center")
    love.graphics.printf("Press SPACE to try again", 0, conf.gameHeight / 2, conf.gameWidth, "center")


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
