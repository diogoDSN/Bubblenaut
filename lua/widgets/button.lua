local M = {}

---@class button
local button = {}

local new_button = function(
    width,
    height,
    pos_x,
    pos_y,
    text,
    color,
    text_color,
    onClick
)
    local b = {}

    b.sprite = love.graphics.newImage("archive/button.png")

    b.width, b.height = width, height
    b.pos_x, b.pos_y = pos_x, pos_y
    b.text = text

    b.scale_x = b.width / b.sprite:getWidth()
    b.scale_y = b.height / b.sprite:getHeight()

    b.original_color = color
    b.original_text_color = text_color

    b.color = color
    b.text_color = text_color

    b.onClick = onClick

    local font_size = 1
    local adjustment = 1.3
    repeat
        local font = love.graphics.newFont("archive/fonts/pixel_font.ttf", font_size)
        local text_width = font:getWidth(b.text)
        local text_height = font:getHeight()

        font_size = font_size + 1
    until( 
        text_width > b.width / adjustment or
        text_height > b.height / adjustment
    )

    b.font = love.graphics.newFont("archive/fonts/pixel_font.ttf", font_size)

    function b.draw(self)
        love.graphics.setColor(b.color.r, b.color.g, b.color.b)
        love.graphics.draw(
            self.sprite,                             -- sprite
            self.pos_x, self.pos_y,                         -- position
            0,                                          -- rotation
            b.scale_x, b.scale_y -- scaling
        )
        
        local offset_x = (self.width - b.font:getWidth(b.text)) / 2
        local offset_y = (self.height - b.font:getHeight()) / 2

        love.graphics.setFont(self.font)
        love.graphics.setColor(b.text_color.r, b.text_color.g, b.text_color.b)
        love.graphics.printf(
            self.text, 
            self.pos_x + offset_x, self.pos_y + offset_y, 
            love.graphics.getWidth()
        )
        love.graphics.setColor(1, 1, 1)
    end

    function b.pressed(self, mx, my)
        if mx > self.pos_x and mx < self.pos_x + self.width and my > self.pos_y and my < self.pos_y + self.height then
            self.onClick()
        end
    end

    function b.hover(self, mx, my)
        if mx > self.pos_x and mx < self.pos_x + self.width and my > self.pos_y and my < self.pos_y + self.height then
            b.color = b.original_text_color
            b.text_color = b.original_color
        else
            b.color = b.original_color
            b.text_color = b.original_text_color
        end
    end

    return b
end

M.new_button = new_button

return M