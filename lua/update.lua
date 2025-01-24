local state = require("lua.state")

local move_left_key = "left"
local move_right_key = "right"
local grow_key = "up"
local shrink_key = "down"

local expansion_factor = 1.1
local shrink_factor = 0.9

local speed_increase_factor = 1.1
local speed_reduction_factor = 0.9

function love.update(dt)
    if love.keyboard.isDown(move_right_key) then
        state.bubble.center_x = state.bubble.center_x + state.bubble.speed * dt
    end
    if love.keyboard.isDown(move_left_key) then
        state.bubble.center_x = state.bubble.center_x - state.bubble.speed * dt
    end
    if love.keyboard.isDown(grow_key) then
        state.bubble.inner_radius = state.bubble.inner_radius * expansion_factor
        state.bubble.outer_radius = state.bubble.outer_radius * expansion_factor

        state.bubble.speed = state.bubble.speed * speed_increase_factor
    end
    if love.keyboard.isDown(shrink_key) then
        state.bubble.inner_radius = state.bubble.inner_radius * shrink_factor
        state.bubble.outer_radius = state.bubble.outer_radius * shrink_factor

        state.bubble.speed = state.bubble.speed * speed_reduction_factor
    end
end
