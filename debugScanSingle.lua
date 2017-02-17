--
-- User: Epix
-- Date: 2017/2/13
-- Time: 22:36
--

-- user debug card to scan an area and save the model
-- saved in separete single block format
local serialization = require('serialization')
local component = require('component')
local printer = component.printer3d
local debug = component.debug
local world = debug.getWorld()


local saveFile = 'modoka.model'
local sx, sy, sz = 501, 56, 895
local ex, ey, ez = 527, 100, 933


function getInfo(x, y, z)
    local blockId = world.getBlockId(x, y, z)
    if blockId == 0 then
        return nil
    else
        return blockId .. ':' .. world.getMetadata(x, y, z)
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
    print('size', dx + 1, dy + 1, dz + 1)
    for x = start_x, end_x do
        for z = start_z, end_z do
            for y = start_y, end_y do
                local color = getInfo(x, y, z)
                if color ~= nil then
                    table.insert(result, { x - start_x, y - start_y, z - start_z, color })
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
    local cuboid = getCuboid(sx, sy, sz, ex, ey, ez)
    io.output(saveFile)
    io.write(serialization.serialize({
        x = ex - sx + 1,
        y = ey - sy + 1,
        z = ez - sz + 1,
        data = cuboid
    }, math.huge))
    io.flush()
    io.close()
end

run()


