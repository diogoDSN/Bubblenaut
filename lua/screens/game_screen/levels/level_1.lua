local M = {}

M.load_level = function(spike_radius)
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
        { 5,  -26 },
        { 9,  -26 },
        { 3, -28 },
        { 11, -28},
        {1, -30},
        {13, -30},
        {3, -37},
        {11, -37},
        {7, -42},
        {3, -47},
        {11, -47}
    }

    for _, spike in ipairs(M.obstacles) do
        spike[1] = spike[1] * spike_radius
        spike[2] = spike[2] * spike_radius
    end

    M.finish_line = -55 * spike_radius
end

M.next_level = "level_2"



return M
