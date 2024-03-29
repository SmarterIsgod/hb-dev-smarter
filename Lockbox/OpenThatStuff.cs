﻿
namespace OpenThatStuff
{
    using Styx;
    using Styx.Combat.CombatRoutine;
    using Styx.Helpers;
    using Styx.Logic;
    using Styx.Logic.Combat;
    using Styx.Logic.Pathing;
    using Styx.Logic.Inventory;
    using Styx.Plugins.PluginClass;
    using Styx.WoWInternals;
    using Styx.WoWInternals.WoWObjects;
    using Styx.Logic.Inventory.Frames.LootFrame;

    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Drawing;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Threading;
    using System.Windows.Forms;

    public class OpenThatStuff : HBPlugin
    {
        public override string Name { get { return "OpenThatStuff"; } }
        public override string Author { get { return "Kickazz n KaZ"; } }
        public override Version Version { get { return _version; } }
        private readonly Version _version = new Version(1, 0, 0, 0);

        private static uint[,] _data = new uint[,] { 
			{1, 67495}, // Strange Bloated Stomach
        };

        private static Stopwatch sw = new Stopwatch();

        private void log(String fmt, params object[] args)
        {
            String s = String.Format(fmt, args);
            log(Color.DarkBlue, fmt, args);
        }

        private void log(Color color, String fmt, params object[] args)
        {
            String s = String.Format(fmt, args);
            Styx.Helpers.Logging.Write(color, String.Format("[{0}]: {1}", Name, s));
        }

        public override void Pulse()
        {
            if (!sw.IsRunning)
            {
                sw.Start();
                log("Active");
            }

            if (ObjectManager.Me.Combat)
            {

                // Dismount if you're still on a mount
                if (!ObjectManager.Me.IsMoving && ObjectManager.Me.Mounted)
                    Mount.Dismount();
            }

            // Unlock and open items
            CheckInventoryItems();

            // 10 seconds pulse
            if (sw.Elapsed.TotalSeconds < 10 ||
                Battlegrounds.IsInsideBattleground ||
                ObjectManager.Me.Mounted ||
                ObjectManager.Me.Combat ||
                ObjectManager.Me.Dead)
                return;





            // Reset timer so it will all start over again in 5 seconds.
            sw.Reset();
            sw.Start();

        }

        private void CheckInventoryItems()
        {
            foreach (WoWItem item in StyxWoW.Me.BagItems)
            {
                for (int i = 0; i <= _data.GetUpperBound(0); i++)
                {
                    if (_data[i, 1] == item.Entry)
                    {
                        while (IteminBag(item.Entry))
                        {
                            String s = String.Format("UseItemByName(\"{0}\")", item.Name);
                            Lua.DoString(s);
                            StyxWoW.SleepForLagDuration();
                            
                            if (LootFrame.Instance.IsVisible)
                                Lua.DoString("for i=1,GetNumLootItems() do ConfirmLootSlot(i) LootSlot(i) end");
                        }
                    }
                }
            }
        }

        static public bool IteminBag(uint entry)
        {
            return StyxWoW.Me.BagItems.FirstOrDefault(i => i.Entry == entry) != null;
        }
    }
}
