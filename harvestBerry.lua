--
-- Created by IntelliJ IDEA.
-- User: Epix
-- Date: 2016/9/3
-- Time: 15:59
-- To change this template use File | Settings | File Templates.
--
W = 5
D = 16
local robot = require("robot")
local computer = require("computer")
function oneLine()
    for i = 1, D do
        robot.forward()
        robot.useDown()
    end
    for i = 1, D do
        robot.back()
    end
end

function harvest()
    for i = 1, W do
        robot.turnLeft()
        robot.forward()
        robot.turnRight()
        oneLine()
    end
    robot.turnRight()
    for i = 1, W do
        robot.forward()
    end
    robot.turnLeft()
end

function main()
    os.sleep(60)
end

while 1 do
    main()
end
