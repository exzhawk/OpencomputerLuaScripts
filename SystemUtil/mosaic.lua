--
-- User: Epix
-- Date: 2017/2/12
-- Time: 12:40
--

--randomly fill the tier 3 screen with maxmium resolution(160*50) using braille patterns
local unicode = require('unicode')
local component = require('component')
local gpu = component.gpu

function getRandomChar()
    return unicode.char(math.random(0x2800, 0x28ff))
end

function writeRandomChar(x, y)
    gpu.set(x, y, getRandomChar())
end

function writeRandomColorChar(x, y)
    gpu.setForeground(math.random(0xffffff))
    gpu.setBackground(math.random(0xffffff))
    writeRandomChar(x, y)
end

function fillAll()
    for x = 1, 160 do
        for y = 1, 50 do
            writeRandomColorChar(x, y)
        end
    end
end

function randomSet()
    local x = math.random(160)
    local y = math.random(50)
    writeRandomColorChar(x, y)
end

function run()
    fillAll()
    while 1 do
        randomSet()
    end
end

run()