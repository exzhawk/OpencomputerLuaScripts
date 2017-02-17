--
-- User: Epix
-- Date: 2017/1/27
-- Time: 17:59
--

local event = require('event')
local term = require('term')
local serialization = require('serialization')
local component = require('component')
local tunnel = component.tunnel
local screen = component.screen
local gpu = component.gpu


function receive(eventId, receiverAddress, senderAddress, trash1, trash2, data)
    if eventId == 'modem_message' then
        local destTable = serialization.unserialize(data)
        screen.setTouchModeInverted(true)
        local max = 10
        for _, destLabel in ipairs(destTable) do
            max = math.max(max, string.len(destLabel))
        end
        gpu.setResolution(max, #(destTable))
        term.clear()
        for index, destLabel in ipairs(destTable) do
            term.setCursor(1, index)
            term.write(destLabel)
        end
        while 1 do
            send(event.pull())
        end
    end
end

function waiting()
    print('waiting info')
    while 1 do
        receive(event.pull())
    end
end

function send(eventId, screenAddress, x, y, button, playerName)
    if eventId == 'touch' then
        tunnel.send(y)
    end
end

waiting()

