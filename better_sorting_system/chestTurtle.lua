os.loadAPI("basics.lua")

function fillChest(count)
    break_condition = true
    while count ~= 0 and break_condition do
        for i = 2, 16 do
            turtle.select(i)
            countItemSlot = turtle.getItemCount()
            if countItemSlot > count then
                break_condition = false
                break
            end
            count = count - countItemSlot
            turtle.dropDown()
        end
        if break_condition then
            print("Error chest has less items than count")
            return 0
        end
    end
    turtle.dropDown(count)
end

cLastWalked = 0
function navigate(x, y)
    basics.walk(x)
    basics.turnRight()
    basics.walk(y)
    cLastWalked = y + x + 1
end

