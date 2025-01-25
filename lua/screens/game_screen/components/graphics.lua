local M = {}

M.bubble_outer_line_width = function(bubble)
    return 2 * (bubble.outer_radius - bubble.inner_radius)
end

M.spike_outer_line_width = function(spike)
    return 2 * (spike.outer_radius - spike.inner_radius)
end

M.spike_fill_color = function(spike)
    return spike.fill_color
end

M.spike_line_color = function(spike)
    return spike.line_color
end

return M
