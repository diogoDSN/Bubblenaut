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
}

M.sizes = {
    initial_radius = 52,
    expansion_factor = 1.05,
    shrink_factor = 0.95,
    max_radius = 100,
    min_radius = 10,
}

return M
