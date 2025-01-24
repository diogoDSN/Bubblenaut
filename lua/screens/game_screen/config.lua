local M = {}

M.controls = {
    move_left_key = "left",
    move_right_key = "right",
    grow_key = "up",
    shrink_key = "down",
}

M.steps = {
    bubble_step = 50,
    step_increase_factor = 1.1,
    step_reduction_factor = 0.9,
}

M.sizes = {
    initial_inner_radius = 50,
    initial_outer_radius = 52,
    expansion_factor = 1.1,
    shrink_factor = 0.9,
}

return M
