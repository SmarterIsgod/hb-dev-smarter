using System;
using System.Collections.Generic;
using System.Linq;
using Styx;
using Styx.Helpers;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace ForceLoot
{
    public class ForceLoot : HBPlugin
    {
        private WaitTimer lootTimer = new WaitTimer(new TimeSpan(0,0,0,5));
        public override void Pulse()
        {
            //protected List<> WoWUnit> AggroUnits { get { return ObjectManager.GetObjectsOfType<WoWUnit>(true, false).Where(o => o.IsTargetingMeOrPet || (o.TaggedByMe && o.IsAlive)).OrderBy(o => o.DistanceSqr).ToList(); } }
            if (lootTimer.IsFinished)
            {
                List<WoWUnit> lootableUnits =
                    ObjectManager.GetObjectsOfType<WoWUnit>().Where(o => o.CanLoot && (o.Distance <= o.InteractRange)).
                        ToList();

                foreach (var unit in lootableUnits)
                {
                    unit.Interact();
                    Styx.BotEvents.Player.FireMobLooted(unit);
                }
                lootTimer.Reset();
            }

        }

        public override string Name { get { return "ForceLoot"; }}

        public override string Author { get { return "Smarter"; }}

        public override Version Version { get { return new Version(0, 0, 1, 0); }}

        public override void Initialize()
        {
            lootTimer.Reset();
        }
    }
}
