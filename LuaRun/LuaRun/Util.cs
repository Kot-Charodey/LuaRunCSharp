using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using System.Windows.Threading;
using LuaInterface;

namespace LuaRun
{
    /// <summary>
    /// Доп функции для lua
    /// </summary>
    internal class Util
    {
        private readonly Lua MLua;
        private readonly int PathLength;
        private readonly Program Program;

        public Util(Lua lua,Program program)
        {
            Program = program;
            MLua = lua;
            MLua["_UtilIncludePath"] = Directory.GetCurrentDirectory() + "\\Lua";
            PathLength = Directory.GetCurrentDirectory().Length + 1;
        }

        public void MessageBox(object ob)
        {
            System.Windows.MessageBox.Show(ob.ToString());
        }

        public MessageBoxResult MessageBox(string text, string caption, MessageBoxButton button)
        {
            return System.Windows.MessageBox.Show(text, caption, button);
        }

        /// <summary>
        /// Подключает указанный файл + любой файл подключенный из этого должен указывать путь относительно себя
        /// </summary>
        /// <param name="name">путь до файла относительно папки MLua</param>
        public void Include(string name)
        {
            string lastDir = (string)MLua["_UtilIncludePath"] ?? "";
            var fileInfo = new FileInfo($"{lastDir}\\{name}");

            MLua["_UtilIncludePath"] = fileInfo.Directory.FullName;
            string fileName = fileInfo.FullName.Remove(0, PathLength);
            MLua.DoString(File.ReadAllText(fileInfo.FullName), fileName);

            MLua["_UtilIncludePath"] = lastDir;
        }

        public void SetImage(Image image,BitmapImage bitmap)
        {
            image.Source = bitmap;
        }

        /// <summary>
        /// одноразовый таймер
        /// </summary>
        /// <param name="time">время в секундах</param>
        /// <param name="action">что должно выполниться после того как таймер сработает</param>
        public void SimpleTimer(double time,Action action)
        {
            Task.Run(() =>
            {
                var st = new Stopwatch();
                st.Start();
                while (st.Elapsed.TotalSeconds < time) //не доверяю await Task.Delay()
                    Thread.Sleep(100);
                Program.Dispatcher.Invoke(action);//выполнить в основном потоке иначе lua упадёт
            });
        }
    }
}
