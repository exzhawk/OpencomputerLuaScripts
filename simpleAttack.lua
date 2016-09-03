local robot=require("robot")
function  main()
    while 1 do
      if robot.durability()>10 then
            robot.swing()
        else
            return
        end
    end
end
main()