local movement = require("lua.screens.game_screen.components.movement.movement")
local objects = require("lua.screens.game_screen.components.objects")
local colisions = require("lua.screens.game_screen.components.colisions")
local background = require("lua.screens.game_screen.components.background")
local sounds = require("lua.screens.game_screen.components.sounds")
local conf = require "conf"
local configs = require("lua.screens.game_screen.config")
local router = require("lua.commons.router")

local M = {}

-- runs once when opening the game screen
M.load = function()
    print("Game screen loaded")

    objects.setupGame()
    background.setup_background()

    M.beamer = router.new_beamer(
        "game_over_screen",
        0.3
    )
end

-- function to run when love updates the game state, runs before drawing
M.update = function(dt)
    movement.handle_movement(dt)
    background.update_background()
    sounds.update()

    objects.update_bubble_animation(dt)

    if colisions.applyColisions() then
        objects.game_state = "game_over_screen"
        objects.pop_animation:start()
        objects.pop_animation:update(dt)
    end

    if objects.game_state ~= "" then
        M.beamer:activate(objects.game_state)
    end

    local next_screen = M.beamer:update(dt)
    if next_screen ~= nil then
        return next_screen
    end
end

-- function to run when love draws the game screen
M.draw = function()
    local width = conf.gameWidth
    local height = conf.gameHeight

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    -- Background
    background.draw_backgroud()

    -- Finish line
    objects.draw_finish_line()

    -- Bubble
    objects.draw_bubble()

    -- Obstacles
    objects.draw_obstacles()
end

M.keypressed = function(key)
    if key == configs.controls.move_left_key then
        movement.on_move_left_key_press()
    end

    if key == configs.controls.move_right_key then
        movement.on_move_right_key_press()
    end
end

return M
