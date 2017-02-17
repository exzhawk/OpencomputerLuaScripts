local component = require("component")
local c = component.crafting
local r=require("robot")
function main()
    r.select(1)
    r.suck(1)
    repeat
        c.craft()
        r.dropDown(2)
    until not(r.suck(1))
end
main()