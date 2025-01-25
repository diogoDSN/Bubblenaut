local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")
local sounds = require("lua.screens.game_screen.components.sounds")
local graphics = require("lua.screens.game_screen.components.graphics")
local utils = require("lua.screens.game_screen.components.movement.utils")

local M = {}

M.game_state = {
    running = true,
}

local left_movement_enabled = true
local right_movement_enabled = true

local positions_list = {}

local scroll_speed = 100 -- pixels per second

local debug_prints = false

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
    if debug_prints then
        print(1 / dt, "fps")
    end


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
        local new_bubble_boundary_circle = utils.expanded_bubble_boundary_circle(objects.bubble)
        if utils.circle_inside_screen(new_bubble_boundary_circle) then
            objects.bubble:grow()
        end

        if not sounds.inflating:isPlaying() then
            love.audio.play(sounds.inflating)
        end
    else
        if sounds.inflating:isPlaying() then
            love.audio.pause(sounds.inflating)
            sounds.inflating:seek(0, "seconds")
        end
    end

    if love.keyboard.isDown(configs.controls.shrink_key) then
        local new_bubble_boundary_circle = utils.shrunken_bubble_boundary_circle(objects.bubble)
        if utils.circle_inside_screen(new_bubble_boundary_circle) then
            objects.bubble:shrink()
        end

        if not sounds.deflating:isPlaying() then
            love.audio.play(sounds.deflating)
        end
    else
        if sounds.deflating:isPlaying() then
            love.audio.pause(sounds.deflating)
            sounds.inflating:seek(0, "seconds")
        end
    end

    objects.bubble.inner_radius = utils.clamp(
        objects.bubble.inner_radius,
        configs.sizes.min_inner_radius,
        configs.sizes.max_inner_radius
    )

    objects.bubble.outer_radius = utils.clamp(
        objects.bubble.outer_radius,
        configs.sizes.min_outer_radius,
        configs.sizes.max_outer_radius
    )

    objects.bubble.step = utils.clamp(
        objects.bubble.step,
        configs.steps.min_step,
        configs.steps.max_step
    )

    objects.spike.center_y = objects.spike.center_y + scroll_speed * dt
end

return M
