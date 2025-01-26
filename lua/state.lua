local M = {}

M.screens = {
	menu_screen = require("lua.screens.menu_screen.init_screen"),
	game_screen = require("lua.screens.game_screen.init_screen"),
	game_over_screen = require("lua.screens.game_over_screen.init_screen"),
	win_screen = require("lua.screens.win_screen.init_screen")
}

M.current_screen = M.screens.menu_screen

local NilScreen = {
	load = function()
		print "The NilScreen has no load function."
	end,
	draw = function()
		print "The NilScreen has no draw function."
	end,
	update = function(dt)
		print "The NilScreen has no update function."
	end,
}

M.setScreen = function(screenName)
	print(screenName)
	local newScreen = M.screens[screenName]
	if newScreen == nil then
		newScreen = NilScreen
	end
	M.current_screen = newScreen
end

M.current_level = "level_1"

M.setCurrentLevel = function(level_name)
	M.current_level = level_name
end

M.getCurrentLevel = function()
	return M.current_level
end

return M
