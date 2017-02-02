--
-- User: Epix
-- Date: 2017/1/31
-- Time: 21:09
--

-- use multi hologram to display scanned area
local component = require('component')
local HOLO_W, HOLO_D = 3, 3
local HOLOS_ADDR = {
    { '574', '6bd', '2ea' },
    { '10d', '985', '458' },
    { '25c', 'c43', '02b' },
}

local colorMapping = {
    ['35:0'] = 0xf6ecf7,
    ['35:3'] = 0x7777ff,
    ['35:5'] = 0x367d93,
    ['35:11'] = 0x0000ff,
    ['49:0'] = 0x222222,
    ['159:0'] = 0xdda5ae,
}
local holoMapping = {}

local holos = {}
for _, row in ipairs(HOLOS_ADDR) do
    local holos_row = {}
    for _, cell in ipairs(row) do
        local holo = component.proxy(component.get(cell))
        table.insert(holos_row, holo)
    end
    table.insert(holos, holos_row)
end

local holoss = {}
for _, row in ipairs(holos) do
    for _, cell in ipairs(row) do
        table.insert(holoss, cell)
    end
end
function init()
    for index, holo in ipairs(holoss) do
        holo.clear()
        holo.fill(index, index, 1, 32 - index, 1)
        holo.fill(index, 48 - index, 1, 32 - index, 2)
        holo.fill(48 - index, index, 1, 32 - index, 3)
    end
    for row_index, row in ipairs(holos) do
        for holo_index, holo in ipairs(row) do
            holo.setTranslation(-(holo_index - 2) / 3, 1, -(row_index - 2) / 3)
            holo.setPaletteColor(1, 0xff0000)
            holo.setPaletteColor(2, 0x00ff00)
            holo.setPaletteColor(3, 0x0000ff)
        end
    end
    os.sleep(10)
    for index, holo in ipairs(holoss) do
        holo.clear()
    end
end

function initColor()
    local holoCount = 1
    for blockId, color in pairs(colorMapping) do
        holoMapping[blockId] = holoss[holoCount]
        holoss[holoCount].setPaletteColor(1, color)
        holoCount = holoCount + 1
    end
end

function readData(filename)
    local file = io.open(filename, 'r')
    local rawdata = file:read('*all')
    file:close()
    local data = load('return ' .. rawdata)
    return data
end

function display(data)
    for _, cell in ipairs(data) do
        local x = cell[1] * 2
        local z = cell[2] * 2
        local sy = cell[3] * 2
        local ey = cell[4] * 2 + 1
        local index = cell[5]
        local holo = holoMapping[index]
        holo.fill(x, z, sy, ey, 1)
        holo.fill(x + 1, z, sy, ey, 1)
        holo.fill(x, z + 1, sy, ey, 1)
        holo.fill(x + 1, z + 1, sy, ey, 1)
    end
end


function run()
    init()
    initColor()
    local data = readData('youmu.model')()
    display(data)
end

run()