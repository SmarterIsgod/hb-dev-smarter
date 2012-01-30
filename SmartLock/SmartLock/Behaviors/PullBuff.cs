using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;
using Styx;
using Styx.Combat.CombatRoutine;
using Styx.Logic;
using Styx.Logic.POI;
using Styx.Helpers;
using Styx.Logic.Combat;
using Styx.Logic.Pathing;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

using TreeSharp;
using Action = TreeSharp.Action;

namespace Ensemble
{
    public partial class Ensemble : CombatRoutine
    {
        private Composite CreatePullBuffBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                            new Switch<WoWClass>(r => Me.Class,
                                new SwitchArgument<WoWClass>(DeathKnightPullBuffBehavior, WoWClass.DeathKnight),
                                new SwitchArgument<WoWClass>(DruidPullBuffBehavior, WoWClass.Druid),
                                new SwitchArgument<WoWClass>(HunterPullBuffBehavior, WoWClass.Hunter),
                                new SwitchArgument<WoWClass>(MagePullBuffBehavior, WoWClass.Mage),
                                new SwitchArgument<WoWClass>(PaladinPullBuffBehavior, WoWClass.Paladin),
                                new SwitchArgument<WoWClass>(PriestPullBuffBehavior, WoWClass.Priest),
                                new SwitchArgument<WoWClass>(RoguePullBuffBehavior, WoWClass.Rogue),
                                new SwitchArgument<WoWClass>(ShamanPullBuffBehavior, WoWClass.Shaman),
                                new SwitchArgument<WoWClass>(WarlockPullBuffBehavior, WoWClass.Warlock),
                                new SwitchArgument<WoWClass>(WarriorPullBuffBehavior, WoWClass.Warrior))
                    );
            }
        }

        #region DeathKnight Pull Buff Behavior

        private Composite DeathKnightPullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Druid Pull Buff Behavior

        private Composite DruidPullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Hunter Pull Buff Behavior

        private Composite HunterPullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Mage Pull Buff Behavior

        private Composite MagePullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Paladin Pull Buff Behavior

        private Composite PaladinPullBuffBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        new DecoratorEx(ret => MyType == "tank",
                            CreateBuffCheckAndCast("Divine Plea"))
                        );
            }
        }

        #endregion

        #region Priest Pull Buff Behavior

        private Composite PriestPullBuffBehavior
        {
            get
            {
                return new PrioritySelector(
                            CreateBuffCheckAndCast("Power Word: Shield", ret => Instance.Settings.UsePullPWS));
            }
        }

        #endregion

        #region Rogue Pull Buff Behavior

        private Composite RoguePullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Shaman Pull Buff Behavior

        private Composite ShamanPullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Warlock Pull Buff Behavior

        private Composite WarlockPullBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Warrior Pull Buff Behavior

        private Composite WarriorPullBuffBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CreateBuffCheckAndCast("Commanding Shout", ret => MyType == "tank" &&
                                                                          !Me.HasAura("Qiraji Fortitude") &&
                                                                          !Me.HasAura("Power Word: Fortitude") &&
                                                                          !Me.HasAura("Blood Pact")),
                        CreateBuffCheckAndCast("Battle Shout", ret => (!SpellManager.HasSpell("Commanding Shout") ||
                                                                      MyType != "tank") &&
                                                                      !Me.HasAura("Horn of the Winter") &&
                                                                      !Me.HasAura("Roar of Courage") &&
                                                                      !Me.HasAura("Strength of Earth Totem")));
            }
        }

        #endregion
    }
}