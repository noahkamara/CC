
local function refuel()
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data and string.match(data['name'], "coal") then
            turtle.select(i)
            turtle.refuel(15)
            return true
        end
    end
    return false
end

local function walk()
    local success = turtle.forward()
    while not success do
        print("CANT MOVE FORWARD")
        success = turtle.forward()
    end
end

local function plantSeed()
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data and string.match(data['name'], "minecraft:wheat") then
            turtle.select(i)
            turtle.placeDown()
            return
        end
    end
    error("NO SEEDS IN INVENTORY")
end


local function checkAndGo()
    local success, data = turtle.inspectDown()
    if success then
        if data["state"]["age"] == 7 then
            turtle.digDown()
            plantSeed()
        end
    else
        turtle.digDown()
        plantSeed()
    end
    walk()
end



local function run(size)
    walk()

    for x=1,size do
        
        for y=1,size-1 do
            print("X: ", x, "Y: ", y)
            checkAndGo()
        end
        if x < size then
            if (x % 2 == 1) then
                turtle.turnRight()
                checkAndGo()
                turtle.turnRight()
            else
                turtle.turnLeft()
                checkAndGo()
                turtle.turnLeft()
            end
        end
    end
    turtle.turnRight()

    for y=1, size-1 do
        walk()
    end

    turtle.turnRight()
    turtle.back()
end

print("FIELD SIZE: ")
local size = tonumber(read())

while true do
    refuel()
    run(size)
    os.sleep(60)
end
