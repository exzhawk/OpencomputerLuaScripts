--
-- User: Epix
-- Date: 2017/1/26
-- Time: 18:18.
--

--automatically keep certain number of items in your me network

--filename to save your requirement
local SAVE_FILENAME = 'keepTable.csv'
--do not craft items if free crafting cpu is lesser than this number
local spareCpu = 2

--Usage:
--Requirement: a decent computer with adapter(connected to me controller) and screen(tier 3, portrait)
--First, run `keepMENumber.lua gen` to generate a full list of craftable items in your me network.
--you need to run it again if you added or removed recipes. the generated file will be updated with current me network
--and won't lost you previous settings.
--Second, edit generated `SAVE_FILENAME` file to assign you expecting number of items. the file is a non-quoted csv file
--w/o header. one item per line, format of line is `<expecting number>,<item name>`. leave zero if you do not need to
--keep.
--Third, run `keepMENumber.lua` to start monitoring program. all procedures are done in single thread to consume only
--one crafting unit. press `Enter` key to stop the program AFTER current job finished.


--todo log details to file or network


local LEVEL_COLOR = {
    FAIL = 0xFF0000,
    DONE = 0x00FF00,
    CHECK = 0x00FFFF,
    SKIP = 0x0000FF,
}

local shell = require('shell')
local event = require('event')
local term = require('term')
local component = require('component')
local m = component.me_controller
local gpu = component.gpu


function readTable()
    local craftablesNumber = {}
    local f = io.open(SAVE_FILENAME)
    if f ~= nil then
        io.close(f)
    else
        return craftablesNumber
    end
    for line in io.lines(SAVE_FILENAME) do
        local number, itemLabel = string.match(line, '(%d+),(.+)')
        craftablesNumber[itemLabel] = tonumber(number)
    end
    return craftablesNumber
end

function getTable()
    local craftables = m.getCraftables()
    local craftablesNumber = {}
    for _, craftable in ipairs(craftables) do
        local craftableItemStack = craftable.getItemStack()
        craftablesNumber[craftableItemStack['label']] = 0
    end
    return craftablesNumber
end

function writeTable(craftablesTable)
    io.output(SAVE_FILENAME)
    local itemLabelSorted = {}
    for itemLabel, _ in pairs(craftablesTable) do
        table.insert(itemLabelSorted, itemLabel)
    end
    table.sort(itemLabelSorted)
    for _, itemLabel in ipairs(itemLabelSorted) do
        io.write(string.format('%d,%s\n', craftablesTable[itemLabel], itemLabel))
        io.flush()
    end
    io.write()
    io.close()
end

function mergeTable()
    local savedTable = readTable()
    local currentTable = getTable()
    local workingTable = {}
    for itemLabel, _ in pairs(currentTable) do
        workingTable[itemLabel] = savedTable[itemLabel] or 0
    end
    writeTable(workingTable)
end

function filterTable(itemTable)
    local filteredTable = {}
    for itemLabel, number in pairs(itemTable) do
        if number ~= 0 then
            filteredTable[itemLabel] = number
        end
    end
    return filteredTable
end

function getItemCount(filter)
    local count = 0
    local haveItems = m.getItemsInNetwork(filter)
    if #haveItems == 0 then
        return nil
    else
        for _, item in ipairs(haveItems) do
            count = count + item['size']
        end
        return count
    end
end

function getAvailCpu()
    local count = 0
    local cpus = m.getCpus()
    for _, cpu in ipairs(cpus) do
        if cpu['busy'] == false then
            count = count + 1
        end
    end
    return count
end

function run()
    local requestTable = {}
    while 1 do
        handle(event.pull(0))
        local keepTable = readTable()
        keepTable = filterTable(keepTable)
        for itemLabel, keepNumber in pairs(keepTable) do
            handle(event.pull(0))
            log(itemLabel, 'CHECK')
            local haveNumber = getItemCount({ label = itemLabel })
            if haveNumber == nil then
                log(itemLabel, 'FAIL', 'no recipe')
            else
                if requestTable[itemLabel] == nil then
                    if haveNumber < keepNumber and getAvailCpu() > spareCpu then
                        local request = m.getCraftables({ label = itemLabel })[1].request(keepNumber - haveNumber)
                        requestTable[itemLabel] = request
                    else
                        log(itemLabel, 'SKIP')
                    end
                else
                    local request = requestTable[itemLabel]
                    local canceled, reason = request.isCanceled()
                    if canceled then
                        log(itemLabel, 'FAIL', reason)
                        requestTable[itemLabel] = nil
                    elseif request.isDone() then
                        log(itemLabel, 'DONE')
                        requestTable[itemLabel] = nil
                    end
                end
            end
        end
    end
end

function handle(e, address, char, code, playerName)
    if e == 'key_down' and char == 13 then
        gpu.setResolution(160, 50)
        os.exit()
    end
end

function log(text, level, msg)
    if level == 'CHECK' or level == 'SKIP' then
        return nil
    else
        gpu.setForeground(LEVEL_COLOR[level])
        term.write('[' .. level .. ']\t')
        gpu.setForeground(0xFFFFFF)
        term.write(text .. '\t')
        if msg ~= nil then
            term.write(msg)
        end
        term.write('\n')
    end
end

function doAction(action)
    if action == 'gen' then
        mergeTable()
        gpu.setResolution(160, 50)
        os.exit()
    else
        run()
    end
end

gpu.setResolution(60, 48)
local args, _ = shell.parse(...)
doAction(args[1])
