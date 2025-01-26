local M = {}

M.load_level = function(spike_radius)
    M.obstacles = {
        -- {x, y} coordinates in a grid of width 14, obstacles are 2 columns wide
        -- x is a number between 1 and 13, the obstacle will be in columns x and x+1
        -- y is a negative number
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
        spike[2] = spike[2] + 34
        spike[1] = spike[1] * spike_radius
        spike[2] = spike[2] * spike_radius
    end

    M.finish_line = (-95 + 34) * spike_radius
end

M.next_level = nil



return M
