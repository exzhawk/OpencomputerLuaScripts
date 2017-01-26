-- User: Epix
-- Date: 2017/1/20
-- Time: 13:56

component = require("component")
function check(reactor)
    if reactor.getActive() == true and reactor.getEnergyStored() > 7500000 then
        reactor.setActive(false)
    end
    if reactor.getActive() == false and reactor.getEnergyStored() < 2500000 then
        reactor.setActive(true)
    end
end

function main()
    local reactor = component.br_reactor
    while 1 do
        check(reactor)
        os.sleep(1)
    end
end

main()