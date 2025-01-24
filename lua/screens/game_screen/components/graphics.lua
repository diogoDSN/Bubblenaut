local M = {}

M.bubble_outer_line_width = function(bubble)
    return 2 * (bubble.outer_radius - bubble.inner_radius)
end

return M
