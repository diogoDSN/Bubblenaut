local game_screen = require("lua.screens.game_screen")
local M = {}

local noScreen = {
	load = function ()
		print "This screen has no load function."
	end,
	draw = function ()
		print "This screen has no draw function."
	end,
	-- Update functions should return a new screen in case we change screen
	update = function (dt)
		print "This screen has no update function."
		return nil
	end
}

M.screen = game_screen
return M
