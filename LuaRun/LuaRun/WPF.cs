using System;
using System.Collections.Generic;
using System.IO;
using System.Media;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

namespace LuaRun
{
    /// <summary>
    /// Позволяет создавать wpf элементы из lua
    /// </summary>
    internal class WPF
    {
        public Window Window()
        {
            return new Window();
        }

        public Grid Grid()
        {
            return new Grid();
        }

        public TextBlock TextBlock()
        {
            return new TextBlock();
        }

        public Button Button()
        {
            return new Button();
        }

        public Separator Separator()
        {
            return new Separator();
        }

        public StackPanel StackPanel()
        {
            return new StackPanel();
        }

        public StackPanel StackPanelH()
        {
            return new StackPanel() { Orientation = Orientation.Horizontal };
        }

        public ScrollViewer ScrollViewer()
        {
            return new ScrollViewer();
        }

        public Image Image()
        {
            return new Image();
        }

        public BitmapImage ResImage(string path)
        {
            path = $"{Directory.GetCurrentDirectory()}/Resources/{path}";
            return new BitmapImage(new Uri(path));
        }

        public Thickness Thickness(double size)
        {
            return new Thickness(size);
        }

        public Thickness Thickness(double left, double top, double right, double bottom)
        {
            return new Thickness(left, top, right, bottom);
        }

        private static readonly Dictionary<string, SoundPlayer> Sounds = new Dictionary<string, SoundPlayer>();

        public void PlaySound(string path)
        {
            path = $"{Directory.GetCurrentDirectory()}/Resources/{path}";
            if(!Sounds.TryGetValue(path, out SoundPlayer soundPlayer))
            {
                soundPlayer = new SoundPlayer(path);
                Sounds.Add(path, soundPlayer);
            }

            soundPlayer.Play();
        }
    }
}
