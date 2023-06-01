--начало программы (c# запускает именно этот файл)
math.randomseed(os.clock()/1000)

util:Include("wpf\\window.lua")
util:Include("game_logic\\init.lua")

util:Include("main_window\\init.lua")
util:Include("mode_window\\init.lua")
util:Include("game_window\\init.lua")


main_window:Show()