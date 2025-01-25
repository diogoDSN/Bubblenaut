local M = {}

---@param dest_page string # the width of a frame
---@param duration number # duration of transition
local new_beamer = function(dest_page, duration)
    local beamer = {
        duration = duration,
        activated = false,
        destination = dest_page
    }

    function beamer.activate(self)
        self.activated = true
    end

    function beamer.update(self, dt)
        if self.activated then
            beamer.duration = beamer.duration - dt
        end

        if self.duration <= 0 then
            return beamer.destination
        end

        return nil
    end

    return beamer
end

M.new_beamer = new_beamer

return M
