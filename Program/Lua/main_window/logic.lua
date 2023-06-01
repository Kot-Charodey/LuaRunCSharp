--логика главного окна

main_window:Initialize()

--спрашиваем - точно ли хотим закрыть программу
function main_window:TryExit()
    local result = util:MessageBox("Всё?","Точно?",MessageBoxButton.YesNo)
            
    return result == MessageBoxResult.Yes
end

--событие закрытия окна
function main_window:Closing(sender, e)
    e.Cancel = not self:TryExit()
end

--если нажата любая кнопка
--  button_index - номер кнопки, которая была нажата
function main_window:ButtonClick(button_index)
    wpf:PlaySound("click.wav")
    swith = {
        --"Игрок VS Компьютер"
        function ()
            self:Hide()
            mode_window:Show(1)
        end,
        --"Игрок VS Игрок"
        function ()
            self:Hide()
            mode_window:Show(2)
        end,
        --"Компьютер VS Компьютера"
        function ()
            self:Hide()
            mode_window:Show(3)
        end,
        --"Выход"
        function ()
            self:Close()
        end,
    }
    swith[button_index]()
end

function main_window:MouseEnter()
    wpf:PlaySound("mouse_enter.wav")
end

--показать окно
function main_window:Show()
    self.window:Show()
end

--скрыть окно
function main_window:Hide()
    self.window:Hide()
end

--закрыть окно (вызывать при закрытии приложения)
function main_window:Close()
    self.window:Close()
end