--
-- User: Epix
-- Date: 2017/2/2
-- Time: 16:44
--

-- use debug card to scan block in a certain area

local serialization = require('serialization')
local component = require('component')
local debug = component.debug
local world = debug.getWorld()

local saveFile = 'youmu.model'

local sx, sy, sz = -123, 78, 266
local ex, ey, ez = -115, 93, 275

function getInfo(x, y, z)
    local blockId = world.getBlockId(x, y, z)
    if blockId == 0 then
        return nil
    else
        return blockId .. ':' .. world.getMetadata(x, y, z)
    end
end

function getColumn(x, z, start_y, end_y)
    print(x, z)
    local column = {}
    local lastBlockInfo --last scanned valid block info
    local lastEnd = 0 --last scanned valid block y
    local lastStart = 0
    for y = start_y, end_y do
        local blockInfo = getInfo(x, y, z)
        if blockInfo == lastBlockInfo then
            lastEnd = y
        else
            if lastBlockInfo ~= nil then
                table.insert(column, { x - sx, z - sz, lastStart - sy, lastEnd - sy, lastBlockInfo })
            end
            lastStart = y
            lastEnd = y
            lastBlockInfo = blockInfo
        end
    end
    return column
end

function getCuboid(start_x, start_y, start_z, end_x, end_y, end_z)
    local columns = {}
    for x = start_x, end_x do
        for z = start_z, end_z do
            local column = getColumn(x, z, start_y, end_y)
            for _, piece in ipairs(column) do
                table.insert(columns, piece)
            end
        end
    end
    return columns
end

function doScan()
    local cuboid = getCuboid(sx, sy, sz, ex, ey, ez)
    io.output(saveFile)
    io.write(serialization.serialize(cuboid, math.huge))
    io.flush()
    io.close()
end

doScan()