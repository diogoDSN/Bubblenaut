local movement = require("lua.screens.game_screen.components.movement.movement")
local objects = require("lua.screens.game_screen.components.objects")
local colisions = require("lua.screens.game_screen.components.colisions")
local graphics = require("lua.screens.game_screen.components.graphics")
local background = require("lua.screens.game_screen.components.background")
local mic = require("lua.audio.mic")
local sounds = require("lua.screens.game_screen.components.sounds")
local conf = require "conf"
local configs = require("lua.screens.game_screen.config")

local M = {}

-- runs once when opening the game screen
M.load = function()
    objects.setupGame()
    Init_time = love.timer.getTime()
    Mic, LastSecondData = mic.Initialize_audio_input()
    print("Game screen loaded")

    background.setup_background()
end

-- function to run when love updates the game state, runs before drawing
M.update = function(dt)
    movement.handle_movement(dt)
    -- Processes audio every second and resets timer
    if math.floor(math.fmod(love.timer.getTime() - Init_time, 10)) == 1 then
        objects.bubble.shrink(objects.bubble)
        local amp = mic.Process_audio(Mic, LastSecondData)
        Init_time = love.timer.getTime()
        objects.bubble.growExpFactor(objects.bubble, amp)
    end
    background.update_background()
    sounds.update()

    objects.update_bubble_animation(dt)

    if colisions.applyColisions() then
        objects.game_state = "game_over_screen"
    end

    if objects.game_state == "" then
        return nil
    else
        return objects.game_state
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
