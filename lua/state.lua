local M = {}

M.bubble = {
    center_x = 1200,
    center_y = 800,
    inner_radius = 50,
    outer_radius = 52,
    speed = 250,
}

M.set_bubble_initial_state = function()
    local bubble_initial_x = love.graphics.getWidth() / 2
    local bubble_initial_y = love.graphics.getHeight() / 2
    M.bubble.center_x = bubble_initial_x
    M.bubble.center_y = bubble_initial_y
end

return M
