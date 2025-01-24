local bubble = {
    center_x = 100,
    center_y = 100,
    inner_radius = 50,
    outer_radius = 52,
    speed = 250,
}


function love.load()
    love.window.setMode(1200, 800)
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()


    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A Bubble", width / 10, height / 10)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", bubble.center_x, bubble.center_y, bubble.outer_radius)
    love.graphics.setColor(0.2, 0.2, 1, 0.5)
    love.graphics.circle("fill", bubble.center_x, bubble.center_y, bubble.inner_radius)
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        bubble.center_x = bubble.center_x + bubble.speed * dt
    end
    if love.keyboard.isDown("left") then
        bubble.center_x = bubble.center_x - bubble.speed * dt
    end
    if love.keyboard.isDown("up") then
        bubble.center_y = bubble.center_y - bubble.speed * dt
    end
    if love.keyboard.isDown("down") then
        bubble.center_y = bubble.center_y + bubble.speed * dt
    end
end
