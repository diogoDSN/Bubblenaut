local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")

local M = {}

local swoosh = love.audio.newSource("archive/sounds/swosh_cut.wav", "static")
local swoosh_deep = love.audio.newSource("archive/sounds/swosh_deep.wav", "static")

local inhale = love.audio.newSource("archive/sounds/inhale.wav", "static")
local inflating = love.audio.newSource("archive/sounds/inflating_cut.wav", "static")

local exhale = love.audio.newSource("archive/sounds/exhale.wav", "static")
local deflating = love.audio.newSource("archive/sounds/deflating_cut.wav", "static")

local RANDOM_NOISE_CHANCE = 0.3


local inflation_percent = function(current_radius)
    return (current_radius - configs.sizes.min_radius) / (configs.sizes.max_radius - configs.sizes.min_radius)
end



M.update = function()
    local grow = love.keyboard.isDown(configs.controls.grow_key)
    local shrink = love.keyboard.isDown(configs.controls.shrink_key)

    if grow and not shrink and objects.bubble.radius < configs.sizes.max_radius then
        if not inflating:isPlaying() and not inhale:isPlaying() then
            inflating:seek(
                inflating:getDuration("seconds") * inflation_percent(objects.bubble.radius),
                "seconds"
            )

            if math.random() <= RANDOM_NOISE_CHANCE then
                love.audio.play(inhale)
            else
                love.audio.play(inflating)
            end
        end
    else
        if inflating:isPlaying() then
            love.audio.pause(inflating)
        end
        if inhale:isPlaying() then
            love.audio.pause(inhale)
        end
    end

    if shrink and not grow and objects.bubble.radius > configs.sizes.min_radius then
        if not deflating:isPlaying() and not exhale:isPlaying() then
            deflating:seek(
                deflating:getDuration("seconds") * inflation_percent(objects.bubble.radius),
                "seconds"
            )

            if math.random() <= RANDOM_NOISE_CHANCE then
                love.audio.play(exhale)
            else
                love.audio.play(deflating)
            end
        end
    else
        if deflating:isPlaying() then
            love.audio.pause(deflating)
        end
        if exhale:isPlaying() then
            love.audio.pause(exhale)
        end
    end

    if objects.bubble.sideways_movement_locked and not swoosh:isPlaying() then
        if math.random() <= RANDOM_NOISE_CHANCE then
            love.audio.play(swoosh_deep)
        else
            love.audio.play(swoosh)
        end
    end
end

return M
