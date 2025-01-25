local M = {}

M.swoosh = love.audio.newSource("archive/sounds/swosh.wav", "static")
M.swoosh_deep = love.audio.newSource("archive/sounds/swosh_deep.wav", "static")

M.inhale = love.audio.newSource("archive/sounds/inhale.wav", "static")
M.inflating = love.audio.newSource("archive/sounds/inflating.wav", "static")

M.exhale = love.audio.newSource("archive/sounds/exhale.wav", "static")
M.deflating = love.audio.newSource("archive/sounds/deflating.wav", "static")

return M
