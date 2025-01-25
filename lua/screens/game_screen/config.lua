local M = {}

M.controls = {
    move_left_key = "left",
    move_right_key = "right",
    grow_key = "up",
    shrink_key = "down",
}

M.steps = {
    bubble_step = 50,
    step_increase_factor = 1.05,
    step_reduction_factor = 0.95,
    max_step = 200,
    min_step = 10,
    animation_step = 10,
    scroll_ratio = 1.5, -- scroll distance per second compared to bubble size
}

M.sizes = {
    initial_radius = 52,
    expansion_factor = 1.05,
    max_radius = 100,
    min_radius = 10,
}

M.sizes.shrink_factor = 1 / M.sizes.expansion_factor

M.little_girl = {
    h_speed_ratio = 200,
    v_speed_ratio = 20,
    v_speed_threshold = 50
}

return M
