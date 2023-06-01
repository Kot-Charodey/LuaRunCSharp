using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using LuaInterface;

namespace LuaRun
{
    internal class Program : Application
    {
        public void Initialize()
        {
             Startup += Program_Startup;
        }

        

        private void Program_Startup(object sender, StartupEventArgs e)
        {
            Program program = (Program)sender;
            
            //запуск lua кода
            Lua lua = new Lua();
            string path = $"{Directory.GetCurrentDirectory()}/Lua/app.lua";
            
            try
            {
                lua["util"] = new Util(lua,this);
                lua["wpf"] = new WPF();

                lua.IncludeEnum(typeof(ResizeMode));
                lua.IncludeEnum(typeof(TextAlignment));
                lua.IncludeEnum(typeof(MessageBoxButton));
                lua.IncludeEnum(typeof(MessageBoxResult));
                
                lua.DoString(File.ReadAllText(path), path);
            }
            //если что то упало - скажем об этом
            catch (LuaInterface.Exceptions.LuaScriptException ex) //если ошибка в lua
            {
                MessageBox.Show("Lua error:\n" + ex.InnerException);
                program.Shutdown();
            }
            catch(Exception ex)//если что то другое
            {
                MessageBox.Show("Error:\n" + ex);
                program.Shutdown();
            }
        }

        [STAThread]
        public static void Main()
        {
            try
            {
                var application = new Program();
                application.Initialize();
                application.Run();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lua error:\n" + ex.ToString());
            }
        }
    }
}
