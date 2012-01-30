﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;
using System.Globalization;
using System.Drawing;
using System.Windows.Forms;

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
        #region Extensions

        public class DecoratorEx : Decorator
        {
            protected new CanRunDecoratorDelegate Runner { get; private set; }

            public DecoratorEx(CanRunDecoratorDelegate func, Composite decorated)
                : base(decorated)
            {
                Runner = func;
            }

            protected override bool CanRun(object context)
            {
                if (!ObjectManager.IsInGame || Me == null)
                    return false;

                return Runner != null ? Runner(context) : base.CanRun(context);
            }
        }

        public class DecoratorContinueEx : DecoratorContinue
        {
            protected new CanRunDecoratorDelegate Runner { get; private set; }

            public DecoratorContinueEx(CanRunDecoratorDelegate func, Composite decorated)
                : base(decorated)
            {
                Runner = func;
            }

            protected override bool CanRun(object context)
            {
                if (!ObjectManager.IsInGame || Me == null)
                    return false;

                return Runner != null ? Runner(context) : base.CanRun(context);
            }
        }

        #endregion

        #region Behavior Tree Composite Helpers

        public class ActionIdle : Action
        {
            protected override RunStatus Run(object context)
            {
                if (Parent is Selector || Parent is DecoratorEx)
                    return RunStatus.Success;

                return RunStatus.Failure;
            }
        }

        public delegate WoWUnit UnitSelectDelegate(object context);

        public Composite CheckAndUseWand()
        {
            return CheckAndUseWand(ret => true);
        }

        public Composite CheckAndUseWand(CanRunDecoratorDelegate extra)
        {
            return 
                new DecoratorEx(ret => CT != null && CT.IsValid && Instance.Settings.UseWand && extra(ret) && IsNotWanding && CanCast("Shoot"),
                    new PrioritySelector(
                        ApproachToCast("Shoot"),
                        new Action(delegate
                        {
                            Log("Wanding {0}", CT != null && CT.IsValid ? CT.Name : "");
                            bool result = SpellManager.Cast("Shoot");
                            return result ? RunStatus.Success : RunStatus.Failure;
                        })));
        }

        public Composite CreateBuffCheckAndCast(string name)
        {
            return 
                new DecoratorEx(ret => CanCast(name) && !Me.HasAura(name),
                    new Action(delegate
                    {
                        Log("Buffing {0}", name);
                        bool result = SpellManager.Cast(name, Me);
                        wasCasting = true;
                        return result ? RunStatus.Success : RunStatus.Failure;
                    }
                    ));
        }

        public Composite CreateBuffCheckAndCast(string name, CanRunDecoratorDelegate extra)
        {
            return 
                new DecoratorEx(ret => extra(ret) && CanCast(name) && 
                                       (name == "Battle Shout" || name == "Commanding Shout" || !Me.HasAura(name)),
                    new Action(delegate
                    {
                        Log("Buffing {0}", name);
                        bool result = SpellManager.Cast(name, Me);
                        wasCasting = true;
                        return result ? RunStatus.Success : RunStatus.Failure;
                    }
                    ));
        }

        public Composite CreateSpellWithAuraCheckAndCast(string name)
        {
            return
                new DecoratorEx(ret => CT != null && CT.IsValid && CanCast(name, CT) && (!CT.HasAura(name) || !CT.GetAllAuras().Exists(aura => aura.Name == name && aura.CreatorGuid == Me.Guid)),
                    new PrioritySelector(
                        ApproachToCast(name),
                        new Sequence(
                            new Action(ret => Log("Casting {0} on {1}", name, CT != null && CT.IsValid ? CT.Name : "")),
                            new Action(ret => SpellManager.Cast(name)),
                            new Action(ret => wasCasting = true))));
        }

        public Composite CreateSpellWithAuraCheckAndCast(string name, CanRunDecoratorDelegate extra)
        {
            return 
                new DecoratorEx(ret => CT != null && CT.IsValid && extra(ret) && CanCast(name, CT) && (!CT.HasAura(name) || !CT.GetAllAuras().Exists(aura => aura.Name == name && aura.CreatorGuid == Me.Guid)),
                    new PrioritySelector(
                        ApproachToCast(name),
                        new Sequence(
                            new Action(ret => Log("Casting {0} on {1}", name, CT != null && CT.IsValid ? CT.Name : "")),
                            new Action(ret => SpellManager.Cast(name)),
                            new Action(ret => wasCasting = true))));
        }

        public Composite CreateSpellCheckAndCast(string name)
        {
            return CreateSpellCheckAndCast(name, ret => true);
        }

        public Composite CreateSpellCheckAndCast(string name, CanRunDecoratorDelegate extra)
        {
            return CreateSpellCheckAndCast(name, extra, ret => RunStatus.Success);
        }

        public Composite CreateSpellCheckAndCast(string name, CanRunDecoratorDelegate extra, ActionDelegate extraAction)
        {
            return
                new DecoratorEx(ret => CT != null && CT.IsValid && extra(ret) && CanCast(name, CT),
                    new PrioritySelector(
                        ApproachToCast(name),
                        new DecoratorEx(ret => SpellManager.Spells[name].MaxRange == 0 &&
                                               CT.Distance >= 5,
                            new ActionIdle()),
                        new Sequence(
                            new DecoratorContinueEx(ret => SpellManager.Spells[name].CastTime > 0,
                                new Action(delegate
                                    {
                                        WoWMovement.MoveStop();
                                        Thread.Sleep(100);
                                        return RunStatus.Success;
                                    })),
                            new Action(delegate(object ctx) { extraAction(ctx); return RunStatus.Success; }),
                            new Action(ret => Log("Casting {0} on {1}", name, CT != null && CT.IsValid ? CT.Name : "")),
                            new Action(ret => SpellManager.Cast(name)))));
        }

        public Composite CreateActionCheckCondition(CanRunDecoratorDelegate conditioncheck, ActionSucceedDelegate actiontorun)
        {
            return new DecoratorEx(ret => conditioncheck(ret), 
                        new Action(ret => actiontorun(ret)));
        }

        public Composite ApproachToCast(string SpellName)
        {
            return
                new DecoratorEx(ret => CT != null && CT.IsValid && CT.Distance > SpellManager.Spells[SpellName].MaxRange - 2f,
                    new Action(delegate
                        {
                            if (SpellManager.Spells[SpellName].MaxRange == 0 &&
                                (CT.Distance <= CT.InteractRange + 1f ||
                                (!CT.IsPlayer && CT.IsMoving && !CT.Fleeing && CT.CurrentTarget != null && CT.CurrentTarget.IsValid && CT.CurrentTarget == Me)))
                            {
                                WoWMovement.MoveStop();
                                return RunStatus.Failure;
                            }

                            WoWPoint movePoint;

                            if (SpellManager.Spells[SpellName].MaxRange == 0)
                                movePoint = WoWMovement.CalculatePointFrom(CT.Location, CT.InteractRange);
                            else
                                movePoint = WoWMovement.CalculatePointFrom(CT.Location, SpellManager.Spells[SpellName].MaxRange - 5);

                            Navigator.MoveTo(movePoint);
                            Thread.Sleep(100);
                            return RunStatus.Success;
                        }));
        }

        #endregion

        #region IsSafelyFacing

        private static bool IsSafelyFacing(WoWUnit unit)
        {
            return WoWMathHelper.IsFacing(Me.Location, Me.Rotation, unit.Location, WoWMathHelper.DegreesToRadians(120));
        }

        #endregion

        #region Adds

        private static List<WoWUnit> Adds
        {
            get
            {
                return ObjectManager.GetObjectsOfType<WoWUnit>().FindAll(u => u != null && u.IsValid &&
                                                                              (CT == null || !CT.IsValid || u != CT) &&
                                                                              u.Attackable &&
                                                                              !u.IsFriendly &&
                                                                              !Styx.Logic.Blacklist.Contains(u) &&
                                                                              !u.IsTotem &&
                                                                              (u.IsTargetingMeOrPet ||
                                                                              u.IsTargetingMyPartyMember));
            }
        }

        #endregion

        #region RandomNumber

        private static int RandomNumber(int min, int max)
        {
            Random random = new Random();
            return random.Next(min, max);
        }

        #endregion

        #region Log

        private static void Log(string format, params object[] args)
        {
            Logging.Write(Color.DarkSlateBlue, string.Format("[Ensemble v{0}]:", pVersion) + format, args);
        }

        private static void dLog(string format, params object[] args)
        {
            Logging.WriteDebug(Color.DarkSlateBlue, string.Format("[Ensemble v{0}]:", pVersion) + format, args);
        }

        private static void Log(Color color, string format, params object[] args)
        {
            Logging.Write(color, string.Format("[Ensemble v{0}]:", pVersion) + format, args);
        }

        #endregion

        #region CanCast

        private static bool CanCast(string name)
        {
            return CanCast(name, Me);
        }

        private static bool CanCast(string name, WoWUnit unit)
        {
            // Do we have spell?
            if (!SpellManager.Spells.ContainsKey(name))
                return false;

            WoWSpell spell = SpellManager.Spells[name];

            // Is the unit in immunity list?
            if (ImmunityMap.ContainsKey(spell.School) && 
                ImmunityMap[spell.School].Contains(unit != null && unit.IsValid ? unit.Guid : 0))
                return false;

            // is spell in CD?
            if (spell.Cooldown)
                return false;

            // are we casting or channeling ?
            if (Me.IsCasting || Me.ChanneledCastingSpellId != 0)
                return false;

            // do we have enough power?
            if (Me.GetCurrentPower(spell.PowerType) < spell.PowerCost)
                return false;

            if (StyxWoW.GlobalCooldown)
                return false;

            // lua
            if (!spell.CanCast)
                return false;

            return true;
        }

        #endregion

        #region Wanding

        private static bool HasWand
        {
            get
            {
                return Me.Inventory.Equipped.Ranged != null && 
                       Me.Inventory.Equipped.Ranged.ItemInfo.WeaponClass == WoWItemWeaponClass.Wand;
            }
        }

        private static bool IsNotWanding
        {
            get
            {
                if (Lua.GetReturnVal<int>("return IsAutoRepeatSpell(\"Shoot\")", 0) == 1) { return false; }
                
                if (!HasWand) { return false; }

                return true;
            }
        }

        #endregion

        #region EnemyNearby

        public static bool EnemyNearby
        {
            get
            {
                List<WoWUnit> enemyList = ObjectManager.GetObjectsOfType<WoWUnit>(false).FindAll(unit =>
                                unit != null && unit.IsValid &&
                                unit.Attackable &&
                                !unit.IsFriendly &&
                                unit != Me &&
                                unit.Distance < 7 &&
                                unit.IsPlayer);

                if (enemyList.Count > 0)
                    return true;

                return false;
            }
        }

        #endregion

        #region BattleGround

        private static bool IsInBattleground
        {
            get
            {
                return Styx.Logic.Battlegrounds.IsInsideBattleground;
            }
        }

        #endregion

        #region Dispel/Disease Blacklist

        private static List<string> dispelBlacklist = new List<string>()
        {
            "Unstable Affliction",
            "Vampiric Touch",
            "Faerie Fire (Feral)"
        };

        private static List<string> diseaseBlacklist = new List<string>()
        {

        };

        #endregion

        #region HasTalent

        private static bool HasTalent(int tabIndex, int talentIndex)
        {
            var returnValue = Lua.GetReturnValues("return GetTalentInfo(" + tabIndex + "," + talentIndex + ",false)");
            if (returnValue != null)
                return int.Parse(returnValue[4]) > 0;
            return false;
        }

        #endregion

        #region HasGlyph

        private static bool HasGlyph(string glyphName)
        {
            int glyphCount = Lua.GetReturnVal<int>("return GetNumGlyphSockets()", 0);

            if (glyphCount == 0)
                return false;

            for (int i = 1; i <= glyphCount; i++)
            {
                var nameOfGlyph = Lua.GetReturnValues("return GetGlyphSocketInfo(" + i + "," + _talentManager.Spec + ")");

                if (nameOfGlyph != null && nameOfGlyph[3] != "nil" && WoWSpell.FromId(int.Parse(nameOfGlyph[3])).Name == "Glyph of " + glyphName)
                {
                    return true;
                }
            }
            return false;
        }

        #endregion

        #region HasItem

        private static bool HasItem(string name)
        {
            return Me.BagItems.Exists(i => i.Name == name);
        }

        #endregion

        #region ShallCastHS

        private static Stopwatch hsTimer = new Stopwatch();
        private static bool ShallCastHS
        {
            get
            {
                if (!hsTimer.IsRunning)
                {
                    hsTimer.Start();
                    return true;
                }

                if (hsTimer.ElapsedMilliseconds >= 2000)
                {
                    hsTimer.Reset();
                    hsTimer.Start();
                    return true;
                }
                return false;
            }
        }

        #endregion

        #region Lua Events

        private void HandleTalentChange(object sender, LuaEventArgs args)
        {
            _talentManager = new TalentManager();

            switch (Me.Class)
            {
                case WoWClass.DeathKnight:
                    CurrentSpec = ((DeathKnightTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Druid:
                    CurrentSpec = ((DruidTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Hunter:
                    CurrentSpec = ((HunterTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Mage:
                    CurrentSpec = ((MageTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Paladin:
                    CurrentSpec = ((PaladinTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Priest:
                    CurrentSpec = ((PriestTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Rogue:
                    CurrentSpec = ((RogueTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Shaman:
                    CurrentSpec = ((ShamanTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Warlock:
                    CurrentSpec = ((WarlockTalentSpec)_talentManager.Spec).ToString();
                    break;

                case WoWClass.Warrior:
                    CurrentSpec = ((WarriorTalentSpec)_talentManager.Spec).ToString();
                    break;
            }

            Log("Your current spec has been changed to {0}", CurrentSpec);

            if (Me.Class == WoWClass.DeathKnight ||
                (Me.Class == WoWClass.Druid && CurrentSpec != "Restoration") ||
                Me.Class == WoWClass.Hunter ||
                Me.Class == WoWClass.Mage ||
                (Me.Class == WoWClass.Paladin && CurrentSpec != "Protection") ||
                Me.Class == WoWClass.Rogue ||
                Me.Class == WoWClass.Shaman ||
                Me.Class == WoWClass.Warlock ||
                (Me.Class == WoWClass.Warrior && CurrentSpec != "Protection"))
            {
                string nl = Environment.NewLine;
                MessageBox.Show("Ensemble currently supports:" + nl + nl +
                                "Druid - Restoration" + nl +
                                "Paladin - Protection" + nl +
                                "Priest - Discipline/Holy/Shadow" + nl +
                                "Warrior - Protection",
                                "Your current spec is not yet supported!",
                                MessageBoxButtons.OK, MessageBoxIcon.Error,
                                MessageBoxDefaultButton.Button1, MessageBoxOptions.ServiceNotification);
            }

            if (CurrentSpec == "Blood" ||
                CurrentSpec == "Feral" && Instance.Settings.DruidTankMode ||
                CurrentSpec == "Protection")
                MyType = "tank";
            else if (CurrentSpec == "Restoration" ||
                     CurrentSpec == "Holy" ||
                     CurrentSpec == "Discipline")
                MyType = "healer";
            else if (Me.Class == WoWClass.DeathKnight ||
                     CurrentSpec == "Feral" ||
                     Me.Class == WoWClass.Paladin ||
                     Me.Class == WoWClass.Rogue ||
                     CurrentSpec == "Enhancement" ||
                     Me.Class == WoWClass.Warrior)
                MyType = "melee";
            else
                MyType = "caster";
        }

        private static Dictionary<WoWSpellSchool, HashSet<ulong>> ImmunityMap = new Dictionary<WoWSpellSchool, HashSet<ulong>>();

        private void HandleCombatLogEvent(object sender, LuaEventArgs args)
        {
            switch (args.Args[1].ToString())
            {
                case "SPELL_MISSED":
                    
                    if (args.Args[11].ToString() == "IMMUNE")
                    {
                        try
                        {
                            var spellSchool = (WoWSpellSchool)(int)(double)args.Args[10];

                            ulong aguid = ulong.Parse(args.Args[2].ToString().Replace("0x", ""), NumberStyles.HexNumber);
                            if (Me.Guid != aguid) return;

                            ulong guid = ulong.Parse(args.Args[5].ToString().Replace("0x", ""), NumberStyles.HexNumber);

                            var obj = ObjectManager.GetObjectsOfType<WoWUnit>(true, true).FirstOrDefault(o => o != null && o.IsValid && (o.Guid == guid || o.DescriptorGuid == guid));

                            if (obj == null || !obj.IsValid)
                            {
                                Log("Can't find the object in the object manager...");
                                return;
                            }
                            
                            if (!ImmunityMap.ContainsKey(spellSchool))
                                ImmunityMap[spellSchool] = new HashSet<ulong>();

                            if (!ImmunityMap[spellSchool].Contains(obj.Guid))
                            {
                                Log("Adding " + obj.Name + " [" + obj.Guid + "] to the " + spellSchool + " immunity list.");
                                ImmunityMap[spellSchool].Add(obj.Guid);
                            }
                        }
                        catch (Exception e)
                        {
                            dLog(e.ToString());
                        }
                    }
                    
                    if (args.Args[11].ToString() == "EVADE")
                    {
                        try
                        {
                            ulong aguid = ulong.Parse(args.Args[2].ToString().Replace("0x", ""), NumberStyles.HexNumber);

                            ulong guid = ulong.Parse(args.Args[5].ToString().Replace("0x", ""), NumberStyles.HexNumber);

                            var obj = ObjectManager.GetObjectsOfType<WoWUnit>(true, true).FirstOrDefault(o => o != null && o.IsValid && (o.Guid == guid || o.DescriptorGuid == guid));
                            
                            if (obj == null || !obj.IsValid)
                            {
                                Log("Can't find the object in the object manager...");
                                return;
                            }

                            Styx.Logic.Blacklist.Add(obj, TimeSpan.FromMinutes(10));
                            Log("Evading mob detected: {0} Blacklisting", obj.Name);
                            
                            if (obj == CT)
                                Me.ClearTarget();
                        }
                        catch (Exception e)
                        {
                            dLog(e.ToString());
                        }
                    }
                    break;
            }
        }

        private void HandleSpellSucceededEvent(object sender, LuaEventArgs args)
        {
            if (args.Args[0].ToString().ToLower() != "player")
                return;

            StyxWoW.SleepForLagDuration();
            ObjectManager.Update();
        }

        #endregion
    }
}
