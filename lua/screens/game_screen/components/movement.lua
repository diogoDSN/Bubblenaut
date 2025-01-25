local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")
local sounds = require("lua.screens.game_screen.components.sounds")

local M = {}

local left_movement_enabled = true
local right_movement_enabled = true



function love.keypressed(key)
    if key == configs.controls.move_left_key and left_movement_enabled then
        objects.bubble.center_x = objects.bubble.center_x - objects.bubble.step
        left_movement_enabled = false
    end
    if key == configs.controls.move_right_key and right_movement_enabled then
        objects.bubble.center_x = objects.bubble.center_x + objects.bubble.step
        right_movement_enabled = false
    end
end

function love.keyreleased(key)
    if key == configs.controls.move_left_key then
        left_movement_enabled = true
    end
    if key == configs.controls.move_right_key then
        right_movement_enabled = true
    end
end

local function clamp(v, min, max)
    if v > max then
        return max
    end
    if v < min then
        return min
    end
    return v
end

M.handle_movement = function(dt)
    local expansion_factor = configs.sizes.expansion_factor
    local shrink_factor = configs.sizes.shrink_factor

    local step_increase_factor = configs.steps.step_increase_factor
    local step_reduction_factor = configs.steps.step_reduction_factor

    if love.keyboard.isDown(configs.controls.grow_key) then
        objects.bubble.inner_radius = objects.bubble.inner_radius * expansion_factor
        objects.bubble.outer_radius = objects.bubble.outer_radius * expansion_factor

        objects.bubble.step = objects.bubble.step * step_increase_factor

        if not sounds.inflating:isPlaying() then
            love.audio.play(sounds.inflating)
        end
    else
        if sounds.inflating:isPlaying() then
            love.audio.pause(sounds.inflating)
            sounds.inflating.seek(sounds.inflating, 0, "seconds")
        end
    end

    if love.keyboard.isDown(configs.controls.shrink_key) then
        objects.bubble.inner_radius = objects.bubble.inner_radius * shrink_factor
        objects.bubble.outer_radius = objects.bubble.outer_radius * shrink_factor

        objects.bubble.step = objects.bubble.step * step_reduction_factor

        if not sounds.deflating:isPlaying() then
            love.audio.play(sounds.deflating)
        end
    else
        if sounds.deflating:isPlaying() then
            love.audio.pause(sounds.deflating)
            sounds.inflating.seek(sounds.deflating, 0, "seconds")
        end
    end

    objects.bubble.inner_radius = clamp(
        objects.bubble.inner_radius,
        configs.sizes.min_inner_radius,
        configs.sizes.max_inner_radius
    )

    objects.bubble.outer_radius = clamp(
        objects.bubble.outer_radius,
        configs.sizes.min_outer_radius,
        configs.sizes.max_outer_radius
    )

    objects.bubble.step = clamp(
        objects.bubble.step,
        configs.steps.min_step,
        configs.steps.max_step
    )
end

return M
