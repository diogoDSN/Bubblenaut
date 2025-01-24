require "lua.state"

function love.update(dt)
    if love.keyboard.isDown("right") then
        Bubble.center_x = Bubble.center_x + Bubble.speed * dt
    end
    if love.keyboard.isDown("left") then
        Bubble.center_x = Bubble.center_x - Bubble.speed * dt
    end
    if love.keyboard.isDown("up") then
        Bubble.center_y = Bubble.center_y - Bubble.speed * dt
    end
    if love.keyboard.isDown("down") then
        Bubble.center_y = Bubble.center_y + Bubble.speed * dt
    end
end
