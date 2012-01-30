using System;
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
        private Composite CreatePullBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CheckAndClearTargetWhenAggro,

                        new DecoratorEx(ret => CT == null || !CT.IsValid,
                            new ActionIdle()),

                        new DecoratorEx(ret => !Me.IsSafelyFacing(CT),
                            new Action(delegate
                            {
                                WoWMovement.MoveStop();
                                CT.Face();
                                Thread.Sleep(100);
                                return RunStatus.Success;
                            })),

                        new Switch<WoWClass>(r => Me.Class,
                            new SwitchArgument<WoWClass>(DeathKnightPullBehavior, WoWClass.DeathKnight),
                            new SwitchArgument<WoWClass>(DruidPullBehavior, WoWClass.Druid),
                            new SwitchArgument<WoWClass>(HunterPullBehavior, WoWClass.Hunter),
                            new SwitchArgument<WoWClass>(MagePullBehavior, WoWClass.Mage),
                            new SwitchArgument<WoWClass>(PaladinPullBehavior, WoWClass.Paladin),
                            new SwitchArgument<WoWClass>(PriestPullBehavior, WoWClass.Priest),
                            new SwitchArgument<WoWClass>(RoguePullBehavior, WoWClass.Rogue),
                            new SwitchArgument<WoWClass>(ShamanPullBehavior, WoWClass.Shaman),
                            new SwitchArgument<WoWClass>(WarlockPullBehavior, WoWClass.Warlock),
                            new SwitchArgument<WoWClass>(WarriorPullBehavior, WoWClass.Warrior)),
                            
                        CombatBehavior);
            }
        }


        #region DeathKnight Pull Behavior

        private Composite DeathKnightPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Druid Pull Behavior

        private Composite DruidPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Hunter Pull Behavior

        private Composite HunterPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Mage Pull Behavior

        private Composite MagePullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Paladin Pull Behavior

        private Composite PaladinPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        new DecoratorEx(ret => MyType == "tank",
                            new PrioritySelector(
                                CreateSpellCheckAndCast("Avenger's Shield")))
                        );
            }
        }

        #endregion

        #region Priest Pull Behavior

        private Composite PriestPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Rogue Pull Behavior

        private Composite RoguePullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Shaman Pull Behavior

        private Composite ShamanPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Warlock Pull Behavior

        private Composite WarlockPullBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        );
            }
        }

        #endregion

        #region Warrior Pull Behavior

        private Composite WarriorPullBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CreateSpellCheckAndCast("Charge"),
                        CreateSpellCheckAndCast("Throw",
                            ret => Me.Inventory.Equipped.Ranged != null &&
                                   Me.Inventory.Equipped.Ranged.ItemInfo.WeaponClass == WoWItemWeaponClass.Thrown),
                        CreateSpellCheckAndCast("Shoot",
                            ret => Me.Inventory.Equipped.Ranged != null &&
                                   (Me.Inventory.Equipped.Ranged.ItemInfo.WeaponClass == WoWItemWeaponClass.Bow ||
                                    Me.Inventory.Equipped.Ranged.ItemInfo.WeaponClass == WoWItemWeaponClass.Crossbow))                            );

            }
        }

        #endregion

        #region Composites

        #region CheckAndClearTargetWhenAggro

        private Composite CheckAndClearTargetWhenAggro
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => CT != null && CT.IsValid &&
                                                 Adds.Count > 0 &&
                                                 !CT.IsTargetingMeOrPet &&
                                                 CT.HealthPercent == 100 &&
                                                 !CT.Name.ToLower().Contains("dummy") &&
                                                 !Me.IsInParty,
                                new Action(delegate
                                {
                                    Thread.Sleep(250);
                                    if (Adds.Count > 0)
                                        Adds[0].Target();

                                    Thread.Sleep(100);
                                    return RunStatus.Success;
                                })));
            }
        }

        #endregion

        #endregion
    }
}