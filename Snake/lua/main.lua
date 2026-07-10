local GRID_SIZE = 20
local TILE_SIZE = 30
local WINDOW_SIZE = GRID_SIZE * TILE_SIZE


local snake = {}
local direction = "right"
local nextDirection = "right"
local food = {}
local timer = 0
local speed = 0.15
local isGameOver = false
local score = 0


local function spawnFood()
    while true do
        food.x = love.math.random(1, GRID_SIZE)
        food.y = love.math.random(1, GRID_SIZE)
        
        local onSnake = false
        for _, segment in ipairs(snake) do
            if segment.x == food.x and segment.y == food.y then
                onSnake = true
                break
            end
        end
        
        if not onSnake then break end
    end
end

function love.load()
    love.window.setMode(WINDOW_SIZE, WINDOW_SIZE)
    love.window.setTitle("Змейка на Lua (Love2D)")
    
    snake = {
        {x = 5, y = 10},
        {x = 4, y = 10},
        {x = 3, y = 10}
    }
    direction = "right"
    nextDirection = "right"
    isGameOver = false
    score = 0
    spawnFood()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if isGameOver and key == "r" then
        love.load()
    end

    if (key == "up" or key == "w") and direction ~= "down" then
        nextDirection = "up"
    elseif (key == "down" or key == "s") and direction ~= "up" then
        nextDirection = "down"
    elseif (key == "left" or key == "a") and direction ~= "right" then
        nextDirection = "left"
    elseif (key == "right" or key == "d") and direction ~= "left" then
        nextDirection = "right"
    end
end

function love.update(dt)
    if isGameOver then return end

    timer = timer + dt
    if timer >= speed then
        timer = 0
        direction = nextDirection

        local head = snake[1]
        local newHead = {x = head.x, y = head.y}

        if direction == "up" then newHead.y = newHead.y - 1
        elseif direction == "down" then newHead.y = newHead.y + 1
        elseif direction == "left" then newHead.x = newHead.x - 1
        elseif direction == "right" then newHead.x = newHead.x + 1
        end

        if newHead.x < 1 or newHead.x > GRID_SIZE or newHead.y < 1 or newHead.y > GRID_SIZE then
            isGameOver = true
            return
        end

        for _, segment in ipairs(snake) do
            if newHead.x == segment.x and newHead.y == segment.y then
                isGameOver = true
                return
            end
        end

        table.insert(snake, 1, newHead)

        if newHead.x == food.x and newHead.y == food.y then
            score = score + 1
            spawnFood()
        else
            table.remove(snake)
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.rectangle("fill", (food.x - 1) * TILE_SIZE, (food.y - 1) * TILE_SIZE, TILE_SIZE - 2, TILE_SIZE - 2)

    for i, segment in ipairs(snake) do
        if i == 1 then
            love.graphics.setColor(0.2, 0.9, 0.2)
        else
            love.graphics.setColor(0.1, 0.7, 0.1)
        end
        love.graphics.rectangle("fill", (segment.x - 1) * TILE_SIZE, (segment.y - 1) * TILE_SIZE, TILE_SIZE - 2, TILE_SIZE - 2)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)

    if isGameOver then
        love.graphics.setColor(0, 0, 0, 0.75)
        love.graphics.rectangle("fill", 0, 0, WINDOW_SIZE, WINDOW_SIZE)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("GAME OVER", 0, WINDOW_SIZE / 2 - 20, WINDOW_SIZE, "center")
        love.graphics.printf("Press 'R' to Restart", 0, WINDOW_SIZE / 2 + 10, WINDOW_SIZE, "center")
    end
end
