local r=require("robot")
function main()
    for c=1,r.count(1) do
        for i=1,3 do
            r.select(i)
            if not(r.drop(1)) then
                return
            end
        end
        os.sleep(10)
        r.select(16)
        r.suck()
        r.dropDown()
    end
end