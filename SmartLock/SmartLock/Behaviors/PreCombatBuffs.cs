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
        private Composite CreatePreCombatBuffsBehavior
        {
            get
            {
                return
                    new DecoratorEx(ret => !Me.Mounted, 
                        new PrioritySelector(
                            new Switch<WoWClass>(r => Me.Class,
                                new SwitchArgument<WoWClass>(DeathKnightPreCombatBuffsBehavior, WoWClass.DeathKnight),
                                new SwitchArgument<WoWClass>(DruidPreCombatBuffsBehavior, WoWClass.Druid),
                                new SwitchArgument<WoWClass>(HunterPreCombatBuffsBehavior, WoWClass.Hunter),
                                new SwitchArgument<WoWClass>(MagePreCombatBuffsBehavior, WoWClass.Mage),
                                new SwitchArgument<WoWClass>(PaladinPreCombatBuffsBehavior, WoWClass.Paladin),
                                new SwitchArgument<WoWClass>(PriestPreCombatBuffsBehavior, WoWClass.Priest),
                                new SwitchArgument<WoWClass>(RoguePreCombatBuffsBehavior, WoWClass.Rogue),
                                new SwitchArgument<WoWClass>(ShamanPreCombatBuffsBehavior, WoWClass.Shaman),
                                new SwitchArgument<WoWClass>(WarlockPreCombatBuffsBehavior, WoWClass.Warlock),
                                new SwitchArgument<WoWClass>(WarriorPreCombatBuffsBehavior, WoWClass.Warrior)),
                                
                            new NeedToBuffPlayers(new BuffPlayers())
                            ));
            }
        }

        #region DeathKnight Pre Combat Buffs Behavior

        private Composite DeathKnightPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion

        #region Druid Pre Combat Buffs Behavior

        private Composite DruidPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CreateBuffCheckAndCast("Mark of the Wild",
                            ret => !Me.HasAura("Embrace of the Shale Spider") &&
                                   !Me.HasAura("Blessing of Kings"))
                        );
            }
        }

        #endregion

        #region Hunter Pre Combat Buffs Behavior

        private Composite HunterPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion

        #region Mage Pre Combat Buffs Behavior

        private Composite MagePreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion

        #region Paladin Pre Combat Buffs Behavior

        private Composite PaladinPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CreateBuffCheckAndCast("Blessing of Kings", 
                            ret => (!Me.HasAura("Blessing of Might") || Me.Auras["Blessing of Might"].CreatorGuid != Me.Guid) &&
                                   !Me.HasAura("Embrace of the Shale Spider") &&
                                   !Me.HasAura("Mark of the Wild")),
                        CreateBuffCheckAndCast("Blessing of Might",
                            ret => !Me.HasAura("Blessing of Kings") || 
                                   Me.Auras["Blessing of Kings"].CreatorGuid != Me.Guid),

                        new DecoratorEx(ret => MyType == "tank",
                            new PrioritySelector(
                                CreateBuffCheckAndCast("Seal of Truth"),
                                CreateBuffCheckAndCast("Devotion Aura"),
                                CreateBuffCheckAndCast("Righteous Fury")
                                )),

                        new DecoratorEx(ret => MyType == "healer",
                            new PrioritySelector(
                                CreateBuffCheckAndCast("Seal of Insight")
                                )),

                        new DecoratorEx(ret => MyType == "melee",
                            new PrioritySelector(
                                CreateBuffCheckAndCast("Seal of Righteousness")
                                ))
                        );
            }
        }

        #endregion

        #region Priest Pre Combat Buffs Behavior

        private Composite PriestPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector(
                        CreateBuffCheckAndCast("Fear Ward", ret => Instance.Settings.UsePreCombatFearWard),
                        CreateBuffCheckAndCast("Inner Fire", ret => Instance.Settings.UsePreCombatInnerFire),
                        CreateBuffCheckAndCast("Power Word: Fortitude",
                            ret => !Me.HasAura("Blood Pact") &&
                                    !Me.HasAura("Power Word: Fortitude") &&
                                    !Me.HasAura("Qiraji Fortitude") &&
                                    !Me.HasAura("Commanding Shout") &&
                                    Instance.Settings.UsePreCombatPWF),
                        CreateBuffCheckAndCast("Vampiric Embrace", ret => Instance.Settings.UsePreCombatVampiricEmbrace),
                        CreateBuffCheckAndCast("Shadowform", ret => Instance.Settings.UsePreCombatShadowform),
                        CreateBuffCheckAndCast("Shadow Protection", ret => Instance.Settings.UsePreCombatShadowProtection));
            }
        }

        #endregion

        #region Rogue Pre Combat Buffs Behavior

        private Composite RoguePreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion

        #region Shaman Pre Combat Buffs Behavior

        private Composite ShamanPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion

        #region Warlock Pre Combat Buffs Behavior

        private Composite WarlockPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion

        #region Warrior Pre Combat Buffs Behavior

        private Composite WarriorPreCombatBuffsBehavior
        {
            get
            {
                return
                    new PrioritySelector();
            }
        }

        #endregion    

        #region NeedtoBuffPlayers

        private static WoWPlayer BuffTarget;
        private static WoWSpell BuffSpell;
        private static WoWPlayer rezTarget;
        private static Stopwatch rezTimer = new Stopwatch();

        public class NeedToBuffPlayers : Decorator
        {
            public NeedToBuffPlayers(Composite child) : base(child) { }

            protected override bool CanRun(object context)
            {
                if (!ObjectManager.IsInGame || Me == null)
                    return false;

                if (rezTimer.ElapsedMilliseconds >= 15000)
                {
                    rezTimer.Reset();
                    rezTarget = null;
                }

                if (IsInBattleground && !Me.HasAura("Preperation")) return false;
                List<WoWPlayer> playerList = Me.IsInRaid ? Me.RaidMembers : Me.IsInParty ? Me.PartyMembers : null;
                if (playerList == null) return false;

                foreach (WoWPlayer unit in playerList)
                {
                    if (unit != Me &&
                        unit.Dead &&
                        rezTarget != unit &&
                        !IsInBattleground &&
                        (CanCast("Resurrection", unit) ||
                        CanCast("Revive", unit) ||
                        CanCast("Redemption", unit) ||
                        CanCast("Ancestral Spirit", unit)))
                    {
                        rezTarget = unit;
                        rezTimer.Start();
                        BuffTarget = unit;
                        switch (Me.Class)
                        {
                            case WoWClass.Priest:
                                BuffSpell = SpellManager.Spells["Resurrection"];
                                break;

                            case WoWClass.Druid:
                                BuffSpell = SpellManager.Spells["Revive"];
                                break;

                            case WoWClass.Paladin:
                                BuffSpell = SpellManager.Spells["Redemption"];
                                break;

                            case WoWClass.Shaman:
                                BuffSpell = SpellManager.Spells["Ancestral Spirit"];
                                break;
                        }
                        return true;
                    }
                    else if (IsInBattleground && !Me.HasAura("Preperation"))
                    {
                        return false;
                    }
                    else if (unit.IsAlive && unit.Distance < 60)
                    {
                        switch (Me.Class)
                        {
                            case WoWClass.Priest:
                                if (Instance.Settings.UsePartyPWF &&
                                    !unit.HasAura("Blood Pact") &&
                                    !unit.HasAura("Power Word: Fortitude") &&
                                    !unit.HasAura("Qiraji Fortitude") &&
                                    !unit.HasAura("Commanding Shout") &&
                                    CanCast("Power Word: Fortitude", unit) &&
                                    Me.ManaPercent >= (double)Ensemble.Instance.Settings.BuffMana)
                                {
                                    BuffTarget = unit;
                                    BuffSpell = SpellManager.Spells["Power Word: Fortitude"];
                                    return true;
                                }
                                else if (Instance.Settings.UsePartyShadowProtection &&
                                         !unit.HasAura("Shadow Protection") &&
                                         CanCast("Shadow Protection") &&
                                         Me.ManaPercent >= (double)Ensemble.Instance.Settings.BuffMana)
                                {
                                    BuffTarget = unit;
                                    BuffSpell = SpellManager.Spells["Shadow Protection"];
                                    return true;
                                }
                                break;

                            case WoWClass.Druid:
                                if (!unit.HasAura("Embrace of the Shale Spider") &&
                                    !unit.HasAura("Blessing of Kings") &&
                                    !unit.HasAura("Mark of the Wild") &&
                                    CanCast("Mark of the Wild", unit))
                                {
                                    BuffTarget = unit;
                                    BuffSpell = SpellManager.Spells["Mark of the Wild"];
                                    return true;
                                }
                                break;

                            case WoWClass.Paladin:
                                if (!unit.HasAura("Blessing of Kings") &&
                                    (!unit.HasAura("Blessing of Might") || unit.Auras["Blessing of Might"].CreatorGuid != Me.Guid) &&
                                    !unit.HasAura("Embrace of the Shale Spider") &&
                                    !unit.HasAura("Mark of the Wild") &&
                                    CanCast("Blessing of Kings", unit))
                                {
                                    BuffTarget = unit;
                                    BuffSpell = SpellManager.Spells["Blessing of Kings"];
                                    return true;
                                }
                                else if (!unit.HasAura("Blessing of Might") && 
                                         (!unit.HasAura("Blessing of Kings") || unit.Auras["Blessing of Kings"].CreatorGuid != Me.Guid) &&
                                         CanCast("Blessing of Might", unit))
                                {
                                    BuffTarget = unit;
                                    BuffSpell = SpellManager.Spells["Blessing of Might"];
                                    return true;
                                }
                                break;

                            case WoWClass.Shaman:
                                break;
                        }
                    }
                }
                return false;
            }
        }

        public class BuffPlayers : Action
        {
            protected override RunStatus Run(object context)
            {
                if (!BuffTarget.InLineOfSight)
                {
                    Navigator.MoveTo(BuffTarget.Location);
                    return RunStatus.Running;
                }
                else if (BuffTarget.Distance > BuffSpell.MaxRange)
                {
                    Navigator.MoveTo(WoWMovement.CalculatePointFrom(BuffTarget.Location, BuffSpell.MaxRange - 5));
                    return RunStatus.Running;
                }

                Log("Casting {0} on {1}", BuffSpell.Name, BuffTarget.Name);
                bool result = SpellManager.Cast(BuffSpell, BuffTarget);
                return result ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion
    }
}