using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;
using Styx;
using Styx.Combat.CombatRoutine;
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
        private Composite CreateCombatBehavior 
        {
            get
            {
                return new PrioritySelector(
                            CheckAndClearDeadTarget,

                            new DecoratorEx(ret => MyType != "tank",
                                new PrioritySelector(
                                    CheckAndAssistPet,
                                    CheckAndAssistRaFLeader)),

                            CheckAndTargetAggroMob,
                            CheckAndTargetTotems,

                            new DecoratorEx(ret => CT == null || !CT.IsValid,
                                new ActionIdle()),

                            new DecoratorEx(ret => MyType == "tank",
                                new PrioritySelector(
                                    new NeedToHelpPartyMember(new HelpPartyMember()),
                                    CheckAndTargetBestMob)),

                            new DecoratorEx(ret => !Me.IsSafelyFacing(CT),
                                new Action(delegate
                                {
                                    WoWMovement.MoveStop();
                                    CT.Face();
                                    Thread.Sleep(100);
                                    return RunStatus.Failure;
                                })),

                            new DecoratorEx(ret => !CT.InLineOfSight,
                                new Action(delegate
                                    {
                                        WoWPoint movePoint = WoWMovement.CalculatePointFrom(CT.Location, 3);

                                        Navigator.MoveTo(movePoint);
                                        Thread.Sleep(100);
                                        return RunStatus.Success;
                                    })),

                            CheckAndUsePotions,
                            CheckAndTargetEnemyPlayer,
                            CheckAndHandleAdds,
                            CheckAndUseRacials,

                            new DecoratorEx(ret => !Me.Stunned && !Me.Fleeing && !Me.Pacified && !Me.Possessed && !Me.Silenced,
                                new PrioritySelector(
                                    CheckAndUseWand(ret => (CT.CreatureType == WoWCreatureType.Totem ||
                                                            CT.CurrentHealth == 1)),
                                    new DecoratorEx(ret => (MyType == "melee" || MyType == "tank") && !Me.IsAutoAttacking,
                                        new Action(ret => SpellManager.Cast("Auto Attack"))),

                                    new DecoratorEx(ret => IsInBattleground,
                                        new Switch<WoWClass>(r => Me.Class,
                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(DeathKnightBloodPvPDpsRotation, DeathKnightTalentSpec.Blood.ToString()),
                                                    new SwitchArgument<string>(DeathKnightFrostPvPDpsRotation, DeathKnightTalentSpec.Frost.ToString()),
                                                    new SwitchArgument<string>(DeathKnightUnholyPvPDpsRotation, DeathKnightTalentSpec.Unholy.ToString()),
                                                    new SwitchArgument<string>(DeathKnightLowPvPDpsRotation, DeathKnightTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.DeathKnight),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(DruidRestoPvPDpsRotation, DruidTalentSpec.Restoration.ToString()),
                                                    new SwitchArgument<string>(DruidBalancePvPDpsRotation, DruidTalentSpec.Balance.ToString()),
                                                    new SwitchArgument<string>(DruidFeralPvPDpsRotation, DruidTalentSpec.Feral.ToString()),
                                                    new SwitchArgument<string>(DruidLowPvPDpsRotation, DruidTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Druid),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(HunterBeastMasteryPvPDpsRotation, HunterTalentSpec.BeastMastery.ToString()),
                                                    new SwitchArgument<string>(HunterMarksmanshipPvPDpsRotation, HunterTalentSpec.Marksmanship.ToString()),
                                                    new SwitchArgument<string>(HunterSurvivalPvPDpsRotation, HunterTalentSpec.Survival.ToString()),
                                                    new SwitchArgument<string>(HunterLowPvPDpsRotation, HunterTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Hunter),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(MageArcanePvPDpsRotation, MageTalentSpec.Arcane.ToString()),
                                                    new SwitchArgument<string>(MageFirePvPDpsRotation, MageTalentSpec.Fire.ToString()),
                                                    new SwitchArgument<string>(MageFrostPvPDpsRotation, MageTalentSpec.Frost.ToString()),
                                                    new SwitchArgument<string>(MageLowPvPDpsRotation, MageTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Mage),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(PaladinHolyPvPDpsRotation, PaladinTalentSpec.Holy.ToString()),
                                                    new SwitchArgument<string>(PaladinProtectionPvPDpsRotation, PaladinTalentSpec.Protection.ToString()),
                                                    new SwitchArgument<string>(PaladinRetributionPvPDpsRotation, PaladinTalentSpec.Retribution.ToString()),
                                                    new SwitchArgument<string>(PaladinLowPvPDpsRotation, PaladinTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Paladin),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(PriestLowPvPDpsRotation, PriestTalentSpec.Lowbie.ToString()),
                                                    new SwitchArgument<string>(PriestDiscPvPDpsRotation, PriestTalentSpec.Discipline.ToString()),
                                                    new SwitchArgument<string>(PriestHolyPvPDpsRotation, PriestTalentSpec.Holy.ToString()),
                                                    new SwitchArgument<string>(PriestShadowPvPDpsRotation, PriestTalentSpec.Shadow.ToString())
                                                    ),
                                                    WoWClass.Priest),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(RogueAssassinationPvPDpsRotation, RogueTalentSpec.Assassination.ToString()),
                                                    new SwitchArgument<string>(RogueCombatPvPDpsRotation, RogueTalentSpec.Combat.ToString()),
                                                    new SwitchArgument<string>(RogueSubtletyPvPDpsRotation, RogueTalentSpec.Subtlety.ToString()),
                                                    new SwitchArgument<string>(RogueLowPvPDpsRotation, RogueTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Rogue),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(ShamanRestoPvPDpsRotation, ShamanTalentSpec.Restoration.ToString()),
                                                    new SwitchArgument<string>(ShamanElementalPvPDpsRotation, ShamanTalentSpec.Elemental.ToString()),
                                                    new SwitchArgument<string>(ShamanEnhancementPvPDpsRotation, ShamanTalentSpec.Enhancement.ToString()),
                                                    new SwitchArgument<string>(ShamanLowPvPDpsRotation, ShamanTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Shaman),
 
                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(WarlockAfflictionPvPDpsRotation, WarlockTalentSpec.Affliction.ToString()),
                                                    new SwitchArgument<string>(WarlockDemonologyPvPDpsRotation, WarlockTalentSpec.Demonology.ToString()),
                                                    new SwitchArgument<string>(WarlockDestructionPvPDpsRotation, WarlockTalentSpec.Destruction.ToString()),
                                                    new SwitchArgument<string>(WarlockLowPvPDpsRotation, WarlockTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Warlock),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(WarriorArmsPvPDpsRotation, WarriorTalentSpec.Arms.ToString()),
                                                    new SwitchArgument<string>(WarriorFuryPvPDpsRotation, WarriorTalentSpec.Fury.ToString()),
                                                    new SwitchArgument<string>(WarriorProtectionPvPDpsRotation, WarriorTalentSpec.Protection.ToString()),
                                                    new SwitchArgument<string>(WarriorLowPvPDpsRotation, WarriorTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Warrior)
                                                )),
                                    new DecoratorEx(ret => !IsInBattleground,
                                        new Switch<WoWClass>(r => Me.Class,
                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(DeathKnightBloodDpsRotation, DeathKnightTalentSpec.Blood.ToString()),
                                                    new SwitchArgument<string>(DeathKnightFrostDpsRotation, DeathKnightTalentSpec.Frost.ToString()),
                                                    new SwitchArgument<string>(DeathKnightUnholyDpsRotation, DeathKnightTalentSpec.Unholy.ToString()),
                                                    new SwitchArgument<string>(DeathKnightLowDpsRotation, DeathKnightTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.DeathKnight),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(DruidRestoDpsRotation, DruidTalentSpec.Restoration.ToString()),
                                                    new SwitchArgument<string>(DruidBalanceDpsRotation, DruidTalentSpec.Balance.ToString()),
                                                    new SwitchArgument<string>(DruidFeralDpsRotation, DruidTalentSpec.Feral.ToString()),
                                                    new SwitchArgument<string>(DruidLowDpsRotation, DruidTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Druid),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(HunterBeastMasteryDpsRotation, HunterTalentSpec.BeastMastery.ToString()),
                                                    new SwitchArgument<string>(HunterMarksmanshipDpsRotation, HunterTalentSpec.Marksmanship.ToString()),
                                                    new SwitchArgument<string>(HunterSurvivalDpsRotation, HunterTalentSpec.Survival.ToString()),
                                                    new SwitchArgument<string>(HunterLowDpsRotation, HunterTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Hunter),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(MageArcaneDpsRotation, MageTalentSpec.Arcane.ToString()),
                                                    new SwitchArgument<string>(MageFireDpsRotation, MageTalentSpec.Fire.ToString()),
                                                    new SwitchArgument<string>(MageFrostDpsRotation, MageTalentSpec.Frost.ToString()),
                                                    new SwitchArgument<string>(MageLowDpsRotation, MageTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Mage),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(PaladinHolyDpsRotation, PaladinTalentSpec.Holy.ToString()),
                                                    new SwitchArgument<string>(PaladinProtectionDpsRotation, PaladinTalentSpec.Protection.ToString()),
                                                    new SwitchArgument<string>(PaladinRetributionDpsRotation, PaladinTalentSpec.Retribution.ToString()),
                                                    new SwitchArgument<string>(PaladinLowDpsRotation, PaladinTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Paladin),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(PriestLowDpsRotation, PriestTalentSpec.Lowbie.ToString()),
                                                    new SwitchArgument<string>(PriestDiscDpsRotation, PriestTalentSpec.Discipline.ToString()),
                                                    new SwitchArgument<string>(PriestHolyDpsRotation, PriestTalentSpec.Holy.ToString()),
                                                    new SwitchArgument<string>(PriestShadowDpsRotation, PriestTalentSpec.Shadow.ToString())
                                                    ),
                                                    WoWClass.Priest),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(RogueAssassinationDpsRotation, RogueTalentSpec.Assassination.ToString()),
                                                    new SwitchArgument<string>(RogueCombatDpsRotation, RogueTalentSpec.Combat.ToString()),
                                                    new SwitchArgument<string>(RogueSubtletyDpsRotation, RogueTalentSpec.Subtlety.ToString()),
                                                    new SwitchArgument<string>(RogueLowDpsRotation, RogueTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Rogue),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(ShamanRestoDpsRotation, ShamanTalentSpec.Restoration.ToString()),
                                                    new SwitchArgument<string>(ShamanElementalDpsRotation, ShamanTalentSpec.Elemental.ToString()),
                                                    new SwitchArgument<string>(ShamanEnhancementDpsRotation, ShamanTalentSpec.Enhancement.ToString()),
                                                    new SwitchArgument<string>(ShamanLowDpsRotation, ShamanTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Shaman),
 
                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(WarlockAfflictionDpsRotation, WarlockTalentSpec.Affliction.ToString()),
                                                    new SwitchArgument<string>(WarlockDemonologyDpsRotation, WarlockTalentSpec.Demonology.ToString()),
                                                    new SwitchArgument<string>(WarlockDestructionDpsRotation, WarlockTalentSpec.Destruction.ToString()),
                                                    new SwitchArgument<string>(WarlockLowDpsRotation, WarlockTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Warlock),

                                            new SwitchArgument<WoWClass>(
                                                new Switch<string>(r => CurrentSpec,
                                                    new SwitchArgument<string>(WarriorArmsDpsRotation, WarriorTalentSpec.Arms.ToString()),
                                                    new SwitchArgument<string>(WarriorFuryDpsRotation, WarriorTalentSpec.Fury.ToString()),
                                                    new SwitchArgument<string>(WarriorProtectionDpsRotation, WarriorTalentSpec.Protection.ToString()),
                                                    new SwitchArgument<string>(WarriorLowDpsRotation, WarriorTalentSpec.Lowbie.ToString())
                                                    ),
                                                    WoWClass.Warrior)
                            )))),
                            
                            new DecoratorEx(ret => MyType == "melee" || MyType == "tank",
                                new PrioritySelector(
                                    new DecoratorEx(ret => CT.Distance >= CT.InteractRange + 1f && (!CT.IsMoving || CT.Fleeing || CT.IsTargetingMyPartyMember),
                                        new Action(delegate
                                        {
                                            Navigator.MoveTo(WoWMovement.CalculatePointFrom(CT.Location, CT.InteractRange));
                                            Thread.Sleep(100);
                                            return RunStatus.Success;
                                        })))));
            }
        }

        #region Composites

        #region NeedToHelpPartyMember

        private static WoWUnit agroTarget;
        internal class NeedToHelpPartyMember : Decorator
        {
            public NeedToHelpPartyMember(Composite decorated)
                : base(decorated)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.IsInParty || IsInBattleground)
                    return false;

                agroTarget = ObjectManager.GetObjectsOfType<WoWUnit>(false, false).FirstOrDefault(u =>
                                u != null && u.IsValid && u.Attackable && !u.IsPet && !u.IsFriendly &&
                                !u.IsTotem && !u.Fleeing && u.IsTargetingMyPartyMember);

                if (agroTarget != null && agroTarget.IsValid)
                    return true;

                agroTarget = ObjectManager.GetObjectsOfType<WoWUnit>(false, false).
                                Where(u => u != null && u.IsValid &&
                                           u.ThreatInfo.ThreatStatus != ThreatStatus.UnitNotInThreatTable &&
                                           (CT == null || !CT.IsValid || u != CT) &&
                                           !u.IsPet &&
                                           u.IsTargetingMeOrPet &&
                                           Me.PartyMembers.Exists(p =>
                                               p != null && p.IsValid &&
                                               (p.Location.Distance(u.Location) <= u.CombatReach &&
                                               p.GetThreatInfoFor(u).RawPercent > 90) ||
                                               p.GetThreatInfoFor(u).RawPercent > 110)).
                                OrderBy(u => u.ThreatInfo.RawPercent).
                                FirstOrDefault();

                if (agroTarget != null && agroTarget.IsValid)
                    return true;

                return false;
            }
        }

        internal class HelpPartyMember : Action
        {
            protected override RunStatus Run(object context)
            {
                agroTarget.Target();
                Thread.Sleep(100);
                ObjectManager.Update();
                return RunStatus.Failure;
            }
        }

        #endregion

        #region CheckAndUseRacials

        private Composite CheckAndUseRacials
        {
            get
            {
                return new PrioritySelector(
                            CreateSpellCheckAndCast("Will of the Forsaken",
                                    ret => Me.Auras.FirstOrDefault(x => x.Value.Spell.Mechanic == WoWSpellMechanic.Charmed ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Horrified ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Asleep).Value != null &&
                                           Instance.Settings.UseWotF),
                            CreateSpellCheckAndCast("Every Man for Himself",
                                    ret => Me.Auras.FirstOrDefault(x => x.Value.Spell.Mechanic == WoWSpellMechanic.Charmed ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Horrified ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Asleep ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Disoriented ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Frozen ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Polymorphed ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Rooted ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Sapped ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Slowed ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Snared ||
                                                                        x.Value.Spell.Mechanic == WoWSpellMechanic.Stunned).Value != null &&
                                           Instance.Settings.UseEMfHs),
                            CreateSpellCheckAndCast("Berserking",
                                    ret => Me.HealthPercent <= 60 || Adds.Count > 0)
                            );
            }
        }

        #endregion

        #region CheckAndUsePotions

        private static Stopwatch potionTimer = new Stopwatch();
        private Composite CheckAndUsePotions
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => potionTimer.ElapsedMilliseconds >= 120000,
                                new Action(ret => potionTimer.Reset())),

                            new DecoratorEx(ret => Me.HealthPercent <= (double)Instance.Settings.HealthPotHealth &&
                                                 Instance.Settings.UseHealthPot &&
                                                 !potionTimer.IsRunning,
                                new Action(delegate
                                    {
                                        Log("Using Health Potion");
                                        Healing.UseHealthPotion();
                                        potionTimer.Start();
                                        return RunStatus.Success;
                                    })),

                            new DecoratorEx(ret => Me.ManaPercent <= (double)Instance.Settings.ManaPotMana &&
                                                 Instance.Settings.UseManaPot &&
                                                 !potionTimer.IsRunning,
                                new Action(delegate
                                    {
                                        Log("Using Mana Potion");
                                        Healing.UseManaPotion();
                                        potionTimer.Start();
                                        return RunStatus.Success;
                                    })));
            }
        }

        #endregion

        #region CheckAndAssistRaFLeader

        private Composite CheckAndAssistRaFLeader
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => Me.IsInParty &&
                                                 !Me.IsInInstance &&
                                                 Styx.Logic.RaFHelper.Leader != null &&
                                                 Styx.Logic.RaFHelper.Leader.IsValid &&
                                                 Styx.Logic.RaFHelper.Leader.CurrentTarget != null &&
                                                 Styx.Logic.RaFHelper.Leader.CurrentTarget.IsValid &&
                                                 Styx.Logic.RaFHelper.Leader.CurrentTarget.HealthPercent < 100 && 
                                                 (CT == null || !CT.IsValid || CT != Styx.Logic.RaFHelper.Leader.CurrentTarget),
                                new Action(delegate
                                    {
                                        Log("Assisting party Leader");
                                        Styx.Logic.RaFHelper.Leader.CurrentTarget.Target();
                                        Thread.Sleep(100);
                                        return RunStatus.Success;
                                    })));
            }
        }

        #endregion

        #region CheckAndTargetEnemyPlayer

        private Composite CheckAndTargetEnemyPlayer
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => !IsInBattleground && CT != null && CT.IsValid && !CT.IsPlayer &&
                                                 ObjectManager.GetObjectsOfType<WoWPlayer>().Exists(x => x != null && x.IsValid && x.IsTargetingMeOrPet && x.Aggro),
                                new Action(delegate
                                {
                                    Log("A player is attacking us. Targeting them!");
                                    ObjectManager.GetObjectsOfType<WoWPlayer>().Find(x => x != null && x.IsValid && x.IsTargetingMeOrPet && x.Aggro).Target();
                                    Thread.Sleep(100);
                                    return RunStatus.Success;
                                })));
            }
        }

        #endregion

        #region CheckAndHandleAdds

        private Composite CheckAndHandleAdds
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => Me.Class == WoWClass.Priest &&
                                                   Adds.Count > 0 &&
                                                   Instance.Settings.DotAdds &&
                                                   !Me.IsInInstance &&
                                                   CT.HasAura("Shadow Word: Pain") &&
                                                   (CT.HasAura("Vampiric Touch") || !SpellManager.HasSpell("Vampiric Touch")) && 
                                                   (CT.HasAura("Devouring Plague") || !SpellManager.HasSpell("Devouring Plague")) &&
                                                   Adds.Exists(unit => !unit.HasAura("Shadow Word: Pain")),
                                new Action(delegate
                                    {
                                        Log("Targeting add...");
                                        Adds.Find(unit => !unit.HasAura("Shadow Word: Pain")).Target();
                                        Thread.Sleep(100);
                                        return RunStatus.Success;
                                    })));
            }
        }

        #endregion

        #region CheckAndTargetBestMob

        private Composite CheckAndTargetBestMob
        {
            get
            {
                return
                    new DecoratorEx(ret => Me.IsInParty && !IsInBattleground,
                        new Action(delegate
                            {
                                WoWUnit bestTarget = ObjectManager.GetObjectsOfType<WoWUnit>(false).
                                                        Where(u =>
                                                            u != null && u.IsValid && u.IsTargetingMeOrPet &&
                                                            u.IsHostile && u.HealthPercent < 100).
                                                        OrderByDescending(u =>
                                                            Me.PartyMembers.
                                                                Where(p => p != null && p.IsValid).
                                                                OrderByDescending(p =>
                                                                    p.GetThreatInfoFor(u).RawPercent).
                                                                FirstOrDefault().GetThreatInfoFor(u).RawPercent).
                                                        FirstOrDefault();

                                if (bestTarget != null && bestTarget.IsValid && CT != bestTarget)
                                {
                                    bestTarget.Target();
                                    Thread.Sleep(100);
                                    return RunStatus.Success;
                                }
                                return RunStatus.Failure;
                            }));
            }
        }

        #endregion

        #endregion
    }
}