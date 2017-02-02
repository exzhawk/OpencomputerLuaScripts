--
-- User: Epix
-- Date: 2017/1/27
-- Time: 17:59
--

-- control telepad use pre-defined coordinate selector
-- coordinate selector can be rename in anvil for convenience
local event = require('event')
local term = require('term')
local sides = require('sides')
local component = require('component')
local screen = component.screen
local gpu = component.gpu
local redstone = component.redstone
local transposer = component.transposer

-- relative postion to transposer of chest holding coordinate selector/autonoumous activator
local COOR_P = sides.east
local ACT_P = sides.west
-- relative postion to redstone io or computer case
local TELEPAD_P = sides.west

function scanInventory()
    local destTable = {}
    for index = 1, transposer.getInventorySize(COOR_P) do
        local item = transposer.getStackInSlot(COOR_P, index)
        if item == nil then
            break
        else
            local destLabel = item['label']
            destTable[index] = destLabel
        end
    end
    return destTable
end

function construct(destTable)
    screen.setTouchModeInverted(true)
    local max = 10
    for _, destLabel in ipairs(destTable) do
        max = math.max(max, string.len(destLabel))
    end
    gpu.setBackground(0x000000, false)
    gpu.setForeground(0xffffff, false)
    gpu.setResolution(max, #destTable)
    term.clear()
    for index, destLabel in ipairs(destTable) do
        term.setCursor(1, index)
        term.write(destLabel)
    end
    while 1 do
        send(event.pull())
    end
end


function send(eventId, screenAddress, x, y, button, playerName)
    if eventId == 'touch' then
        local dest = y
        transposer.transferItem(COOR_P, ACT_P, 1, dest, 1)
        os.sleep(1)
        transposer.transferItem(ACT_P, COOR_P, 1, 1, dest)
        redstone.setOutput(TELEPAD_P, 15)
        os.sleep(1)
        redstone.setOutput(TELEPAD_P, 0)
    end
end

function run()
    local destTable = scanInventory()
    construct(destTable)
end


run()