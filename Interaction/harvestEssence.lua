local robot=require("robot")
local computer=require("computer")
function oneLine()
    for s=1,11 do
        robot.useDown()
        robot.forward()
    end
end
function harvest()
    for s=1,4 do
        oneLine()
        robot.turnLeft()
        robot.useDown()
        robot.forward()
        robot.turnLeft()
        oneLine()
        robot.turnRight()
        robot.useDown()
        robot.forward()
        robot.turnRight()
    end
end
function dropInv()
    for i=1,16 do
        robot.select(i)
        robot.drop()
    end
end
function main()
    robot.forward()
    harvest()
    robot.turnAround()
    robot.forward()
    dropInv()
    robot.turnLeft()
    for i=1,8 do
        robot.forward()
    end
    robot.turnLeft()
    repeat 
        os.sleep(1)
        until computer.energy()>49000
    end
while 1 do
    main()
end