local configs = require("lua.screens.game_screen.config")
local objects = require("lua.screens.game_screen.components.objects")
local utils = require("lua.screens.game_screen.components.movement.utils")
local background = require("lua.screens.game_screen.components.background")

local M = {}

M.bubble_movement = {
    sideways_movement_locked = false,
    positions = {},
}

M.on_move_left_key_press = function()
    if not objects.bubble.sideways_movement_locked then
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
            objects.bubble.sideways_movement_locked = true
        end
    end
end

M.on_move_right_key_press = function()
    if not objects.bubble.sideways_movement_locked then
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
            objects.bubble.sideways_movement_locked = true
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
        objects.bubble.sideways_movement_locked = false
    end

    if utils.is_growth() then
        local new_bubble_boundary_circle = utils.expanded_bubble_boundary_circle(objects.bubble)
        if utils.circle_inside_screen(new_bubble_boundary_circle) then
            objects.bubble:grow()
        end
    end

    if utils.is_shrink() then
        local new_bubble_boundary_circle = utils.shrunken_bubble_boundary_circle(objects.bubble)
        if utils.circle_inside_screen(new_bubble_boundary_circle) then
            objects.bubble:shrink()
        end
    end

    local scroll_speed = objects.bubble.radius * configs.steps.scroll_ratio
    background.set_speed(objects.bubble.radius * 0.2)

    for _, spike in ipairs(objects.obstacles) do
        spike[2] = spike[2] + scroll_speed * dt
    end

    objects.finish_line = objects.finish_line + scroll_speed * dt
    if (objects.finish_line >= objects.bubble.center_y) then
        objects.game_state = "win_screen"
    end
end

return M
