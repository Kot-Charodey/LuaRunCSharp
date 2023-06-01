gameplay={}

gameplay.types={
    --игрок vs пк
    function(game_window)
        local sides = {"O", "X"}
        local side_image={
            ["O"] = game_window.o_image,
            ["X"] = game_window.x_image
        }

        local result = util:MessageBox("Играть за X?","X или O?",MessageBoxButton.YesNo)
            
        if result == MessageBoxResult.Yes then
            pc_side = sides[1]
        else
            pc_side = sides[2]
        end
        
        local user_side
        if pc_side == "O" then
            user_side = "X"
        else
            user_side = "O"
        end

        local text = "пк vs игрок\nвы играте: "..user_side.."\n"
        if pc_side == "X" then
            game_window.textBlock.Text = text .. "(пк ходит первый)"
        else
            game_window.textBlock.Text = text .. "(вы ходите первый)"
        end

        local canUserSet = true

        --пк делает первый ход
        if pc_side == "X" then
            canUserSet = false
            util:SimpleTimer(1, function ()
                local size = #game_window.world + 1
                size = math.floor(size/2)
                local info = game_window.world[size][size]
                info.set = pc_side
                util:SetImage(info.wpf.imageB, side_image[pc_side])
                canUserSet = true
                game_window.textBlock.Text = text .. "\nваш ход"
            end)
        end

        function game_window:BoxClick(x,y)
            if game.CanSet(self.world,x,y) and canUserSet then
                wpf:PlaySound("click.wav")
            
                local info = self.world[x][y]
            
                info.set = user_side
                util:SetImage(info.wpf.imageB,side_image[user_side])
            
                if game.IsWin(self.world) == user_side then
                    canUserSet = false
                    util:SimpleTimer(1,function()
                        util:MessageBox("Вы победили!")
                        self:Close()
                    end)
                    return
                end

                if game.IsWin(self.world) == pc_side then
                    canUserSet = false
                    util:SimpleTimer(1,function()
                        util:MessageBox("Вы проиграли!")
                        self:Close()
                    end)
                    return
                end

                if game.IsDraw(self.world) then
                    canUserSet = false
                    util:SimpleTimer(1,function()
                        util:MessageBox("Ничья!")
                        self:Close()
                    end)
                    return
                end

                canUserSet = false
                game_window.textBlock.Text = text .. "\nAI думает..."

                local function long_run()
                    x, y = game.ai.think(self.world, pc_side)
                    
                    local info = self.world[x][y]
                    
                    info.set = pc_side
                    util:SetImage(info.wpf.imageB,side_image[pc_side])

                    if game.IsWin(self.world) == user_side then
                        canUserSet = false
                        util:SimpleTimer(1,function()
                            util:MessageBox("Вы победили!")
                            self:Close()
                        end)
                        return
                    end
    
                    if game.IsWin(self.world) == pc_side then
                        canUserSet = false
                        util:SimpleTimer(1,function()
                            util:MessageBox("Вы проиграли!")
                            self:Close()
                        end)
                        return
                    end
                    
                    if game.IsDraw(self.world) then
                        canUserSet = false
                        util:SimpleTimer(1,function()
                            util:MessageBox("Ничья!")
                            self:Close()
                        end)
                        return
                    end
                    
                    canUserSet = true
                    game_window.textBlock.Text = text .. "\nваш ход"
                end

                --что бы программа не висла пока ИИ думает
                local c = coroutine.create(long_run)

                local function resum()
                    if not canUserSet then
                        util:SimpleTimer(0.01,function()
                            coroutine.resume(c)
                            resum()
                        end)
                    end
                end
                resum()
            end
        end 
    end,
    --игрок vs игрок
    function (game_window)
        local sides = {"O", "X"}
        local side_image={
            ["O"] = game_window.o_image,
            ["X"] = game_window.x_image
        }

        local side = sides[2]
        local canUserSet = true

        game_window.textBlock.Text = "Начинает всегда X"

        function game_window:BoxClick(x,y)
            if game.CanSet(self.world,x,y) and canUserSet then
                wpf:PlaySound("click.wav")
    
                local info = self.world[x][y]

                info.set = side
                util:SetImage(info.wpf.imageB,side_image[side])

                if side == sides[1] then
                    side = sides[2]
                else
                    side = sides[1]
                end

                game_window.textBlock.Text = "Ходит " .. side

                local win = game.IsWin(self.world)

                if win ~= " " then
                    canUserSet = false
                    util:SimpleTimer(1,function()
                        util:MessageBox("Победил "..win.."!")
                        self:Close()
                    end)
                    return
                end
                
                if game.IsDraw(self.world) then
                    canUserSet = false
                    util:SimpleTimer(1,function()
                        util:MessageBox("Ничья!")
                        self:Close()
                    end)
                    return
                end
            end
        end
    end,
    --пк vs пк
    function (game_window)
        local sides = {"O", "X"}
        local side_image={
            ["O"] = game_window.o_image,
            ["X"] = game_window.x_image
        }

        local side = sides[2]
        local winClose = false

        local closeFun = game_window.Close

        function game_window.closing()
            winClose = true
        end

        game_window.textBlock.Text = "Просто смотрим :)"

        local function run()
            if winClose then
                return
            end
            
            local delay = 2

            local function long_run()
                game_window.textBlock.Text = "Просто смотрим :)\nДумает ИИ №"

                if side == sides[1] then
                    game_window.textBlock.Text = game_window.textBlock.Text.."2..."
                else
                    game_window.textBlock.Text = game_window.textBlock.Text.."1..."
                end
                
                x, y = game.ai.think(game_window.world, side)

                game_window.textBlock.Text = "Просто смотрим :)"
                
                local info = game_window.world[x][y]
                
                info.set = side
                util:SetImage(info.wpf.imageB,side_image[side])

                if side == sides[1] then
                    side = sides[2]
                else
                    side = sides[1]
                end

                local win = game.IsWin(game_window.world)
                local draw = game.IsDraw(game_window.world)
                if win ~= " " or draw then
                    if draw then
                        game_window.textBlock.Text = "Ничья..."
                    else
                        game_window.textBlock.Text = "Победил "..win.."!"
                    end
                    util:SimpleTimer(1,function ()
                        local size = #game_window.world
                        for x=1,size do
                            for y=1,size do
                                local info = game_window.world[x][y]
                                info.set = " "
                                util:SetImage(info.wpf.imageB,nil)
                            end
                        end
                        side = sides[2]
                    end)
                    delay = 2
                end
            end

            --что бы программа не висла пока ИИ думает
            local c = coroutine.create(long_run)

            local function resum()
                if coroutine.resume(c) then
                    util:SimpleTimer(0.05,function()
                        resum()
                    end)
                else --конец хода
                    util:SimpleTimer(delay, run)
                end
            end
            resum()
        end

        util:SimpleTimer(1, run)
    end
}

function gameplay:new(game_window, type)
    self.types[type](game_window)
end