local configs = require("lua.screens.game_screen.config")
local conf = require("conf")

local M = {}

M.bubble = {
    center_x = 0,
    center_y = 0,
    inner_radius = 0,
    outer_radius = 0,
    step = 0,
}

function M.bubble:get_outer_line_width()
    return 2 * (self.outer_radius - self.inner_radius)
end

function M.bubble.grow(self)
    local expansion_factor = configs.sizes.expansion_factor
    local step_increase_factor = configs.steps.step_increase_factor

    local new_inner_radius = self.inner_radius * expansion_factor
    local new_outer_radius = self.outer_radius * expansion_factor

    self.inner_radius = new_inner_radius
    self.outer_radius = new_outer_radius

    self.step = self.step * step_increase_factor
end

function M.bubble.shrink(self)
    local shrink_factor = configs.sizes.shrink_factor
    local step_reduction_factor = configs.steps.step_reduction_factor

    local new_inner_radius = self.inner_radius * shrink_factor
    local new_outer_radius = self.outer_radius * shrink_factor

    self.inner_radius = new_inner_radius
    self.outer_radius = new_outer_radius

    self.step = self.step * step_reduction_factor
end

function M.bubble.move(self, position)
    -- position is a table with properties x and y
    self.center_x = position.x
    self.center_y = position.y
end

M.draw_bubble = function()
    local bubble_sprite_width = M.bubble.sprite:getWidth()
    local bubble_sprite_height = M.bubble.sprite:getHeight()
    -- Calculate center of the image
    local center_x = bubble_sprite_width / 2
    local center_y = bubble_sprite_height / 2

    local scale_factor = (M.bubble.outer_radius / bubble_sprite_width) * 2

    love.graphics.draw(
        M.bubble.sprite,                -- sprite
        M.bubble.center_x, M.bubble.center_y, -- position
        0,                              -- rotation
        scale_factor, scale_factor,     -- scaling
        center_x, center_y              -- pivot
    )
end

local bubble_y_offset = conf.gameHeight / 3

M.setupGame = function()
    M.bubble.sprite = love.graphics.newImage("archive/bubble.png")

    M.bubble.center_x = conf.gameWidth / 2
    M.bubble.center_y = conf.gameHeight / 2 + bubble_y_offset
    M.bubble.inner_radius = 50
    M.bubble.outer_radius = 52
    M.bubble.step = 50

    M.spike = {
        center_x = 800,
        center_y = 200,
        inner_radius = 50,
        outer_radius = 52,
        step = 50,
        fill_color = { 1, 0, 0, 0.5 },
        line_color = { 1, 0, 0 },
    }
end



M.spike = {
    center_x = 800,
    center_y = 200,
    inner_radius = 50,
    outer_radius = 52,
    step = 50,
    fill_color = { 1, 0, 0, 0.5 },
    line_color = { 1, 0, 0 },
}

return M
