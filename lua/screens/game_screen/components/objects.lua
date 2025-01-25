local animations = require("lua.commons.animations")
local configs = require("lua.screens.game_screen.config")
local utils = require("lua.screens.game_screen.components.movement.utils")
local conf = require("conf")
local sound_sources = require("lua.commons.sound_sources")

local M = {}

M.bubble = {
    center_x = 0,
    center_y = 0,
    radius = 0,
    step = 0,
    sideways_movement_locked = false,
}

M.little_girl = {
    pos_y = conf.gameHeight - 10,
    pos_x = conf.gameWidth / 2,
    target_x = conf.gameWidth / 2,
}

function M.bubble.grow(self)
    local expansion_factor = configs.sizes.expansion_factor
    local step_increase_factor = configs.steps.step_increase_factor

    local new_radius = self.radius * expansion_factor

    self.radius = utils.clamp(
        new_radius,
        configs.sizes.min_radius,
        configs.sizes.max_radius
    )

    self.step = utils.clamp(
        self.step * step_increase_factor,
        configs.steps.min_step,
        configs.steps.max_step
    )
end

function M.bubble.shrink(self)
    local shrink_factor = configs.sizes.shrink_factor
    local step_reduction_factor = configs.steps.step_reduction_factor

    local new_radius = self.radius * shrink_factor

    self.radius = utils.clamp(
        new_radius,
        configs.sizes.min_radius,
        configs.sizes.max_radius
    )

    self.step = utils.clamp(
        self.step * step_reduction_factor,
        configs.steps.min_step,
        configs.steps.max_step
    )
end

function M.bubble.move(self, position)
    -- position is a table with properties x and y
    self.center_x = position.x
    self.center_y = position.y
end

M.draw_bubble = function()
    local bubble_sprite_height = M.bubble.sprite:getHeight()
    local scale_factor = (M.bubble.radius / bubble_sprite_height) * 2

    if M.game_state == "game_over_screen" then
        M.pop_animation:draw(
            M.bubble.center_x, M.bubble.center_y, -- position
            scale_factor, scale_factor            -- scaling
        )
    else
        M.bubble_animation:draw(
            M.bubble.center_x, M.bubble.center_y, -- position
            scale_factor, scale_factor            -- scaling
        )
    end
end

M.update_bubble_animation = function(dt)
    M.bubble_animation:update(dt)
end

M.draw_obstacles = function()
    for _, spike in ipairs(M.obstacles) do
        love.graphics.draw(
            M.spike_sprite,                             -- sprite
            spike[1], spike[2],                         -- position
            0,                                          -- rotation
            M.spike_scale_factor, M.spike_scale_factor, -- scaling
            M.spike_pivot_x, M.spike_pivot_y            -- pivot
        )
    end
end

M.draw_finish_line = function()
    love.graphics.draw(
        M.finish_line_sprite,
        0, M.finish_line
    )
end

M.draw_little_girl = function()
    love.graphics.draw(
        M.little_girl_sprite,
        M.little_girl.pos_x,
        M.little_girl.pos_y
    )
end

-- make the little girl hand go after the bubble with certain speeds
M.update_little_girl_state = function(dt)
    M.little_girl.target_x = M.bubble.center_x - M.little_girl.width / 2
    local max_displacement = M.little_girl.target_x - M.little_girl.pos_x

    if dt * configs.little_girl.h_speed_ratio >= math.abs(max_displacement) then
        M.little_girl.pos_x = M.little_girl.pos_x + max_displacement
    elseif max_displacement < 0 then
        M.little_girl.pos_x = M.little_girl.pos_x - dt * configs.little_girl.h_speed_ratio
    elseif max_displacement > 0 then
        M.little_girl.pos_x = M.little_girl.pos_x + dt * configs.little_girl.h_speed_ratio
    end

    -- the objective here would be to make it so that the speed of the hand is inverse
    -- to the radius of the bubble (i.e., such that it seems we're getting faster away from
    -- the hand), and add a threshold in which we assume the speed of the hand is slower than
    -- the bubble (i.e., invert position sum)
    local new_y = M.little_girl.pos_y -
        configs.little_girl.v_speed_ratio *
        dt *
        (configs.little_girl.v_speed_threshold - M.bubble.radius) /
        M.bubble.radius
    if new_y > conf.gameHeight - 10 then
        new_y = conf.gameHeight - 10
    end
    M.little_girl.pos_y = new_y
