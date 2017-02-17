--
-- User: Epix
-- Date: 2017/2/2
-- Time: 13:19
--

-- use debug card to scan an area of armourer's workshop block and print 3d model.

local component = require('component')
local printer = component.printer3d
local debug = component.debug
local world = debug.getWorld()


local sx, sy, sz = 792, 15, -1040
local ex, ey, ez = 803, 28, -1029

function transColor(color)
    if color < 0 then
        return 256 + color
    else
        return color
    end
end

function getColor(x, y, z)
    local blockId = world.getBlockId(x, y, z)
    if blockId ~= 169 then
        return nil
    else
        local nbt = world.getTileNBT(x, y, z)
        local r = transColor(nbt.value.r1.value)
        local g = transColor(nbt.value.g1.value)
        local b = transColor(nbt.value.b1.value)
        return r * 256 * 256 + g * 256 + b
    end
end

function getOffset(delta)
    return math.floor((16 - delta) / 2)
end

function getCuboid(start_x, start_y, start_z, end_x, end_y, end_z)
    local dx, dy, dz = end_x - start_x, end_y - start_y, end_z - start_z
    local result = {}
    print('start', start_x, start_y, start_z)
    print('end', end_x, end_y, end_z)
    print('size', dx, dy, dz)
    local ox, oy, oz = getOffset(dx), getOffset(dy), getOffset(dz)
    for x = start_x, end_x do
        for z = start_z, end_z do
            for y = start_y, end_y do
                local color = getColor(x, y, z)
                if color ~= nil then
                    table.insert(result, { x - start_x + ox, y - start_y + oy, z - start_z + oz, color })
                end
            end
            print(x, z)
        end
    end
    return result
end



function print3d(data)
    printer.reset()
    for _, cell in ipairs(data) do
        printer.addShape(cell[1], cell[2], cell[3], cell[1] + 1, cell[2] + 1, cell[3] + 1, 'opencomputers:White', false, cell[4])
        printer.addShape(cell[3], cell[2], cell[1], cell[3] + 1, cell[2] + 1, cell[1] + 1, 'opencomputers:White', true, cell[4])
    end
    printer.setRedstoneEmitter(15)
    printer.commit()
end

function run()
    local data = getCuboid(sx, sy, sz, ex, ey, ez)
    print3d(data)
end

run()
