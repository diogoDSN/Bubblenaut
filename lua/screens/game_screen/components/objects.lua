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

M.setupGame = function(level_name)
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
    M.bubble.radius = configs.sizes.initial_radius
    M.bubble.step = configs.steps.bubble_step

    local bubble_sprite_height = M.bubble.sprite:getHeight()
    local center_x = bubble_sprite_height / 2
    local center_y = bubble_sprite_height / 2

    M.bubble_animation = animations.new_animation(
        M.bubble.sprite,                            -- sprite
        bubble_sprite_height, bubble_sprite_height, -- sprite size
        M.bubble.center_x, M.bubble.center_y,       -- position
        center_x, center_y,                         -- pivot
        0.5,                                        -- duration
        true,                                       -- started
        true,                                       -- repeatable
        nil                                         -- sound
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

    local level = require("lua.screens.game_screen.levels." .. level_name)
    level.load_level(M.spike_radius)

    M.obstacles = level.obstacles
    M.finish_line = level.finish_line

    M.game_state = ""
end

return M
