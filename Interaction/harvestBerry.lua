-- Created by IntelliJ IDEA.
-- User: Epix
-- Date: 2016/9/3
-- Time: 15:59

local robot = require("robot")
function one_line()
    repeat
        local s, r = robot.forward()
--        print(s,r)
        robot.useDown()
    until s == nil and r ~= "already moving"

    repeat
        local s, r = robot.back()
    until s == nil and r ~= "already moving"
end

function harvest()
    repeat
        one_line()
        robot.turnLeft()
        local s,r = robot.forward()
        robot.turnRight()
    until s == nil and r ~= "already moving"
    robot.turnRight()
    repeat
        local s, r = robot.forward()
    until s == nil and r ~= "already moving"
    robot.turnLeft()
end

function main()
    harvest()
    os.sleep(60*5)
end

while 1 do
    main()
end
