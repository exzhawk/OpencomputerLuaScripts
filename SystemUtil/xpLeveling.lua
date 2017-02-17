--
-- User: Epix
-- Date: 2017/2/10
-- Time: 20:22
--

-- leveling the experience upgrade by consuming items(enchanted armors, tools, etc.)
-- need a input pipe to place items into the equipment slot(can be done by input to sides of the robot)
local component = require('component')
local experience = component.experience
local inventory_controller = component.inventory_controller
while 1 do
    inventory_controller.equip()
    experience.consume()
    print(experience.level())
end

