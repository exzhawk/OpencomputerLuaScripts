local r=require("robot")
local component = require("component")
t=component.tractor_beam.address
local tb=component.proxy(t)
--start analyze
function main()
    count=r.count(1)
    r.select(15)
    r.suckDown(count)
    for craftcycle=1,count do
        for slot=1,15 do
            r.select(slot)
            r.drop(1)
        end
        r.select(16)
        if not(r.suck()) then
            tp.suck()
        end
        r.forward()
        r.drop()
        r.useUp()
        r.useDown()
        r.back()
    end
end
main()