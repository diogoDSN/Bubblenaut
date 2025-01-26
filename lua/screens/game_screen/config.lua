local conf = require("conf")

local M = {}

M.controls = {
    single_player = false,
    move_left_key = "lshift",
    move_right_key = "space",
    grow_key = "return",
    shrink_key = "down",
}

M.steps = {
    bubble_step = 30,
    step_increase_factor = 1.075,
    max_step = 200,
    min_step = 5,
    animation_step = 10,
    scroll_ratio = 1.2, -- scroll distance per second compared to bubble size
}
M.steps.step_reduction_factor = 1 / M.steps.step_increase_factor

M.sizes = {
    initial_radius = 50,
    expansion_factor = 1.05,
    max_radius = 100,
    min_radius = 10,
    collision_forgiveness_ratio = 0.9, -- smaller is easier
}

M.sizes.shrink_factor = 1 / M.sizes.expansion_factor

M.little_girl = {
    h_speed_ratio = 75,
    v_speed_ratio = 25,
    v_speed_threshold = conf.gameWidth / 14,
}


return M
