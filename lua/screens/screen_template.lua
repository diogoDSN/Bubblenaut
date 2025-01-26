local M = {}
local conf = require("conf")

M.load = function()
    if conf.debug then
        print "This screen has no load function."
    end
end

M.draw = function()
    if conf.debug then
        print "This screen has no draw function."
    end
end

-- Update functions should return a new screen in case we change screen
M.update = function(dt)
    if conf.debug then
        print "This screen has no update function."
    end
    return nil
end

return M
