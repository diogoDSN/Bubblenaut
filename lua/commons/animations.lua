local M = {}

---@class animation
local animation = {}

--- Function that should be called at every screen draw
---@overload fun(self: animation, x: number, y:number, scale_x:number, scale_y:number)
function animation:draw() end

--- Function that should be called at every screen update with a valid
--- time delta from the previous rendered frame.
--- @param dt number
function animation:update(dt) end

--- Function that must be called to start the animation if it was not pre_started
function animation:start() end

---@param sprite_sheet love.Image # the sprite sheet with all the frames
---@param width number # the width of a frame
---@param height number # the height of a frame
---@param pos_x number # the X position for drawing
---@param pos_y number # the Y position for drawing
---@param pivot_x number # the X position of the pivot
---@param pivot_y number # the Y position of the pivot
---@param duration number # how long the animation plays
---@param pre_started boolean # if the animation starts right away or is in the first frame until start() is called
---@param repeatable boolean # if the anmiation is repeatable or only plays once
---@param sound_track love.Source # sound source to play with the animation (beware: sound_track pitch will be adapted based on desired duration)
---@return animation # the animation object that can be updated and drawn
local new_animation = function(
    sprite_sheet,
    width,
    height,
    pos_x,
    pos_y,
    pivot_x,
    pivot_y,
    duration,
    pre_started,
    repeatable,
    sound_track
)
    local a = {}
    a.sprite_sheet = sprite_sheet;
    a.quads = {};
    a.quad_n = 0;

    for y = 0, sprite_sheet:getHeight() - height, height do
        for x = 0, sprite_sheet:getWidth() - width, width do
            table.insert(a.quads, love.graphics.newQuad(x, y, width, height, sprite_sheet:getDimensions()))
            a.quad_n = a.quad_n + 1;
        end
    end

    a.duration = duration or 1
    a.current_time = 0
    a.played = false
    a.started = pre_started
    a.repeatable = repeatable

    if sound_track ~= nil then
        local sound_duration = sound_track:getDuration("seconds")
        sound_track:setPitch(sound_duration / duration)
        a.sound_track = sound_track
    end

    function a.draw(self, x, y, scale_x, scale_y)
        local sprite_n = math.floor(self.current_time / self.duration * #self.quads) + 1

        if sprite_n > self.quad_n then
            sprite_n = self.quad_n
        end

        love.graphics.draw(
            self.sprite_sheet,
            self.quads[sprite_n],
            x or pos_x,
            y or pos_y,
            0,
            scale_x,
            scale_y,
            pivot_x,
            pivot_y
        )
    end

    function a.update(self, dt)
        if not self.started then
            return
        end

        self.current_time = self.current_time + dt
        if self.current_time >= self.duration and self.repeatable then
            self.current_time = self.current_time - self.duration
        end

        if sound_track ~= nil and not self.sound_track:isPlaying() and not self.played then
            love.audio.play(self.sound_track)
            self.played = true
        end
    end

    function a.start(self)
        self.started = true
    end

    return a
end

M.new_animation = new_animation

return M
