require "lua.bubble.bubble"

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()


    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", Bubble.center_x, Bubble.center_y, Bubble.outer_radius)
    love.graphics.setColor(0.2, 0.2, 1, 0.5)
    love.graphics.circle("fill", Bubble.center_x, Bubble.center_y, Bubble.inner_radius)
end
