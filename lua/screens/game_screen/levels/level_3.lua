local M = {}

M.load_level = function(spike_radius)
    M.obstacles = {
        -- {x, y} coordinates in a grid of width 14, obstacles are 2 columns wide
        -- x is a number between 1 and 13, the obstacle will be in columns x and x+1
        -- y is a negative number
        {1, 6},
        {3, 6},
        {5, 6},
        {7, 6},
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
        { 7,  -34 },
        { 5,  -36 },
        { 7,  -36 },
        { 9,  -36 },
        { 7,  -38 },
        { 1,  -46 },
        { 3,  -46 },
        { 5,  -46 },
        { 7,  -46 },
        { 4,  -54 },
        { 7,  -54 },
        { 10, -54 },
        { 13, -54 },
        { 1,  -64 },
        { 5,  -64 },
        { 9,  -64 },
        { 13, -64 },
        { 3,  -68 },
        { 7,  -68 },
        { 11, -68 },
        { 6,  -74 },
        { 12, -77 },
        { 2,  -78 },
        { 9,  -80 },
        { 5,  -82 },
        { 12, -84 },
        { 10, -85 },
        { 3,  -87 },
        { 7,  -88 },
        { 1,  -90 },
        { 12, -90 }
    }

    for _, spike in ipairs(M.obstacles) do
        spike[1] = spike[1] * spike_radius
        spike[2] = spike[2] * spike_radius
    end

    M.finish_line = -95 * spike_radius
end

return M
