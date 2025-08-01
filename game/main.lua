require("keymaps")
local blockInput = false
local playback = false
local pressed_key = {}
local looped_keys = {}
local max_keys = 4
local num_loops = 3
local interval = 1.0
local current_loop = 0
local current_key_index = 0
local timer = 0.0
function love.load() end

debugtext = ""

function love.update(dt)
    debugtext = "current key index: " .. current_key_index .. "current loop: " .. current_loop
    if not playback then
        return
    end
    timer = timer + dt
    if timer >= interval then
        timer = 0.0
        increment_looped_keys()
    end
end

function increment_looped_keys()
    if current_loop > num_loops then
        return
    end

    table.insert(looped_keys, pressed_key[current_key_index])
    if current_key_index == max_keys then
        current_loop = current_loop + 1
    end
    current_key_index = math.max((current_key_index + 1) % (max_keys + 1), 1)
end

function containsValue(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function love.keypressed(key)
    if blockInput then
        return
    end

    if not containsValue(Keymaps, key) then
        return
    end

    if #pressed_key < 4 then
        table.insert(pressed_key, key)
        return
    end

    if not playback then
        toggle_playback(true)
    end
end

function toggle_playback(toggled)
    if toggled then
        current_loop = 1
        current_key_index = 1
        blockInput = true
        playback = true
    else
        blockInput = false
        playback = false
    end
end

function love.draw()
    if pressed_key then
        love.graphics.print(pressed_key, 20, 20)
    end
    if looped_keys then
        love.graphics.print(looped_keys, 20, 40)
    end
    love.graphics.print(timer, 20, 60)
    love.graphics.print(debugtext, 20, 80)
end
