using System.Linq;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace RaFBuddy
{
    class PriorityTargeting
    {
        public WoWUnit GetTarget()
        {
            var objList = ObjectManager.GetObjectsOfType<WoWUnit>().Where(o => o.IsAlive && o.IsValid && !o.IsFriendly);
            var targetList = objList.Select(unit => unit as PotentialTarget).ToList();
            
            foreach (var target in targetList)
            {
                if (target.IsTargetingMeOrPet)
                    target.Priority++;
                if (target.IsTargetingMyRaidMember)
                    target.Priority++;
                if (target.HealthPercent > 90)
                    target.Priority = target.Priority + 2;
            }

            targetList.OrderBy(o => o.Priority);
            return targetList.First();
        }
    }

    public class PotentialTarget : WoWUnit
    {
        /// <summary/>
        /// <param name="baseAddress">pointer for this object. </param>
        public PotentialTarget(uint baseAddress) : base(baseAddress)
        {
        }

        public double Priority { get; set; }
    }
}
