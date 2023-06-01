window={
    --позиция окна (что бы не скакали по всему экрану)
    pos_left = nil,
    pos_top = nil,
}

--создаёт новое wpf окно
function window:new(title,height,width)
    local win = wpf:Window()
    win.Icon = wpf:ResImage("Icon.png")
    win.Title = title
    win.Height = height
    win.Width = width

    if self.pos_left and self.pos_top then
        win.Left = self.pos_left
        win.Top = self.pos_top
    end
    
    win.Closing:Add(function ()
        self.pos_left = win.Left
        self.pos_top = win.Top
    end)
    return win
end