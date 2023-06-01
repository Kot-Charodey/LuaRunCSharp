--создаёт окно выбора режима

function mode_window:Initialize()
    --окно
    self.window = window:new("Режим",200,300)
    self.window.ResizeMode = ResizeMode.NoResize

    self.window.Closing:Add(function(sender,e) 
        self:Closing(sender,e)
    end)

    --контейнер для элементов
    local panel = wpf:StackPanel()
    self.window.Content = panel

    --текст над кнопками
    local textBlock = wpf:TextBlock()
    textBlock.Text = "Размер поля:"
    textBlock.FontSize = 20
    textBlock.TextAlignment = TextAlignment.Center;
    textBlock.Margin = wpf:Thickness(15,15,15,10)
    panel.Children:Add(textBlock)

    

    --создаёт кнопку
    local function addButton(title)
        local button = wpf:Button()
        button.Content = title
        button.Margin = wpf:Thickness(15,0,15,5)

        panel.Children:Add(button)
        return button
    end

    --кнопки
    local buttons_text={"3x3","4x4","5x5"}
    for i = 1,3 do

        if i == 1 then
            local sep = wpf:Separator()
            sep.Margin = wpf:Thickness(5,0,10,5)

            panel.Children:Add(sep)
        end

        local button = addButton(buttons_text[i])
        button.Click:Add(function ()
            self:ButtonClick(i)
        end)
        
        button.MouseEnter:Add(function ()
            self:MouseEnter()
        end)
    end
end