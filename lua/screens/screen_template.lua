local M = {}

M.load = function()
    print "This screen has no load function."
end

M.draw = function()
    print "This screen has no draw function."
end

-- Update functions should return a new screen in case we change screen
M.update = function(dt)
    print "This screen has no update function."
    return nil
end

return M
