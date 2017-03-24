-- User: Epix
-- Date: 2017/3/21
-- Time: 16:20


--auto config AE Export Bus based on pattern, GregTech5 stuff only
--use ../prepare/prepareGregTech.lang.py to prepare GregTech.table

local os = require('os')
local component = require('component')
local me_controller = component.me_controller
local db = component.database
--key: short address for export bus, use analyzer on adapter to get address
--value: a list of pattern
local exportBusConf = {
    {
        'cd5', {
        '^Centrifuged .* Ore$', '^Monazite Ore$', '^Quartzite Ore$', '^Lazurite Ore$', '^Phosphorus Ore$',
        '^Lignite Coal Ore$', '^Salt Ore$', '^Almandine Ore$', '^Cobaltite Ore$', '^Grossular Ore$', '^Phosphate Ore$',
        '^Pyrope Ore$', '^Spessartine Ore$', '^Tetrahedrite Ore$', '^Chalcopyrite Ore$', '^Graphite Ore$',
        '^Malachite Ore$', '^Soapstone Ore$', '^Wulfenite Ore$', '^Powerllite Ore$', '^Barite Ore$', '^Bastnasite Ore$',
        '^Garnierite Ore$', '^Lepidolite Ore$', '^Scheelite Ore$', '^Ilmenite Ore$', '^Spodumene Ore$',
        '^Tantalite Ore$', '^Vanadium Magnetite Ore$', '^Galuconite Ore$', '^Rock Salt Ore$'
    }
    },
    { '31c', { '^Crushed .* Ore$', } },
    { '469', { '^Purified .* Ore$', } },
}
local gt_name = {}

function setAllSideExportBus(bus, entry)
    for side = 0, 5 do
        bus.setExportConfiguration(side, 1, db.address, entry)
    end
end

function configBus(busIndex, bus, busPatterns)
    local items = me_controller.getItemsInNetwork()
    print(#items)
    for _, itemstack in ipairs(items) do
        os.sleep(0)
        local raw_label = itemstack.label
        local label = gt_name[raw_label]
        if label ~= nil then
            for _, pattern in ipairs(busPatterns) do
                if string.match(label, pattern) ~= nil then
                    print('exporting ' .. label)
                    db.clear(busIndex)
                    me_controller.store({ label = raw_label }, db.address, busIndex, 1)
                    setAllSideExportBus(bus, busIndex)
                    os.sleep(0)
                    return
                end
            end
        end
    end
    print('no matching')
end

function loop()
    for busIndex, busConf in ipairs(exportBusConf) do
        print('checking #' .. tostring(busIndex))
        local busShortAddr = busConf[1]
        local busPatterns = busConf[2]
        local bus = component.proxy(component.get(busShortAddr))
        configBus(busIndex, bus, busPatterns)
    end
end

function getGTName2()
    local count = 0
    for line in io.lines('GregTech.table') do
        os.sleep(0)
        local k, v = string.match(line, '(.+)=(.+)')
        gt_name[k] = v
        count = count + 1
        if count % 1000 == 1 then
            print(count)
        end
    end
end

function main()
    print('getting name')
    getGTName2()
    print(gt_name['gt.180k_NaK_Coolantcell.name'])
    print(gt_name['gt.metaitem.01.7822.name'])
    print('main')
    while true do
        loop()
    end
end

main()
