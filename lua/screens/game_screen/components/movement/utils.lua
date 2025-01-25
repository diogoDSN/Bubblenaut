local M = {}

M.bubble_boundary_circle = function(bubble)
    return {
        center_x = bubble.center_x,
        center_y = bubble.center_y,
        radius = bubble.outer_radius + bubble:get_outer_line_width() / 2
    }
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


M.grow = function()

end

return M
