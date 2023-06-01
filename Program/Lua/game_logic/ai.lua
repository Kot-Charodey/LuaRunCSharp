game.ai = {}


--вычислить наилучший ход
--  world - карта
--  side  - "X" или "O" для которого нужно принять решение
--  return координаты x y куда можно сходить
function game.ai.think(world,side)
    --размер мира
    local w_size = #world

    --копирует карту мира
    local function world_copy(world)
        local new_world = {}

        for x,v1 in ipairs(world) do
            new_world[x] = {}
            for y,v2 in ipairs(world[x]) do
                new_world[x][y] = {
                    set = world[x][y].set,
                    weight = 0
                }
            end
        end

        return new_world
    end

    --чем играет враг
    local e_side

    if side == "X" then
        e_side = "O"
    else
        e_side = "X"
    end

    --ход на 1 шаг вперёд (с победой или защитой)
    local function simple_move(world)
        
        for _, side in ipairs({side,e_side}) do
            for x = 1, w_size do
                for y = 1, w_size do
                    if game.CanSet(world,x,y) then
                        world[x][y].set = side
                        if game.IsWin(world) ~= " " then
                            world[x][y].set = " "
                            return true, x, y
                        end
                        world[x][y].set = " "
                    end
                end
            end
        end
        return false
    end

    local function get_best(world)
        local weight = -math.huge
        local b_x = 1
        local b_y = 1
        for x = 1, w_size do
            for y = 1, w_size do
                local world_weight = world[x][y].weight               --если одинаковые веса - рандом
                if game.CanSet(world,x,y) and (world_weight > weight or (world_weight == weight and math.random(1,10)>5)) then
                    b_x = x
                    b_y = y
                    weight = world_weight
                end
            end
        end

        return weight, b_x, b_y
    end

    -- следуйщий ход имеет много выйграшей?
    local function big_wins(world,side)
        local count = 0
        for x = 1, w_size do
            for y = 1, w_size do
                if game.CanSet(world,x,y) then
                    world[x][y].set = side
                    if game.IsWin(world) == side then
                        count = count + 1
                        if count > 1 then
                            world[x][y].set = " "
                            return true
                        end
                    end
                    world[x][y].set = " "
                end
            end
        end

        return count > 1
    end

    local function step(st,world,depth)
        for x = 1, w_size do
            for y = 1, w_size do
                if game.CanSet(world,x,y) then
                    --ход бота
                    world[x][y].set = side
                    local win = game.IsWin(world)
                    local done = win ~= " "
                    local isWin = win == side
                    local IsDraw = game.IsDraw(world)
                    
                    if IsDraw or done then
                        if done then
                            -- если победили
                        else
                            --тут можно добавить веса за ничью...  (по вине бота)
                        end
                    else
                        --ход противника
                        if not big_wins(world, e_side) then
                            --world[x][y].weight = world[x][y].weight - 1
                            for x2 = 1, w_size do
                                for y2 = 1, w_size do
                                    if game.CanSet(world,x2,y2) then
                                        world[x2][y2].set = e_side
                                        local win = game.IsWin(world)
                                        local done = win ~= " "
                                        local IsDraw = game.IsDraw(world)
                                        if IsDraw or done then
                                            if done then
                                                world[x][y].weight = world[x][y].weight - 1  -- если победит когда-то
                                            else
                                                -- если ничья (по вине соперника)
                                            end
                                        elseif st - 1 > 0 then
                                            --следуйщий щаг
                                            step(st - 1, world, depth + 1)
                                        else
                                            --если лимит шагов
                                        end    
                                        world[x2][y2].set = " "
                                    end
                                end
                            end
                        else
                            world[x][y].weight = world[x][y].weight * 2
                        end
                    end
                    world[x][y].set = " "
                end
            end
            if depth == 1 then
                coroutine.yield()
            end
        end

        --[[
        --для отладки (вывод весов)
        if depth == 1 then
            local s = ""
            for y = 1, w_size do
                for x = 1, w_size do
                    s = s..(world[x][y].weight or 0).."  "
                end
                s=s.."\n"
            end

            util:MessageBox(s)
        end
        ]]--

        return get_best(world)
    end

    local try, x, y = simple_move(world)

    if try then
        return x, y
    end

    coroutine.yield()

    --насколько глубоко можно просчитывать комбинации
    local free_cells = 0
    for x = 1, w_size do
        for y = 1, w_size do
            if world[x][y].set == " " then
                free_cells = free_cells + 1
            end
        end
    end

    local max_depth = math.floor(math.min(math.max(32/free_cells,1),3))
    --util:MessageBox("max depth "..max_depth)
    local new_world = world_copy(world)

    local w, x, y = step(max_depth, new_world, 1)
    return x, y
end