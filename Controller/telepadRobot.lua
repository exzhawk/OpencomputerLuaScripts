--
-- User: Epix
-- Date: 2017/1/27
-- Time: 18:00
--

local event = require('event')
local robot = require('robot')
local serialization=require('serialization')
local sides=require('sides')
local component = require('component')
local inventory_controller = component.inventory_controller
local tunnel = component.tunnel
local redstone =component.redstone

function scanInventory()
    local destTable = {}
    for index = 1, 16 do
        local item = inventory_controller.getStackInInternalSlot(index)
        if item == nil then
            break
        else
            local destLabel = item['label']
            destTable[index] = destLabel
        end
    end
    return destTable
end

function sendInventory(destTable)
    tunnel.send(serialization.serialize(destTable))
end

function receive(eventId, receiverAddress, senderAddress, trash1, trash2, data)
    if eventId == 'modem_message' then
        local dest = tonumber(data)
        robot.select(dest)
        inventory_controller.dropIntoSlot(sides.forward,1,1)
        os.sleep(1)
        inventory_controller.suckFromSlot(sides.forward,1,1)
        redstone.setOutput(sides.right, 15)
        os.sleep(1)
        redstone.setOutput(sides.right, 0)
    end
end

function waiting()
    while 1 do
        receive(event.pull())
    end
end

local destTable = scanInventory()
sendInventory(destTable)
waiting()

