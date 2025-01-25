local movement = require("lua.screens.game_screen.components.movement.movement")
local objects = require("lua.screens.game_screen.components.objects")
local graphics = require("lua.screens.game_screen.components.graphics")
local background = require("lua.screens.game_screen.components.background")
require("lua.audio.mic")
local conf = require "conf"
local configs = require("lua.screens.game_screen.config")

local M = {}

-- runs once when opening the game screen
M.load = function()
    objects.setupGame()
    Init_time = love.timer.getTime()
    Mic, LastSecondData = Initialize_audio_input()
    background.setup_background()
end

-- function to run when love updates the game state, runs before drawing
M.update = function(dt)
    movement.handle_movement(dt)
    -- Processes audio every second and resets timer
    if math.floor(math.fmod(love.timer.getTime() - Init_time, 10)) == 1 then
        objects.bubble.shrink(objects.bubble)
        local amp = Process_audio(Mic, LastSecondData)
        Init_time = love.timer.getTime()
        objects.bubble.growExpFactor(objects.bubble, amp)
    end
    background.update_background()

    objects.update_bubble_animation(dt)

    local game_state = movement.game_state
    if game_state.running then
        return nil
    else
        return "game_over"
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
