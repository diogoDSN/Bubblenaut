local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")
local background = require("lua.screens.game_screen.components.background")
local graphics = require("lua.screens.game_screen.components.graphics")

local M = {}

local left_movement_enabled = true
local right_movement_enabled = true

local positions_list = {}

local scroll_speed = 100 -- pixels per second

function love.keypressed(key)
    local left_wall = 0
    local right_wall = love.graphics.getWidth()

    local starting_position = objects.bubble.center_x
    local animation_step = configs.steps.animation_step
    if key == configs.controls.move_left_key and left_movement_enabled then
        local final_position = objects.bubble.center_x - objects.bubble.step
        for i = 1, animation_step do
            local new_x = starting_position + (i / animation_step) * (final_position - starting_position)
            local can_move_left = new_x - objects.bubble.outer_radius -
                graphics.bubble_outer_line_width(objects.bubble) / 2 >= left_wall

            if can_move_left then
                table.insert(positions_list, {
                    x = starting_position + (i / animation_step) * (final_position - starting_position),
                    y = objects.bubble.center_y,
                })
            end
        end
        left_movement_enabled = false
    end

    if key == configs.controls.move_right_key and right_movement_enabled then
        local final_position = objects.bubble.center_x + objects.bubble.step
        for i = 1, animation_step do
            local new_x = starting_position + (i / animation_step) * (final_position - starting_position)
            local can_move_right = new_x + objects.bubble.outer_radius +
                graphics.bubble_outer_line_width(objects.bubble) / 2 <= right_wall

            if can_move_right then
                table.insert(positions_list, {
                    x = starting_position + (i / animation_step) * (final_position - starting_position),
                    y = objects.bubble.center_y,
                })
            end
        end
        right_movement_enabled = false
    end
end

M.handle_movement = function(dt)
    local expansion_factor = configs.sizes.expansion_factor
    local shrink_factor = configs.sizes.shrink_factor

    local step_increase_factor = configs.steps.step_increase_factor
    local step_reduction_factor = configs.steps.step_reduction_factor

    if #positions_list > 0 then
        local next_position = positions_list[1]
        objects.bubble.center_x = next_position.x
        objects.bubble.center_y = next_position.y
        table.remove(positions_list, 1)
    else
        left_movement_enabled = true
        right_movement_enabled = true
    end

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
