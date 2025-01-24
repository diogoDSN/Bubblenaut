local M = {}

local move_left_key = "left"
local move_right_key = "right"
local grow_key = "up"
local shrink_key = "down"

local expansion_factor = 1.1
local shrink_factor = 0.9

local speed_increase_factor = 1.1
local speed_reduction_factor = 0.9

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

--M.outer_line_width = function
local bubble_outer_line_width = function(bubble)
    return 2 * (bubble.outer_radius - bubble.inner_radius)
end

M.load = function()
    M.set_bubble_initial_state()
end

M.draw = function()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()


    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(bubble_outer_line_width(M.bubble))
    love.graphics.circle("line", M.bubble.center_x, M.bubble.center_y, M.bubble.outer_radius)
    love.graphics.setColor(0.2, 0.2, 1, 0.5)
    love.graphics.circle("fill", M.bubble.center_x, M.bubble.center_y, M.bubble.inner_radius)
end


M.update = function(dt)
    if love.keyboard.isDown(move_right_key) then
        --M.bubble.center_x = M.bubble.center_x + M.bubble.speed * dt
        M.bubble.center_x = M.bubble.center_x + 10
    end
    if love.keyboard.isDown(move_left_key) then
        M.bubble.center_x = M.bubble.center_x - M.bubble.speed * dt
    end
    if love.keyboard.isDown(grow_key) then
        M.bubble.inner_radius = M.bubble.inner_radius * expansion_factor
        M.bubble.outer_radius = M.bubble.outer_radius * expansion_factor

        M.bubble.speed = M.bubble.speed * speed_increase_factor
    end
    if love.keyboard.isDown(shrink_key) then
        M.bubble.inner_radius = M.bubble.inner_radius * shrink_factor
        M.bubble.outer_radius = M.bubble.outer_radius * shrink_factor

        M.bubble.speed = M.bubble.speed * speed_reduction_factor
    end

    return nil
end

return M
