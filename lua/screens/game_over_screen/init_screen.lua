local sounds = require("lua.screens.game_over_screen.sounds")

local M = {}

local start_sound_countdown
local game_over_sound
local game_sound_played

M.load = function()
    print("Menu screen loaded")
    start_sound_countdown = 0.2 -- seconds
    game_sound_played = false
    math.randomseed(os.time())
    if math.random() < 0.5 then
        game_over_sound = sounds.game_over
    else
        game_over_sound = sounds.game_over_deep
    end
end

M.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Game Over :(", 0, love.graphics.getHeight() / 8, love.graphics.getWidth(), "center")
    love.graphics.printf("Press SPACE to try again", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end


M.update = function(dt)
    if love.keyboard.isDown("space") then
        return "game_screen"
    end

    start_sound_countdown = start_sound_countdown - dt
    if start_sound_countdown < 0 and not game_over_sound:isPlaying() and not game_sound_played then
        love.audio.play(game_over_sound)
        game_sound_played = true
    end

    return nil
end

return M
