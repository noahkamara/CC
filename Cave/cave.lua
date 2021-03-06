
os.loadAPI("basics.lua")

-- function refuel()
--     for i = 1, 16 do
--         local data = turtle.getItemDetail(i)
--         if data and string.match(data['name'], "coal") then
--             turtle.select(i)
--             turtle.refuel(15)
--             return true
--         end
--     end
--     return false
-- end

-- local function basics.walk()
--     local success = false
--     while not success do
--         turtle.dig()
--         success = turtle.forward()
--     end
-- end

-- local function basics.walkUp()
--     local success = false
--     while not success do
--         turtle.digUp()
--         success = turtle.up()
--     end
-- end

-- local function basics.walkDown()
--     local success = false
--     while not success do
--         turtle.digDown()
--         success = turtle.down()
--     end
-- end

function find_item(item_name)
    -- findet ersten Slot des strings "item_name" und waehlt ihn aus

    for i = 1, 16 do
        local data = turtle.getItemDetail(i)
        if data and string.match(data['name'], item_name) == item_name then
            turtle.select(i)
            return i
        end
        return false
    end
end

function fix_ceiling(decke_rep)
    if decke_rep then
        if not turtle.detectUp() then
            find_item("cobble")
            for i = 1, 2 do basics.walkUp() end
            for i = 1, 2 do
                turtle.placeUp()
                basics.walkDown()
            end
            turtle.placeUp()
            turtle.select(1)
        end
    end
end

function fix_wall(weande_rep)
    if weande_rep then
        -- basics.turnLeft()
        -- basics.turnLeft()
        if not turtle.detect() then
            find_item("cobble")
            turtle.place()
        end
        turtle.select(1)
        -- basics.turnLeft()
        -- basics.turnLeft()
    end
end

function find_and_fix_front_or_back_wall(actuelle_hoehe, actuelle_tiefe,
                                         max_tiefe, weande_rep)
    if actuelle_tiefe == 1 and front_wall then
        if actuelle_hoehe % 2 == 0 then
            basics.turnRight()
            fix_wall(weande_rep)
            basics.turnLeft()
        elseif actuelle_hoehe % 2 ~= 0 then
            basics.turnLeft()
            fix_wall(weande_rep)
            basics.turnRight()
        end
    elseif actuelle_tiefe == max_tiefe then
        if (actuelle_hoehe + max_tiefe) % 2 ~= 0 then -- (actuelle_hoehe % 2 == 0  and max_tiefe % 2 ~= 0) or (actuelle_hoehe % 2 ~= 0  and max_tiefe % 2 == 0)   then
            basics.turnLeft()
            fix_wall(weande_rep)
            basics.turnRight()
        elseif (actuelle_hoehe + max_tiefe) % 2 == 0 then -- (actuelle_hoehe % 2 ~= 0  and max_tiefe % 2 ~= 0) or (actuelle_hoehe % 2 == 0  and max_tiefe % 2 == 0)   then
            basics.turnRight()
            fix_wall(weande_rep)
            basics.turnLeft()
        end
    end
end

function dig(hoehe, breite, tief, weande_rep, decke_rep)
    -- get to startingposition
    fuellevel = turtle.getFuelLevel()
    if fuellevel < 20 then refuel() end
    basics.turnRight()
    for i = 1, math.floor(breite / 2) do basics.walk() end
    for i = 2, hoehe do basics.walkUp() end
    basics.turnLeft()
    basics.turnLeft()
    -- start
    for t = 1, tiefe do
        -- print("schleife tiefe")

        basics.turnLeft()
        basics.turnLeft()

        fix_wall(weande_rep)

        basics.turnLeft()
        basics.turnLeft()
        for h = 1, hoehe do
            -- print("schleife hoehe")
            for b = 1, breite do
                -- print("schleife breite")
                find_and_fix_front_or_back_wall(h, t, tiefe, weande_rep)
                if h == 1 then fix_ceiling(decke_rep) end
                basics.walk()
                fuellevel = turtle.getFuelLevel()
                if fuellevel < 10 then refuel() end
            end
            find_and_fix_front_or_back_wall(h, t, tiefe, weande_rep)
            if h == 1 then fix_ceiling(decke_rep) end
            fix_wall(weande_rep)

            if h < hoehe then basics.walkDown() end
            fix_wall(weande_rep)
            basics.turnLeft()
            basics.turnLeft()
        end

        for x = 2, hoehe do basics.walkUp() end
        if t < tiefe then
            if t % 2 ~= 0 and hoehe % 2 ~= 0 then
                basics.turnLeft()
                basics.walk()
                basics.turnRight()
            else
                basics.turnRight()
                basics.walk()
                basics.turnLeft()
            end
        end
    end
    -- back to starting position
    -- fehlt
end

print("hoehe: ")
hoehe = tonumber(read())

print("breite: ")
breite = tonumber(read()) - 1

print("tiefe: ")
tiefe = tonumber(read())

print("Wenn wände gesetzt oder ergänzt werden sollen enter sonst 1:")
waende = tonumber(read())
if waende == 1 then
    weande_rep = false
else
    weande_rep = true
end

print("Wenn die Decke gesetzt oder ergänzt werden sollen enter sonst 1:")
decke = tonumber(read())
if decke == 1 then
    decke_rep = false
else
    decke_rep = true
end

print(
    "Wenn die vordere Mauer gesetzt oder ergänzt werden sollen enter sonst 1:")
decke = tonumber(read())
if decke == 1 then
    front_wall = false
else
    front_wall = true
end

dig(hoehe, breite, tiefe, weande_rep, decke_rep)
