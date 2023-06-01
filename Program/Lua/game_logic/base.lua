
--выйграл ли кто либо (return: " " или "X" или "O")
function game.IsWin(world)
    --размер мира
    local w_size = #world

    for x = 1, w_size do
        local first = world[x][1].set

        if first ~= " " then
            for y = 2, w_size do
                if world[x][y].set ~= first then
                    break
                end
                if y == w_size then
                    return first
                end
            end
        end
    end

    for y = 1, w_size do
        local first = world[1][y].set

        if first ~= " " then
            for x = 2, w_size do
                if world[x][y].set ~= first then
                    break
                end
                if x == w_size then
                    return first
                end
            end
        end
    end

    local first = world[1][1].set
    if first ~= " " then
        for x_y = 2, w_size do
            if world[x_y][x_y].set ~= first then
                break
            end
            if x_y == w_size then
                return first
            end
        end
    end
    
    
    local first = world[w_size][1].set
    if first ~= " " then
        for x_y = 2, w_size do
            if world[w_size - x_y + 1][x_y].set ~= first then
                break
            end
            if x_y == w_size then
                return first
            end
        end
    end

    return " "
end

--ничья? (true/false)
function game.IsDraw(world)
    --размер мира
    local w_size = #world

    for x = 1, w_size do
        for y = 1, w_size do
            if world[x][y].set  == " " then
                return false
            end
        end
    end

    return true
end

--возможно ли установить тут X или O
function game.CanSet(world,x,y)
    return world[x][y].set == " "
end