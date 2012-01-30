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
        private Composite CreateCombatBuffBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                            new Switch<WoWClass>(r => Me.Class,
                                new SwitchArgument<WoWClass>(DeathKnightCombatBuffBehavior, WoWClass.DeathKnight),
                                new SwitchArgument<WoWClass>(DruidCombatBuffBehavior, WoWClass.Druid),
                                new SwitchArgument<WoWClass>(HunterCombatBuffBehavior, WoWClass.Hunter),
                                new SwitchArgument<WoWClass>(MageCombatBuffBehavior, WoWClass.Mage),
                                new SwitchArgument<WoWClass>(PaladinCombatBuffBehavior, WoWClass.Paladin),
                                new SwitchArgument<WoWClass>(PriestCombatBuffBehavior, WoWClass.Priest),
                                new SwitchArgument<WoWClass>(RogueCombatBuffBehavior, WoWClass.Rogue),
                                new SwitchArgument<WoWClass>(ShamanCombatBuffBehavior, WoWClass.Shaman),
                                new SwitchArgument<WoWClass>(WarlockCombatBuffBehavior, WoWClass.Warlock),
                                new SwitchArgument<WoWClass>(WarriorCombatBuffBehavior, WoWClass.Warrior)
                        ));
            }
        }

        #region DeathKnight Combat Buff Behavior

        private Composite DeathKnightCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Druid Combat Buff Behavior

        private Composite DruidCombatBuffBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        CreateBuffCheckAndCast("Tree of Life",
                            ret => Me.IsInParty && !IsInBattleground && Me.PartyMembers.Count(p => p.IsAlive && Instance.Settings.DruidUseTreeOfLife && p.HealthPercent < Instance.Settings.DruidTreeOfLifeHealth) + (Me.IsAlive && Me.HealthPercent < Instance.Settings.DruidTreeOfLifeHealth ? 1 : 0) >= Instance.Settings.DruidTreeOfLifeCount),
                        CreateBuffCheckAndCast("Tree of Life",
                            ret => Me.IsInRaid && IsInBattleground && Me.RaidMembers.Count(p => p.IsAlive && Instance.Settings.DruidUsePvPTreeOfLife && p.HealthPercent < Instance.Settings.DruidPvPTreeOfLifeHealth) + (Me.IsAlive && Me.HealthPercent < Instance.Settings.DruidPvPTreeOfLifeHealth ? 1 : 0) >= Instance.Settings.DruidPvPTreeOfLifeCount),                        
                        CreateBuffCheckAndCast("Innervate", ret => Instance.Settings.DruidUseInnervate && Me.ManaPercent <= Instance.Settings.DruidInnervateMana),
                        CreateBuffCheckAndCast("Barkskin", ret => Instance.Settings.DruidUseBarkskin && Me.HealthPercent <= Instance.Settings.DruidBarkskinHealth)
                    );
            }
        }

        #endregion

        #region Hunter Combat Buff Behavior

        private Composite HunterCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Mage Combat Buff Behavior

        private Composite MageCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Paladin Combat Buff Behavior

        private Composite PaladinCombatBuffBehavior
        {
            get
            {
                return 
                    new PrioritySelector(
                        new NeedToUseHand(new UseHand()),
                        new DecoratorEx(ret => MyType == "tank",
                            new PrioritySelector(
                                CreateBuffCheckAndCast("Avenging Wrath"),
                                CreateBuffCheckAndCast("Lay on Hands",
                                    ret => Me.HealthPercent <= 40 && !Me.HasAura("Forbearance")),
                                CreateBuffCheckAndCast("Guardian of Ancient Kings",
                                    ret => Me.HealthPercent <= 40),
                                CreateBuffCheckAndCast("Divine Shield", 
                                    ret => (!Me.IsInInstance || Me.PartyMembers.Count(p => p.Dead) > 3) &&
                                            Me.HealthPercent < 20 &&
                                            !Me.HasAura("Forbearance")),
                                CreateBuffCheckAndCast("Ardent Defender", 
                                    ret => Me.HealthPercent <= 40),
                                CreateBuffCheckAndCast("Divine Protection", 
                                    ret => Me.HealthPercent <= 70)
                                
                                ))
                        );
            }
        }

        #endregion

        #region Priest Combat Buff Behavior

        private Composite PriestCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector(
                            CreateSpellCheckAndCast("Dispersion",
                                ret => Me.Shapeshift == ShapeshiftForm.Shadow &&
                                        Me.Stunned &&
                                        Instance.Settings.UseShadowDispersionWhenStunned),
                            CreateBuffCheckAndCast("Power Infusion"),
                            CreateBuffCheckAndCast("Fear Ward", ret => Instance.Settings.UseCombatFearWard),
                            CreateBuffCheckAndCast("Inner Fire", ret => Instance.Settings.UseCombatInnerFire),
                            CreateBuffCheckAndCast("Power Word: Fortitude",
                                ret => !Me.HasAura("Blood Pact") &&
                                        !Me.HasAura("Power Word: Fortitude") &&
                                        !Me.HasAura("Qiraji Fortitude") &&
                                        !Me.HasAura("Commanding Shout") &&
                                        Instance.Settings.UseCombatPWF),
                            CreateBuffCheckAndCast("Vampiric Embrace", ret => Instance.Settings.UseCombatVampiricEmbrace),
                            CreateBuffCheckAndCast("Shadowform", ret => Instance.Settings.UseCombatShadowform),
                            CreateBuffCheckAndCast("Shadow Protection", ret => Instance.Settings.UseCombatShadowProtection)
                            );
            }
        }

        #endregion

        #region Rogue Combat Buff Behavior

        private Composite RogueCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Shaman Combat Buff Behavior

        private Composite ShamanCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Warlock Combat Buff Behavior

        private Composite WarlockCombatBuffBehavior
        {
            get
            {
                return new PrioritySelector();
            }
        }

        #endregion

        #region Warrior Combat Buff Behavior

        private Composite WarriorCombatBuffBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CreateBuffCheckAndCast("Defensive Stance", ret => MyType == "tank"),
                        CreateBuffCheckAndCast("Berserker Rage"),
                        CreateBuffCheckAndCast("Enraged Regeneration", ret => Me.HasAura("Vengeance") && Me.HealthPercent < 50),
                        CreateBuffCheckAndCast("Shield Wall", ret => Me.HealthPercent < 40));
            }
        }

        #endregion

        #region Composites

        #region Paladin Helpers

        private static WoWUnit HandTarget;
        private static WoWSpell HandSpell;
        internal class NeedToUseHand : Decorator
        {
            public NeedToUseHand(Composite decorated)
                : base(decorated)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.IsInParty || IsInBattleground)
                    return false;

                HandTarget = Me.PartyMembers.FirstOrDefault(p =>
                    p != null && p.IsValid && p.Distance < 28 &&
                    RaFHelper.Leader != null && RaFHelper.Leader.IsValid && 
                    p == RaFHelper.Leader &&
                    p.Auras.Values.ToList().Exists(a =>
                                a.ApplyAuraType == WoWApplyAuraType.ModRoot ||
                                a.ApplyAuraType == WoWApplyAuraType.ModDecreaseSpeed));

                if (HandTarget != null && HandTarget.IsValid)
                {
                    if (CanCast("Hand of Freedom", HandTarget))
                    {
                        HandSpell = SpellManager.Spells["Hand of Freedom"];
                        return true;
                    }

                    HandTarget = null;
                }

                if (RaFHelper.Leader == null || !RaFHelper.Leader.IsValid)
                    return false;

                HandTarget = Me.PartyMembers.
                                Where(p=> p != null && p.IsValid && p.Distance < 28 && p.InLineOfSight &&
                                          ObjectManager.GetObjectsOfType<WoWUnit>(false).
                                                            Exists(u => 
                                                                u != null && u.IsValid && 
                                                                (u.IsTargetingMeOrPet || u.IsTargetingMyPartyMember) &&
                                                                u.CurrentTarget != null && u.CurrentTarget.IsValid &&
                                                                u.CurrentTarget != p &&
                                                                p != RaFHelper.Leader &&
                                                                ((p.Location.Distance(u.Location) <= u.CombatReach && 
                                                                  p.GetThreatInfoFor(u).RawPercent > 90) || 
                                                                 p.GetThreatInfoFor(u).RawPercent > 110))).
                                FirstOrDefault();

                if (HandTarget != null && HandTarget.IsValid)
                {
                    if (CanCast("Hand of Salvation", HandTarget))
                    {
                        HandSpell = SpellManager.Spells["Hand of Salvation"];
                        return true;
                    }

                    HandTarget = null;
                }

                HandTarget = Me.PartyMembers.FirstOrDefault(p => p != null && p.IsValid && p.Distance < 28 && 
                                                                 p.InLineOfSight && p != RaFHelper.Leader &&
                                                                 ObjectManager.GetObjectsOfType<WoWUnit>(false).
                                                                     Exists(u => u != null && u.IsValid &&
                                                                                 u.IsHostile &&
                                                                                 u.HealthPercent < 100 &&
                                                                                 !u.IsCasting &&
                                                                                 (u.PowerType != WoWPowerType.Mana || u.ManaPercent < 2) &&
                                                                                 u.CurrentTarget != null && u.CurrentTarget.IsValid && 
                                                                                 u.CurrentTarget == p));

                if (HandTarget != null && HandTarget.IsValid)
                {
                    if (CanCast("Hand of Protection", HandTarget))
                    {
                        HandSpell = SpellManager.Spells["Hand of Protection"];
                        return true;
                    }

                    HandTarget = null;
                }

                return false;
            }
        }

        internal class UseHand : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Casting {0} on {1}", HandSpell.Name, HandTarget != Me ? HandTarget.Name : "myself");
                bool result = SpellManager.Cast(HandSpell, HandTarget);
                return result ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #endregion
    }
}