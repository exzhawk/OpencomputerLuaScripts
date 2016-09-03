local r=require("robot")
function main()
    count=r.count(1)
    for craftcycle=1,count do
        for slot=1,6 do
            r.select(slot)
            r.drop(1)
        end
        r.down()
        r.use()
        r.select(7)
        r.suckDown(1)
        os.sleep(30)
        r.up()
        r.drop(1)
        r.down()
        r.select(8)
        r.use()
        r.up()
    end
end
main()