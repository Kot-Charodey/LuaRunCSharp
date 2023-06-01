--логика выбора режима (размера поля)


--событие закрытия окна
function mode_window:Closing(sender, e)
    if self.closeType ~= 1 then
        wpf:PlaySound("click.wav")
        main_window:Show()
    end
end

--если нажата любая кнопка
--  button_index - номер кнопки, которая была нажата
function mode_window:ButtonClick(button_index)
    wpf:PlaySound("click.wav")
    self.closeType = 1
    self:Close()
    game_window:Show(button_index,self.type)
end

function mode_window:MouseEnter()
    wpf:PlaySound("mouse_enter.wav")
end

--показать окно
function mode_window:Show(type)
    self.closeType = 0
    self:Initialize()
    self.type = type
    self.window:Show()
end

--закрыть окно
function mode_window:Close()
    self.window:Close()
end