local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")
local background = require("lua.screens.game_screen.components.background")

local M = {}

local left_movement_enabled = true
local right_movement_enabled = true

local left_wall = 0
local right_wall = 1024

local scroll_speed = 100 -- pixels per second

function love.keypressed(key)
    if key == configs.controls.move_left_key and left_movement_enabled and objects.bubble.center_x - objects.bubble.step > left_wall then
        objects.bubble.center_x = objects.bubble.center_x - objects.bubble.step
        left_movement_enabled = false
    end
    if key == configs.controls.move_right_key and right_movement_enabled and objects.bubble.center_x + objects.bubble.step < right_wall then
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

M.handle_movement = function(dt)
    local expansion_factor = configs.sizes.expansion_factor
    local shrink_factor = configs.sizes.shrink_factor

    local step_increase_factor = configs.steps.step_increase_factor
    local step_reduction_factor = configs.steps.step_reduction_factor

    if love.keyboard.isDown(configs.controls.grow_key) then
        objects.bubble.inner_radius = objects.bubble.inner_radius * expansion_factor
        objects.bubble.outer_radius = objects.bubble.outer_radius * expansion_factor

        objects.bubble.step = objects.bubble.step * step_increase_factor
    end
    if love.keyboard.isDown(configs.controls.shrink_key) then
        objects.bubble.inner_radius = objects.bubble.inner_radius * shrink_factor
        objects.bubble.outer_radius = objects.bubble.outer_radius * shrink_factor

        objects.bubble.step = objects.bubble.step * step_reduction_factor
    end

    objects.spike.center_y = objects.spike.center_y + scroll_speed * dt

    background.background.center_y = background.background.center_y + scroll_speed * dt
end

return M
