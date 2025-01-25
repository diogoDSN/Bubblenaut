local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")
local sounds = require("lua.screens.game_screen.components.sounds")
local utils = require("lua.screens.game_screen.components.movement.utils")

local M = {}

M.game_state = {
    running = true,
}

M.bubble_movement = {
    sideways_movement_locked = false,
    positions = {},
}

local scroll_speed = 100 -- pixels per second

function love.keypressed(key)
    if key == configs.controls.move_left_key then
        if not M.bubble_movement.sideways_movement_locked then
            local animation_step = configs.steps.animation_step
            local starting_position = objects.bubble.center_x
            local final_position = objects.bubble.center_x - objects.bubble.step
            for i = 1, animation_step do
                local new_x = starting_position + (i / animation_step) * (final_position - starting_position)
                local can_move_left = utils.bubble_can_move(objects.bubble, { x = new_x, y = objects.bubble.center_y })

                if can_move_left then
                    table.insert(M.bubble_movement.positions, {
                        x = starting_position + (i / animation_step) * (final_position - starting_position),
                        y = objects.bubble.center_y,
                    })
                end
            end

            if #M.bubble_movement.positions > 0 then
                M.bubble_movement.sideways_movement_locked = true
            end
        end
    end

    if key == configs.controls.move_right_key then
        if not M.bubble_movement.sideways_movement_locked then
            local animation_step = configs.steps.animation_step
            local starting_position = objects.bubble.center_x
            local final_position = objects.bubble.center_x + objects.bubble.step
            for i = 1, animation_step do
                local new_x = starting_position + (i / animation_step) * (final_position - starting_position)
                local can_move = utils.bubble_can_move(objects.bubble, { x = new_x, y = objects.bubble.center_y })

                if can_move then
                    table.insert(M.bubble_movement.positions, {
                        x = new_x,
                        y = objects.bubble.center_y,
                    })
                end
            end

            if #M.bubble_movement.positions > 0 then
                M.bubble_movement.sideways_movement_locked = true
            end
        end
    end
end

M.handle_movement = function(dt)
    if #M.bubble_movement.positions > 0 then
        local next_position = M.bubble_movement.positions[1]
        objects.bubble:move(next_position)
        table.remove(M.bubble_movement.positions, 1)
    end

    if #M.bubble_movement.positions == 0 then
        M.bubble_movement.sideways_movement_locked = false
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
