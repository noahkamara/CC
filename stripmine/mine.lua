os.loadAPI("stripmine/Schacht.lua")
os.loadAPI("stripmine/ernte_mine.lua")
os.loadAPI("basics.lua")

local function place_chest_and_fill()
    coal_stacks = 0
    turtle.select(2)
    data = turtle.getItemDetail()
    if string.match(data["name"], "chest") ~= "chest" then
        print("ERROR NO CHESTS")
        return "ERROR"
    end
    turtle.dig()
    turtle.digUp()
    basics.walkUp()
    turtle.dig()
    basics.walkDown()
    turtle.place()
    for i = 1, 16 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data ~= nil then
            if string.match(data["name"], "chest") ~= "chest" and
                string.match(data["name"], "coal") ~= "coal" and
                string.match(data["name"], "torch") ~= "torch" then
                turtle.drop()
            elseif string.match(data["name"], "coal") == "coal" then
                coal_stacks = coal_stacks + 1
            end
        end
    end
    return coal_stacks
end


local function turtle_back_to_start(length)
    fuellevel = turtle.getFuelLevel()
    if fuellevel < 10 then Schacht.refuel() end
    basics.turnLeft(2)
    for i2 = 1, length - 1 do
        if turtle.detect() then turtle.dig() end
        basics.walk()
    end
end

local function drop_coal(coal_stacks)
    c = coal_stacks
    for i = 16, 1, -1 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data ~= nil then
            if string.match(data["name"], ":coal") == ":coal" and c > 2 then
                c = c - 1
                turtle.drop()
            end
        end
    end
end

function chest()
    basics.turnRight()
    coal_stacks = place_chest_and_fill()
    drop_coal(coal_stacks)
    basics.turnLeft()
    basics.walk()
end

local function turtle_back_to_top(schaechte, y_koordinate)
    fuellevel = turtle.getFuelLevel()
    if fuellevel < 10 then Schacht.refuel() end
    basics.turnLeft()
    basics.turnLeft()
    basics.walkUp()
    for i = 1, schaechte * 4 - 1 do basics.walk() end

    for i = 1, y_koordinate - 6 do basics.walkUp() end
end

print(
    "Wenn der erste Block der Abgebaut wird kein cobblestone ist, lege cobbelston in slot1; Tiefe der Seitenschächte: ")
length = tonumber(read())

print("Anzahl Seitenschächte pro Seite:")
local schaechte = tonumber(read())

local ammount_chests = (schaechte * 2)
print("Lege " .. ammount_chests .. " Kisten in Slot 2")

local amount_torches = math.floor(length + 5 / 10)
print("Lege " .. amount_torches .. " Fackeln in slot 16")

print("y-koordinat:")
local y_koordinate = tonumber(read())

-- print("Anzahl der Ebenen:")
-- local ebene = tonumber(read())

-- runter zur mine
for i = 1, y_koordinate - 5 do basics.walkDown() end

'''turtle nummer x von y = '''

-- in der mine
for i = 1, schaechte do

    '''if (i - x) / y == 0 then '''
    basics.turnLeft()
    Schacht.schacht(length)
    turtle_back_to_start(length)
    chest()
    Schacht.schacht(length)
    turtle_back_to_start(length)
    chest()
    basics.turnRight()

    for i = 1, 4 do
        turtle.dig()
        basics.walk()
                --geplant :wenn bei walk turtle trifft dann hoch, warten und wieder runter und weiter
        turtle.digUp()
        -- if i == 1 then
        --     turtle.select(16)
        --     turtle.placeUp()
        -- end
    end
end

turtle_back_to_top(schaechte, y_koordinate)

basics.walk()

coal_stacks, mine_empty = ernte_mine.drop_in_storage()
drop_coal(coal_stacks)

basics.turnLeft(2)


ernte_mine.ernte(schaechte, y_koordinate)
