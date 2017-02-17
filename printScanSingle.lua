--
-- User: Epix
-- Date: 2017/2/13
-- Time: 22:56
--

-- print the saved model scanned by debugScanSingle.lua
-- will cost large amount of shapes
local os = require('os')
local component = require('component')
local printer = component.printer3d
local colorMapping = {
    ['35:0'] = 0xffffff,
    ['35:6'] = 0xD08499,
    ['35:4'] = 0xB1A627,
    ['35:5'] = 0x41AE38,
    ['35:10'] = 0x7E3DB5,
    ['155:0'] = 0xffffff,
    ['42:0'] = 0xffffff,
    ['159:0'] = 0xdda5ae,
    ['20:0'] = 0xffffff,
    ['5:0'] = 0xb08c59,
}
function readData(filename)
    local file = io.open(filename, 'r')
    local rawdata = file:read('*all')
    file:close()
    local data = load('return ' .. rawdata)
    return data
end

function print3d(data)
    local tx, ty, tz = data.x, data.y, data.z
    local modelData = data.data
    local models = {}
    for _, cell in ipairs(modelData) do
        local x, y, z, color = cell[1], cell[2], cell[3], colorMapping[cell[4]]
        local rx, ry, rz = math.fmod(x, 16), math.fmod(y, 16), math.fmod(z, 16)
        local chunkNumber = math.floor(x / 16) .. ',' .. math.floor(y / 16) .. ',' .. math.floor(z / 16)
        if models[chunkNumber] == nil then
            models[chunkNumber] = {}
        end
        table.insert(models[chunkNumber], { rx, ry, rz, color })
    end
    for chunk, model in pairs(models) do
        printer.reset()
        print(chunk)
        print(#model)
        printer.setLabel(chunk)
        for _, cell in ipairs(model) do
            local x, y, z, color = cell[1], cell[2], cell[3], cell[4]
            if color ~= nil then
                printer.addShape(x, y, z, x + 1, y + 1, z + 1, 'opencomputers:White', false, color)
            end
        end
        printer.commit()
        repeat
            os.sleep(1)
        until printer.status() == 'idle'
    end
    printer.reset()
end

function run()
    local data = readData('modoka.model')()
    print3d(data)
end

run()


