--логика выбора режима (размера поля)


--событие закрытия окна
function game_window:Closing(sender, e)
    wpf:PlaySound("click.wav")

    if game_window.closing ~= nil then
        game_window.closing()
    end

    main_window:Show()
end

function game_window:MouseEnter(x,y)
    wpf:PlaySound("mouse_enter.wav")

    local info = self.world[x][y]
    
    info.wpf.root.Margin = wpf:Thickness(0)
    info.wpf.root.Height = 56
    info.wpf.root.Width = 56
end

function game_window:MouseLeave(x,y)
    local info = self.world[x][y]
    info.wpf.root.Margin = wpf:Thickness(3)
    info.wpf.root.Height = 50
    info.wpf.root.Width = 50
end

--показать окно
--  size - размер поля (1-3 [3-5]) 
--  type - режим
--            1 - игрок vs пк
--            2 - игрок vs игрок
--            3 - пк    vs пк
function game_window:Show(size,type)
    self:Initialize(size)
    gameplay:new(self,type)
    self.window:Show()
end

--закрыть окно
function game_window:Close()
    self.window:Close()
end