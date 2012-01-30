using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using Styx.Helpers;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace Emoter
{
    public class Emoter : HBPlugin
    {
        private readonly Dictionary<WoWUnit, string> _chatQueue = new Dictionary<WoWUnit, string>();
        private readonly WaitTimer _chatTimer = WaitTimer.OneSecond;
        private readonly Dictionary<string, string> _emoteDatabase = new Dictionary<string, string>();
        private readonly WaitTimer _unitListRefresh = WaitTimer.FiveSeconds;
        private bool _firstPulse = true;


        public override string Name
        {
            get { return "Emoter"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0, 0, 1, 0); }
        }

        public override void Pulse()
        {
            if (_firstPulse)
            {
                var rdr = new StreamReader(Application.StartupPath + "\\Plugins\\Emoter\\Config.txt");
                while (!rdr.EndOfStream)
                {
                    string line = rdr.ReadLine();
                    if (line != null)
                    {
                        string[] splt = line.Split(' ');
                        _emoteDatabase.Add(splt[0], splt[1]);
                    }
                }

                _firstPulse = false;
            }

            if (_unitListRefresh.IsFinished)
            {
                List<WoWUnit> unitList =
                    ObjectManager.GetObjectsOfType<WoWUnit>().FindAll(o => _emoteDatabase.Keys.Contains(o.Name));
                if (unitList.Count > 0)
                {
                    foreach (WoWUnit woWUnit in unitList)
                    {
                        _chatQueue.Add(woWUnit, _emoteDatabase[woWUnit.Name]);
                    }
                }
                _unitListRefresh.Reset();
            }

            if (_chatTimer.IsFinished)
            {
                WoWUnit currentVictim = _chatQueue.Keys.OrderBy(o => o.Distance).First();
                DoEmote(_chatQueue[currentVictim], currentVictim);
                _emoteDatabase.Remove(currentVictim.Name);
                _chatQueue.Remove(currentVictim);
                _chatTimer.Reset();
            }
        }

        private static void DoEmote(string emotion, WoWUnit target)
        {
            target.Target();
            Lua.DoString("DoEmote(\"" + emotion + "\", \"target\");");
        }
    }
}