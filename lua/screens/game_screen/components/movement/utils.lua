local configs = require("lua.screens.game_screen.config")

local M = {}

M.expanded_bubble_boundary_circle = function(bubble)
    local expansion_factor = configs.sizes.expansion_factor

    local new_inner_radius = bubble.inner_radius * expansion_factor
    local new_outer_radius = bubble.outer_radius * expansion_factor
    return {
        center_x = bubble.center_x,
        center_y = bubble.center_y,
        radius = 2 * new_outer_radius - new_inner_radius
    }
end

M.shrunken_bubble_boundary_circle = function(bubble)
    local shrink_factor = configs.sizes.shrink_factor

    local new_inner_radius = bubble.inner_radius * shrink_factor
    local new_outer_radius = bubble.outer_radius * shrink_factor
    return {
        center_x = bubble.center_x,
        center_y = bubble.center_y,
        radius = 2 * new_outer_radius - new_inner_radius
    }
end

M.bubble_can_move = function(bubble, position)
    -- position is a table with properties x and y (represents the new center)
    local final_circle = {
        center_x = position.x,
        center_y = position.y,
        radius = bubble.outer_radius + bubble.get_outer_line_width() / 2
    }
    return M.circle_inside_screen(final_circle)
end


M.circle_inside_screen = function(circle)
    -- here circle needs to have the properties center_x, center_y and radius
    local circle_max_x = circle.center_x + circle.radius
    local circle_min_x = circle.center_x - circle.radius
    local circle_max_y = circle.center_y + circle.radius
    local circle_min_y = circle.center_y - circle.radius

    local max_x = love.graphics.getWidth()
    local min_x = 0
    local max_y = love.graphics.getHeight()
    local min_y = 0

    if circle_max_x <= max_x and circle_min_x >= min_x and circle_max_y <= max_y and circle_min_y >= min_y then
        return true
    end
    return false
end



M.clamp = function(v, min, max)
    if v > max then
        return max
    end
    if v < min then
        return min
    end
    return v
end

return M
