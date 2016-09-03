local robot=require("robot")
local component=require("component")
local sides=require("sides")
function check()
    if (component.redstone.getInput(sides.bottom)) ~= 0) then
        return true
    end
    return false
end
function lava()
    robot.forward()
    robot.select(1)
    robot.
end