end

local bubble_y_offset = conf.gameHeight / 5

M.setupGame = function()
    M.bubble.sprite = love.graphics.newImage("archive/bubble_sprites.png")
    M.spike_sprite = love.graphics.newImage("archive/spike.png")

    M.spike_radius = conf.gameWidth / 14
    M.spike_scale_factor = 2 * M.spike_radius / M.spike_sprite:getWidth()
    M.spike_pivot_x = M.spike_sprite:getWidth() / 2
    M.spike_pivot_y = M.spike_sprite:getHeight() / 2

    M.finish_line_sprite = love.graphics.newImage("archive/fence.png")
    M.little_girl_sprite = love.graphics.newImage("archive/girl.png")
    M.little_girl.width = M.little_girl_sprite:getWidth()
    M.little_girl.pos_y = conf.gameHeight - 10
    M.little_girl.pos_x = conf.gameWidth / 2
    M.little_girl.target_x = conf.gameWidth / 2


    M.bubble.center_x = conf.gameWidth / 2
    M.bubble.center_y = conf.gameHeight / 2 + bubble_y_offset
    M.bubble.radius = 52
    M.bubble.step = 50

    local bubble_sprite_height = M.bubble.sprite:getHeight()
    local center_x = bubble_sprite_height / 2
    local center_y = bubble_sprite_height / 2

    M.bubble_animation = animations.new_animation(
        M.bubble.sprite,                      -- sprite
        128, 128,                             -- sprite size
        M.bubble.center_x, M.bubble.center_y, -- position
        center_x, center_y,                   -- pivot
        0.5,                                  -- duration
        true,                                 -- started
        true,                                 -- repeatable
        nil                                   -- sound
    )

    M.pop_animation = animations.new_animation(
        love.graphics.newImage("archive/bubble_pop.png"),
        128, 128,                             -- sprite size
        M.bubble.center_x, M.bubble.center_y, -- position
        center_x, center_y,                   -- pivot
        0.2,                                  -- duration
        false,                                -- started
        false,                                -- repeatable
        sound_sources.pop_cut                 -- sound
    )

    M.obstacles = {
        -- {x, y} coordinates in a grid of width 14, obstacles are 2 columns wide
        -- x is a number between 1 and 13, the obstacle will be in columns x and x+1
        -- y is a negative number
        { 2,  6 },
        { 10, 0 },
        { 12, 0 },
        { 2,  -8 },
        { 4,  -8 },
        { 6,  -8 },
        { 1,  -20 },
        { 13, -20 },
        { 3,  -22 },
        { 11, -22 },
        { 5,  -24 },
        { 9,  -24 },
        { 7,  -34 },
        { 5,  -36 },
        { 7,  -36 },
        { 9,  -36 },
        { 7,  -38 },
        { 1,  -46 },
        { 3,  -46 },
        { 5,  -46 },
        { 7,  -46 },
        { 4,  -54 },
        { 7,  -54 },
        { 10, -54 },
        { 13, -54 },
        { 1,  -64 },
        { 5,  -64 },
        { 9,  -64 },
        { 13, -64 },
        { 3,  -68 },
        { 7,  -68 },
        { 11, -68 },
        { 6,  -74 },
        { 12, -77 },
        { 2,  -78 },
        { 9,  -80 },
        { 5,  -82 },
        { 12, -84 },
        { 10, -85 },
        { 3,  -87 },
        { 7,  -88 },
        { 1,  -90 },
        { 12, -90 }
    }

    for _, spike in ipairs(M.obstacles) do
        spike[1] = spike[1] * M.spike_radius
        spike[2] = spike[2] * M.spike_radius
    end

    M.finish_line = -95 * M.spike_radius
    M.game_state = ""
end

return M
