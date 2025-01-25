local M = {}

M.game_over = love.audio.newSource("archive/sounds/game_over_1.wav", "static")
M.game_over_deep = love.audio.newSource("archive/sounds/game_over_deep.wav", "static")
M.pop_cut = love.audio.newSource("archive/sounds/pop_cut.wav", "static")

return M
