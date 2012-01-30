using System;
using System.Collections.Generic;
using Styx;
using Styx.Helpers;
using Styx.Logic.Combat;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace AquaticForm
{
    public class AquaticForm : HBPlugin
    {
        public List<string> Glyphs = new List<string>();
        private bool _canRun = true;
        private bool _firstPulse = true;


        private static LocalPlayer Me
        {
            get { return StyxWoW.Me; }
        }

        public override string Name
        {
            get { return "Aquatic Form"; }
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
                BuildGlyphList();
                if (Glyphs.Contains("Aquatic Form"))
                {
                    CharacterSettings.Instance.UseRandomMount = false;
                    CharacterSettings.Instance.MountName = "Aquatic Form";
                }
                else
                {
                    _canRun = false;
                }
                _firstPulse = false;
            }

            if (!_canRun) return;

            if (!Me.IsSwimming || Me.Mounted) return;

            if (!SpellManager.CanCast("Aquatic Form")) return;

            WoWMovement.MoveStop();
            SpellManager.Cast("Aquatic Form");
        }

        private void BuildGlyphList()
        {
            using (new FrameLock())
            {
                var glyphCount = Lua.GetReturnVal<int>("return GetNumGlyphSockets()", 0);
                if (glyphCount != 0)
                {
                    for (int i = 1; i <= glyphCount; i++)
                    {
                        List<string> glyphInfo = Lua.GetReturnValues(String.Format("return GetGlyphSocketInfo({0})", i));

                        if (glyphInfo != null && glyphInfo[3] != "nil" && !string.IsNullOrEmpty(glyphInfo[3]))
                        {
                            Glyphs.Add(WoWSpell.FromId(int.Parse(glyphInfo[3])).Name.Replace("Glyph of ", ""));
                        }
                    }
                }
            }
        }
    }
}