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
using RaFHelper = Styx.Logic.RaFHelper;

namespace Ensemble
{
    public partial class Ensemble : CombatRoutine
    {
        private static Composite CreateHealBehavior
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => Me.IsCasting || StyxWoW.GlobalCooldown,
                                new PrioritySelector(
                                    new DecoratorEx(ret => Me.ChanneledCastingSpellId == 0 && CT != null &&
                                                           CT.IsValid && !Me.IsSafelyFacing(CT),
                                        new Action(delegate
                                        {
                                            WoWMovement.MoveStop();
                                            CT.Face();
                                            Thread.Sleep(100);
                                            return RunStatus.Failure;
                                        })),
                                    new Action(ret => wasCasting = true))),

                            new DecoratorEx(ret => wasCasting,
                                new Action(delegate
                                {
                                    wasCasting = false;
                                    Thread.Sleep(RandomNumber(200, 300));
                                    ObjectManager.Update();
                                    return RunStatus.Success;
                                })),

                             new NeedToHeal(new HealNow()));
            }
        }

        private static WoWUnit HealTarget;
        private static WoWSpell HealSpell;
        private static WoWUnit DispelTarget;
        private static WoWSpell DispelSpell;
        internal class NeedToHeal : Decorator
        {
            public NeedToHeal(Composite decorated)
                : base(decorated)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!ObjectManager.IsInGame || Me == null)
                    return false;
                if (Me.Dead && !Me.Stunned && !Me.Fleeing && !Me.Pacified && !Me.Possessed && !Me.Silenced)
                    return false;

                DispelTarget = null;
                DispelSpell = null;

                List<WoWUnit> healList = new List<WoWUnit>();

                if (MyType != "healer" && Me.Level >= 10)
                {
                }
                else if (Me.IsInRaid)
                {
                    foreach (WoWPlayer p in Me.RaidMembers)
                    {
                        if (p != null && p.IsValid && p.Distance < 60 && p.HealthPercent > 1)
                        {
                            if (RaFHelper.Leader != null && RaFHelper.Leader.IsValid && RaFHelper.Leader == p)
                                continue;

                            healList.Add(p);

                            if (p.GotAlivePet)
                                healList.Add(p.Pet);
                        }
                    }
                }
                else if (Me.IsInParty)
                {
                    foreach (WoWPlayer p in Me.PartyMembers)
                    {
                        if (p != null && p.IsValid && p.Distance < 60 && p.HealthPercent > 1)
                        {
                            if (RaFHelper.Leader != null && RaFHelper.Leader.IsValid && RaFHelper.Leader == p)
                                continue;

                            healList.Add(p);

                            if (p.GotAlivePet)
                                healList.Add(p.Pet);
                        }
                    }
                }

                if (MyType == "Healer" && RaFHelper.Leader != null && RaFHelper.Leader.IsValid)
                {
                    if (!SpellManager.HasSpell("Beacon of Light") && RaFHelper.Leader.HealthPercent > 60)
                        healList.Add(RaFHelper.Leader);

                    if (Me.HealthPercent > 60)
                        healList.Add(Me);
                }
                else
                {
                    if (!SpellManager.HasSpell("Beacon of Light") && Me.HealthPercent > 60)
                        healList.Add(Me);
                }

                if (healList.Count > 1)
                {
                    healList.Sort(delegate(WoWUnit u1, WoWUnit u2)
                    { return u1.CurrentHealth.CompareTo(u2.CurrentHealth); });
                }

                // List Overrides to put ourself, followtarget and tank to the top of the heal list
                //if (FollowTarget != null && FollowTarget.IsValid && FollowTarget.HealthPercent > 1 && FollowTarget.HealthPercent <= 60)
                //    playerList.Insert(0, new player(FollowTarget, FollowTarget.HealthPercent));

                if (RaFHelper.Leader != null && RaFHelper.Leader.IsValid && !healList.Contains(RaFHelper.Leader))
                    healList.Insert(0, RaFHelper.Leader);

                if (Me.HealthPercent > 1 && !healList.Contains(Me))
                    healList.Insert(0, Me);

                //
                Dictionary<SpellPriority, CastRequirements> heals = new Dictionary<SpellPriority,CastRequirements>();

                if (IsInBattleground)
                {
                    switch (Me.Class)
                    {
                        case WoWClass.Priest:
                            switch (CurrentSpec)
                            {
                                case "Discipline":
                                    heals = PriestDiscHealPvP;
                                    break;

                                case "Holy":
                                    heals = PriestHolyHealPvP;
                                    break;

                                case "Shadow":
                                    heals = PriestShadowHealPvP;
                                    break;
                            }
                            break;

                        case WoWClass.Druid:
                            switch (CurrentSpec)
                            {
                                case "Restoration":
                                    heals = DruidRestoHeal;
                                    break;
                            }
                            break;

                        case WoWClass.Paladin:
                            switch (CurrentSpec)
                            {
                                case "Holy":
                                    heals = PaladinHolyHeal;
                                    break;
                            }
                            break;

                        case WoWClass.Shaman:
                            switch (CurrentSpec)
                            {
                                case "Restoration":
                                    heals = ShamanRestoHeal;
                                    break;
                            }
                            break;
                    }

                }
                else if (Me.IsInParty && Me.Class == WoWClass.Priest &&
                        (_talentManager.Spec == 3 ||
                        _talentManager.Spec == 0))
                {
                    switch (_talentManager.Spec)
                    {
                        case 3:
                            heals = PriestShadowHealRaF;
                            break;

                        case 0:
                            heals = PriestLowHealRaF;
                            break;
                    }
                }
                else
                {
                    switch (Me.Class)
                    {
                        case WoWClass.Priest:
                            switch (CurrentSpec)
                            {
                                case "Lowbie":
                                    heals = PriestLowHeal;
                                    break;

                                case "Discipline":
                                    heals = PriestDiscHeal;
                                    break;

                                case "Holy":
                                    heals = PriestHolyHeal;
                                    break;

                                case "Shadow":
                                    heals = PriestShadowHeal;
                                    break;
                            }
                            break;
                            
                        case WoWClass.Druid:
                            switch (CurrentSpec)
                            {
                                case "Restoration":
                                    heals = DruidRestoHeal;
                                    break;
                            }
                            break;

                        case WoWClass.Paladin:
                            switch (CurrentSpec)
                            {
                                case "Holy":
                                    heals = PaladinHolyHeal;
                                    break;
                            }
                            break;

                        case WoWClass.Shaman:
                            switch (CurrentSpec)
                            {
                                case "Restoration":
                                    heals = ShamanRestoHeal;
                                    break;
                            }
                            break;
                    }
                }

                if (heals.Count == 0)
                    return false;
        
                var items = (from k in heals.Keys
                             orderby k.Priority descending
                             select k);


                foreach (WoWUnit p in healList)
                {
                    if (p == null || !p.IsValid || p.HealthPercent < 2)
                        continue;

                    foreach (var s in items)
                    {
                        if (heals[s].Invoke(p))
                        {
                                HealTarget = p;
                                HealSpell = SpellManager.Spells[s.Name];
                                return true;
                        }
                    }
                    switch (Me.Class)
                    {
                        case WoWClass.Priest:
                            if (p.Debuffs.Values.ToList().Exists(aura => aura.Spell.DispelType == WoWDispelType.Magic &&
                                           CanCast("Dispel Magic") &&
                                           Instance.Settings.DispelMagic &&
                                           (!Me.Combat || !Instance.Settings.DispelOnlyOOC) &&
                                           !dispelBlacklist.Contains(aura.Name)))
                            {
                                DispelTarget = p;
                                DispelSpell = SpellManager.Spells["Dispel Magic"];
                            }
                            else if (p.Debuffs.Values.ToList().Exists(aura => aura.Spell.DispelType == WoWDispelType.Disease &&
                                                                       CanCast("Cure Disease") &&
                                                                       Instance.Settings.RemoveDisease &&
                                                                       (!Me.Combat || !Instance.Settings.DispelOnlyOOC) &&
                                                                       !diseaseBlacklist.Contains(aura.Name)))
                            {
                                DispelTarget = p;
                                DispelSpell = SpellManager.Spells["Cure Disease"];
                            }
                            break;

                        case WoWClass.Druid:
                            if (p.Debuffs.Values.ToList().Exists(aura => (aura.Spell.DispelType == WoWDispelType.Poison ||
                                                                          aura.Spell.DispelType == WoWDispelType.Curse ||
                                                                          (aura.Spell.DispelType == WoWDispelType.Magic && HasTalent(3, 17))) &&
                                                                       CanCast("Remove Corruption") &&
                                                                       Instance.Settings.DispelMagic &&
                                                                       (!Me.Combat || !Instance.Settings.DispelOnlyOOC) &&
                                                                       !dispelBlacklist.Contains(aura.Name)))
                            {
                                DispelTarget = p;
                                DispelSpell = SpellManager.Spells["Remove Corruption"];
                            }
                            break;

                        case WoWClass.Paladin:
                            break;

                        case WoWClass.Shaman:
                            break;
                    }
                }
                if (DispelTarget != null && DispelTarget.IsValid)
                    return true;

                return false;
            }
        }

        internal class HealNow : Action
        {
            protected override RunStatus Run(object context)
            {
                bool result;

                if (DispelTarget != null && DispelTarget.IsValid)
                {
                    if (!DispelTarget.InLineOfSight)
                    {
                        Navigator.MoveTo(WoWMathHelper.CalculatePointAtSide(DispelTarget.Location, DispelTarget.Rotation, 5, true));
                        Thread.Sleep(100);
                        return RunStatus.Running;
                    }
                    else if (DispelTarget.Distance > DispelSpell.MaxRange)
                    {
                        Navigator.MoveTo(WoWMovement.CalculatePointFrom(DispelTarget.Location, DispelSpell.MaxRange - 5));
                        Thread.Sleep(100);
                        return RunStatus.Running;
                    }

                    Log("Casting {0} on {1}", DispelSpell.Name, DispelTarget != Me ? DispelTarget.Name : "myself");
                    result = SpellManager.Cast(DispelSpell, DispelTarget);
                    wasCasting = true;
                    return result ? RunStatus.Success : RunStatus.Failure;
                }

                if (!HealTarget.InLineOfSight)
                {
                    Navigator.MoveTo(WoWMathHelper.CalculatePointAtSide(HealTarget.Location, HealTarget.Rotation, 5, true));
                    Thread.Sleep(100);
                    return RunStatus.Running;
                }
                else if (HealTarget.Distance > HealSpell.MaxRange)
                {
                    Navigator.MoveTo(WoWMovement.CalculatePointFrom(HealTarget.Location, HealSpell.MaxRange - 5));
                    Thread.Sleep(100);
                    return RunStatus.Running;
                }
                else if (Me.IsMoving && (HealSpell.CastTime > 0 || HealSpell.Name == "Penance"))
                {
                    WoWMovement.MoveStop();
                    Thread.Sleep(100);
                }

                if (Me.IsInInstance && Me.HasAura("Evangelism") && Me.Auras["Evangelism"].StackCount == 5 && CanCast("Archangel"))
                {
                    Log("Casting Archangel before healing");
                    SpellManager.Cast("Archangel");
                }

                if ((HealSpell.Name == "Flash Heal" ||
                    HealSpell.Name == "Greater Heal" ||
                    HealSpell.Name == "Heal" ||
                    HealSpell.Name == "Prayer of Healing") &&
                    CanCast("Inner Focus"))
                {
                    Log("Casting Inner Focus before healing");
                    SpellManager.Cast("Inner Focus");
                }

                if (Me.Class == WoWClass.Druid &&
                    Me.Combat &&
                    (HealSpell.Name == "Nourish" ||
                    HealSpell.Name == "Healing Touch") &&
                    HealTarget.HealthPercent <= 50 &&
                    CanCast("Nature's Swiftness"))
                {
                    Log("Emergency Heal with Nature's Swiftness");
                    SpellManager.Cast("Nature's Swiftness");
                }

                if (Me.Class == WoWClass.Druid &&
                    Me.Combat &&
                    HealSpell.Name == "Rebirth" &&
                    CanCast("Nature's Swiftness"))
                {
                    Log("Emergency rez with Nature's Swiftness");
                    SpellManager.Cast("Nature's Swiftness");
                }

                Log("Casting {0} on {1}", HealSpell.Name, HealTarget != Me ? HealTarget.Name : "myself");
                result = SpellManager.Cast(HealSpell, HealTarget);
                wasCasting = true;
                return result ? RunStatus.Success : RunStatus.Failure;
            }
        }
    }
}