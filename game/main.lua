function love.load()
    ListOfRects = {}
end

function createRect()
    local newRect = {}
    newRect.mode = "line"
    newRect.width = 10
    newRect.height = 10
    newRect.x = 10
    newRect.y = 10
    table.insert(ListOfRects, newRect)
end

function love.keypressed(key)
    if key == "space" then
        createRect()
    end
end

function love.update(dt)
    for i, v in ipairs(ListOfRects) do
        v.x = v.x + 20 * dt
        v.y = v.y + 20 * dt
    end
end

function love.draw()
    for i, v in ipairs(ListOfRects) do
        love.graphics.rectangle(v.mode, v.x, v.y, v.width, v.height)
    end
end
