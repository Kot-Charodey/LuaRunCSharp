--создаёт окно выбора режима
--  size - размер поля (1-3 [3-5]) 
function game_window:Initialize(size)
    --изображения
    game_window.box_image = wpf:ResImage("Box.png")
    game_window.x_image = wpf:ResImage("X.png")
    game_window.o_image = wpf:ResImage("O.png")

    --размер поля
    local grid_size = 2+size
    --размер клетки
    local box_size = 50
    --сколько занимает игровое поле
    local place_size = (box_size + 6) * grid_size + 50


    --окно
    self.window = window:new("OxO",place_size+125,place_size)
    self.window.ResizeMode = ResizeMode.NoResize

    self.window.Closing:Add(function(sender,e) 
        self:Closing(sender,e)
    end)

    --контейнер для элементов
    local panel = wpf:StackPanel()
    self.window.Content = panel

    self.textBlock = wpf:textBlock()
    self.textBlock.Height = 100
    self.textBlock.Text = ""
    self.textBlock.Margin = wpf:Thickness(15)
    self.textBlock.FontSize = 15
    self.textBlock.TextAlignment = TextAlignment.Center
    panel.Children:Add(self.textBlock)

    --создаёт ячейку поля
    local function addBox(element,x,y)
        local info = {}
        local box = wpf:Grid()
        box.Margin = wpf:Thickness(3)
        box.Height = box_size
        box.Width = box_size
        
        info.imageA = wpf:Image()
        util:SetImage(info.imageA, self.box_image)
        box.Children:Add(info.imageA)

        info.imageB = wpf:Image()
        box.Children:Add(info.imageB)

        box.MouseDown:Add(function ()
            self:BoxClick(x,y)
        end)

        box.MouseEnter:Add(function ()
            self:MouseEnter(x,y)
        end)

        box.MouseLeave:Add(function ()
            self:MouseLeave(x,y)
        end)

        element.Children:Add(box)
        info.root = box
        return info
    end

    --поле
    self.world = {}
    x_panel = wpf:StackPanelH()
    x_panel.Margin = wpf:Thickness(15,0,0,0)
    panel.Children:Add(x_panel)

    for x=1,grid_size do
        self.world[x] = {}
        y_panel = wpf:StackPanel()
        x_panel.Children:Add(y_panel)

        for y=1,grid_size do
            local item = {}
            item.wpf = addBox(y_panel,x,y)
            item.set = " " -- должно хранить ячейку: " " или "X" или "O"
            self.world[x][y] = item
        end
    end

end