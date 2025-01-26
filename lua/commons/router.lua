local M = {}

---@param dest_page string # the width of a frame
---@param duration number # duration of transition
local new_beamer = function(dest_page, duration, current_level)
    local beamer = {
        duration = duration,
        activated = false,
        destination = dest_page,
		current_level = current_level
    }

    function beamer.activate(self, dest_page)
        self.destination = dest_page or self.destination
        self.activated = true
    end

    function beamer.update(self, dt)
        if self.activated then
            beamer.duration = beamer.duration - dt
        end

        if self.duration <= 0 then
            return beamer.destination, beamer.current_level
        end

        return nil
    end

    return beamer
end

M.new_beamer = new_beamer

return M
