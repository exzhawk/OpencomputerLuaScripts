--
-- User: Epix
-- Date: 2017/1/30
-- Time: 21:50
--

local sides = {
    down = 0,
    up = 1,
    north = 2,
    south = 3,
    west = 4,
    east = 5,
}


local transposer = component.proxy(component.list('transposer')())

--altar/orb holder/input chest/output chest position relative to transposer
local ALTAR_P = sides.south
local ORB_P = sides.up
local IN_P = sides.north
local OUT_P = sides.west
local move = transposer.transferItem

--initial state: no item need to be crafted, orb in altar
function run()
    while 1 do
        repeat
        until transposer.getStackInSlot(IN_P, 1) ~= nil
        move(ALTAR_P, ORB_P)
        local inputLabel = transposer.getStackInSlot(IN_P, 1)['label']
        move(IN_P, ALTAR_P)
        repeat
        until transposer.getStackInSlot(ALTAR_P, 1)['label'] ~= inputLabel
        move(ALTAR_P, OUT_P)
        move(ORB_P, ALTAR_P)
    end
end

run()