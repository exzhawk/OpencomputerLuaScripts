local robot=require("robot")
local component=require("component")
local sides=require("sides")
local shell=require("shell")
local args=shell.parse(...)
if #args~=0 then
    length=args[1]
else
    length=64
end
slot=1
robot.select(slot)
function placeFence()
    if not(robot.place()) then 
        slot=slot+1
        robot.select(slot)
        robot.place()
    end
end
function dig()
    robot.turnAround()
    robot.swing()
    robot.turnAround()
end
robot.turnAround()

for edge=1,4 do
    for block=1,length do
        if not(robot.back()) then
            dig()
            robot.back()
        end
        placeFence()
    end
    robot.turnRight()
end
