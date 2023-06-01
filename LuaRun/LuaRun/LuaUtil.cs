using LuaInterface;
using System;

namespace LuaRun
{
    /// <summary>
    /// Вспомогательные функции для работы с библиотекой lua
    /// </summary>
    internal static class LuaUtil
    {
        /// <summary>
        /// Добавляет в lua перечисление из c#
        /// </summary>
        /// <param name="lua">MLua машина</param>
        /// <param name="enum">перечисление</param>
        public static void IncludeEnum(this Lua lua, Type @enum)
        {
            string name = @enum.Name;

            lua.NewTable(name);
            LuaTable table = (LuaTable)lua[name];

            foreach(var value in @enum.GetEnumValues())
            {
                string enumName = @enum.GetEnumName(value);
                table[enumName] = value;
            }
        }
    }
}
