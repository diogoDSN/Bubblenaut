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

function M.bubble.growExpFactor(self, expansion_factor)
    local step_increase_factor = configs.steps.step_increase_factor

    local new_radius = self.radius * expansion_factor

    self.radius = new_radius

    self.step = self.step * step_increase_factor
end

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

local bubble_y_offset = conf.gameHeight / 5

M.setupGame = function()
    M.bubble.sprite = love.graphics.newImage("archive/bubble_sprites.png")
    M.spike_sprite = love.graphics.newImage("archive/spike.png")

    M.spike_radius = conf.gameWidth / 14
    M.spike_scale_factor = 2 * M.spike_radius / M.spike_sprite:getWidth()
    M.spike_pivot_x = M.spike_sprite:getWidth() / 2
    M.spike_pivot_y = M.spike_sprite:getHeight() / 2

    M.finish_line_sprite = love.graphics.newImage("archive/fence.png")


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
        -- {x, y} coordinates relative to the whole level
        { 1 * M.spike_radius,  -M.spike_radius },
        { 13 * M.spike_radius, -5 * M.spike_radius },
        { 7 * M.spike_radius,  -10 * M.spike_radius }
    }

    M.finish_line = -20 * M.spike_radius
    M.game_state = ""
end

return M
