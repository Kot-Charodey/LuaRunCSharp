--создаёт главное окно

function main_window:Initialize()
    --окно
    self.window = window:new("Меню",250,300)
    self.window.ResizeMode = ResizeMode.NoResize

    self.window.Closing:Add(function(sender,e) 
        self:Closing(sender,e)
    end)

    --контейнер для элементов
    local panel = wpf:StackPanel()
    self.window.Content = panel

    --текст над кнопками
    local textBlock = wpf:TextBlock()
    textBlock.Text = "Что делать будем?"
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
    local buttons_text={"Игрок VS Компьютер","Игрок VS Игрок","Компьютер VS Компьютера","Выход"}
    for i = 1,4 do

        if i == 1 or i==4 then
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