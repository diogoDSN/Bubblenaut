local sounds = require("lua.screens.game_over_screen.sounds")

local M = {}


---@param sound_track love.Source # sound source to play with the animation (beware: sound_track pitch will be adapted based on desired duration)
local new_animation = function(
    sprite_sheet,
    width,
    height,
    x,
    y,
    duration,
    pre_start,
    repeatable,
    sound_track
)
    local animation = {}
    animation.sprite_sheet = sprite_sheet;
    animation.quads = {};
    animation.quad_n = 0;

    for y = 0, sprite_sheet:getHeight() - height, height do
        for x = 0, sprite_sheet:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, sprite_sheet:getDimensions()))
            animation.quad_n = animation.quad_n + 1;
        end
    end

    animation.duration = duration or 1
    animation.current_time = 0
    animation.played = false
    animation.started = pre_start
    animation.repeatable = repeatable

    local sound_duration = sound_track:getDuration("seconds")
    sound_track:setPitch(sound_duration / duration)
    animation.sound_track = sound_track

    function animation.draw(self)
        local sprite_n = math.floor(self.current_time / self.duration * 3) + 1

        if sprite_n > self.quad_n then
            sprite_n = self.quad_n
        end

        love.graphics.draw(self.sprite_sheet, self.quads[sprite_n], x, y, 0, 1)
    end

    function animation.update(self, dt)
        if not self.started then
            return
        end
        self.current_time = self.current_time + dt
        if self.current_time >= self.duration and self.repeatable then
            self.current_time = self.current_time - self.duration
        end

        if not self.sound_track:isPlaying() and not self.played then
            love.audio.play(self.sound_track)
            self.played = true
        end
    end

    function animation.start(self)
        self.started = true
    end

    return animation
end

local game_over_sound = {
    countdown = 0.2,
    played = false,
    track = math.random() < 0.5 and sounds.game_over or sounds.game_over_deep,
}

local beamer = {
    duration = 0.2,
    activated = false,
    destination = "game_screen"
}

local pop_animation = new_animation(
    love.graphics.newImage("archive/bubble_pop.png"),
    128,
    128,
    200,
    200,
    0.2,
    false,
    false,
    sounds.pop_cut
)

M.load = function()
    print("Menu screen loaded")
end


M.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Game Over :(", 0, love.graphics.getHeight() / 8, love.graphics.getWidth(), "center")
    love.graphics.printf("Press SPACE to try again", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")


    pop_animation:draw()
end


M.update = function(dt)
    if love.keyboard.isDown("space") then
        beamer.destination = "game_screen"
        beamer.activated = true
        pop_animation:start()
    end

    if beamer.activated then
        beamer.duration = beamer.duration - dt
    end

    if beamer.duration <= 0 then
        return beamer.destination
    end

    game_over_sound.countdown = game_over_sound.countdown - dt
    if game_over_sound.countdown < 0 and not game_over_sound.track:isPlaying() and not game_over_sound.played then
        love.audio.play(game_over_sound.track)
        game_over_sound.played = true
    end

    pop_animation:update(dt)

    return nil
end

return M
