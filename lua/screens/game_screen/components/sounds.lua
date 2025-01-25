local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")

local M = {}

local swoosh = love.audio.newSource("archive/sounds/swosh.wav", "static")
local swoosh_deep = love.audio.newSource("archive/sounds/swosh_deep.wav", "static")

local inhale = love.audio.newSource("archive/sounds/inhale.wav", "static")
local inflating = love.audio.newSource("archive/sounds/inflating_cut.wav", "static")

local exhale = love.audio.newSource("archive/sounds/exhale.wav", "static")
local deflating = love.audio.newSource("archive/sounds/deflating_cut.wav", "static")




local inflation_percent = function(current_radius)
    return (current_radius - configs.sizes.min_radius) / (configs.sizes.max_radius - configs.sizes.min_radius)
end



M.update = function()
    if love.keyboard.isDown(configs.controls.grow_key) then
        if not inflating:isPlaying() and objects.bubble.radius < configs.sizes.max_radius then
            inflating:seek(
                inflating:getDuration("seconds") * inflation_percent(objects.bubble.radius),
                "seconds"
            )
            love.audio.play(inflating)
        end
    else
        if inflating:isPlaying() then
            love.audio.pause(inflating)
        end
    end

    if love.keyboard.isDown(configs.controls.shrink_key) and objects.bubble.radius > configs.sizes.min_radius then
        if not deflating:isPlaying() then
            deflating:seek(
                deflating:getDuration("seconds") * inflation_percent(objects.bubble.radius),
                "seconds"
            )
            love.audio.play(deflating)
        end
    else
        if deflating:isPlaying() then
            love.audio.pause(deflating)
        end
    end
end

return M
