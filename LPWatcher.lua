--
-- User: Epix
-- Date: 2017/1/31
-- Time: 15:15
--


local sides = require('sides')
local term = require('term')
local os = require('os')
local component = require('component')
local transposer = component.transposer
local gpu = component.gpu
local hologram = component.hologram

--relative position of a inventory holding orb
local ORB_P = sides.north

--capacity multipler
local capMul = 1.52

function checkLP()
    local orb = transposer.getStackInSlot(ORB_P, 1)
    return orb['networkEssence'], math.floor(orb['maxNetworkEssence'] * capMul)
end

function updateScreen(lp, cap)
    term.clear()
    term.setCursor(1, 1)
    term.write(string.format('%08d/%08d', lp, cap))
end

function updateHologram(lp, cap)
    local fillLen = math.floor(lp / cap * 46)
    for i = 1, fillLen do
        hologram.fill(1, i + 1, 2, 7, 2)
    end
    for i = fillLen + 1, 46 do
        hologram.fill(1, i + 1, 2, 7, 0)
    end
end

function init()
    gpu.setResolution(17, 1)
    term.clear()
    hologram.clear()
    hologram.setTranslation(0, 0, 1 / 3)
    hologram.setPaletteColor(1, 0x00ffff)
    hologram.setPaletteColor(2, 0xff0000)
    for i = 1, 48 do
        hologram.fill(1, i, 1, 8, 1)
    end
    for i = 2, 47 do
        hologram.fill(1, i, 2, 7, 0)
    end
end

function run()
    local lp, cap = checkLP()
    updateScreen(lp, cap)
    updateHologram(lp, cap)
    os.sleep(1)
end

init()
while 1 do
    run()
end

