--
-- User: Epix
-- Date: 2017/2/2
-- Time: 13:19
--

-- print a prototype of scanned area

local component = require('component')
local printer = component.printer3d
local colorMapping = {
    ['35:0'] = 0xf6ecf7,
    ['35:3'] = 0x7777ff,
    ['35:5'] = 0x367d93,
    ['35:11'] = 0x0000ff,
    ['49:0'] = 0x000000,
    ['159:0'] = 0xdda5ae,
}
function readData(filename)
    local file = io.open(filename, 'r')
    local rawdata = file:read('*all')
    file:close()
    local data = load('return ' .. rawdata)
    return data
end

function print3d(data)
    printer.reset()
    for _, cell in ipairs(data) do
        printer.addShape(16 - cell[1], cell[3], cell[2], 16 - (cell[1] + 1), cell[4] + 1, cell[2] + 1,
            'opencomputers:White', false, colorMapping[cell[5]])
    end
    printer.commit()
end

function run()
    local data = readData('youmu.model')()
    print3d(data)
end

run()
