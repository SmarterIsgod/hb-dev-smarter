using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using Styx;
using Styx.Helpers;
using Styx.Logic.Combat;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace Lockbox
{
    public class LockboxPicker : HBPlugin
    {
        private readonly WaitTimer _lockPickTimer = WaitTimer.FiveSeconds;
        private readonly LocalPlayer _me = StyxWoW.Me;
        private readonly int _lockPickingSkill = StyxWoW.Me.Level*5;
        
        #region Lockboxes
        private readonly Dictionary<uint, int> _lockBoxes = new Dictionary<uint, int>();
        public LockboxPicker()
        {
            _lockBoxes.Add(4632, 1); //Ornate Bronze Lockbox (Skill 1)
			_lockBoxes.Add(4633, 25); //Heavy Bronze Lockbox (Skill 25)
			_lockBoxes.Add(4634, 70); //Iron Lockbox (Skill 70)
			_lockBoxes.Add(4636, 125); //Strong Iron Lockbox (Skill 125)
			_lockBoxes.Add(4637, 175); //Steel Lockbox (Skill 175)
			_lockBoxes.Add(4638, 225); //Reinforced Steel Lockbox (Skill 225)
			_lockBoxes.Add(5758, 225); //Mithril Lockbox (Skill 225)
			_lockBoxes.Add(5759, 225); //Thorium Lockbox (Skill 225)
			_lockBoxes.Add(5760, 225); //Eternium Lockbox (Skill 225)
			_lockBoxes.Add(31952, 325); //Khorium Lockbox (Skill 325)
			_lockBoxes.Add(43622, 375); //Froststeel Lockbox (Skill 375)
			_lockBoxes.Add(43624, 400); //Titanium Lockbox (Skill 400)
			_lockBoxes.Add(45986, 400); //Tiny Titanium Lockbox (Skill 400)
			_lockBoxes.Add(68729, 425); //Elementium Lockbox (Skill 425)
            
            // The boxes you can pickpocket from mobs

			_lockBoxes.Add(16882, 1); //Battered Junkbox (Skill 1)
			_lockBoxes.Add(16883, 70); //Worn Junkbox (Skill 70)
			_lockBoxes.Add(16884, 175); //Sturdy Junkbox (Skill 175)
			_lockBoxes.Add(16885, 250); //Heavy Junkbox (Skill 250)
			_lockBoxes.Add(29569, 300); //Strong Junkbox (Skill 300)
			_lockBoxes.Add(43575, 350); //Reinforced Junkbox (Skill 350)
			_lockBoxes.Add(63349, 400); //Flame-Scarred Junkbox (Skill 400)
        }
        #endregion


        public override void Pulse()
        {
            if (_lockPickTimer.IsFinished)
            {
                if (_me.FreeNormalBagSlots >= 2)
                {
                    var lockBoxesInBag = _me.BagItems.Where(o => _lockBoxes.ContainsKey(o.Entry));
                    var unlockBoxes = lockBoxesInBag.Where(o => _lockPickingSkill >= _lockBoxes[o.Entry]);

                    if (SpellManager.CanCast(1804))
                    {
                        var item = unlockBoxes.FirstOrDefault();

                        SpellManager.Cast(1804);
                        Lua.DoString("UseItemByName(\"" + item.Name + "\")");
                        StyxWoW.SleepForLagDuration();
                        Logging.Write(Color.FromName("DarkRed"), "[Lockboxer]: Unlocking and opening a {0}.", item.Name);
                        Lua.DoString("UseItemByName(\"" + item.Name + "\")");
                        StyxWoW.SleepForLagDuration();
                    }
                }
                _lockPickTimer.Reset();
            }
        }

        public override string Name
        {
            get { return "Lockboxer"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0, 0, 1, 0); }
        }
    }
}
