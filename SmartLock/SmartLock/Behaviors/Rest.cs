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
        private Composite CreateRestBehavior
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

                            new DecoratorEx(ret => Me.Class == WoWClass.Druid ||
                                                   Me.Class == WoWClass.Paladin ||
                                                   Me.Class == WoWClass.Priest ||
                                                   Me.Class == WoWClass.Shaman,
                                HealBehavior),
                            new DecoratorEx(ret => !Me.IsSwimming &&
                                                 !Me.HasAura("Food") &&
                                                 !Me.HasAura("Drink") &&
                                                 Me.HealthPercent > 1 &&
                                                 (Me.HealthPercent < Instance.Settings.RestHealth ||
                                                 Me.ManaPercent < Instance.Settings.RestMana),
                                new PrioritySelector(
                                    CreateBuffCheckAndCast("Hymn of Hope"),
                                    new Action(delegate
                                        {
                                            bool result = false;

                                            WoWItem bestDrink = null;
                                            WoWItem bestFood = null;

                                            if (LevelbotSettings.Instance.DrinkName == null ||
                                                !Me.BagItems.Exists(x => x.Entry.ToString() == LevelbotSettings.Instance.DrinkName))
                                            {
                                                bestDrink = Me.BagItems.
                                                                Where(x => x != null && x.IsValid && x.ItemInfo != null && 
                                                                           x.ItemInfo.ItemClass == WoWItemClass.Consumable &&
                                                                           x.ItemInfo.RequiredLevel <= Me.Level &&
                                                                           x.ItemInfo.SpellId != null &&
                                                                           WoWSpell.FromId(x.ItemInfo.SpellId[0]) != null &&
                                                                           (WoWSpell.FromId(x.ItemInfo.SpellId[0]).Name == "Drink" ||
                                                                           WoWSpell.FromId(x.ItemInfo.SpellId[0]).Name == "Refreshment")).
                                                                OrderByDescending(x => x.ItemInfo.RequiredLevel).
                                                                FirstOrDefault();
                                                if (bestDrink != null && bestDrink.IsValid)
                                                {
                                                    LevelbotSettings.Instance.DrinkName = bestDrink.Entry.ToString();
                                                    Log("Changed drink to \"{0}\"", bestDrink.Name);
                                                }
                                                else
                                                {
                                                    Log("You don't have any drinks in your bags");
                                                }
                                            }

                                            if (LevelbotSettings.Instance.FoodName == null ||
                                                !Me.BagItems.Exists(x => x.Entry.ToString() == LevelbotSettings.Instance.FoodName))
                                            {
                                                bestFood = Me.BagItems.
                                                                Where(x => x != null && x.IsValid && x.ItemInfo != null &&
                                                                           x.ItemInfo.ItemClass == WoWItemClass.Consumable &&
                                                                           x.ItemInfo.RequiredLevel <= Me.Level &&
                                                                           x.ItemInfo.SpellId != null &&
                                                                           WoWSpell.FromId(x.ItemInfo.SpellId[0]) != null &&
                                                                           (WoWSpell.FromId(x.ItemInfo.SpellId[0]).Name == "Food" ||
                                                                           WoWSpell.FromId(x.ItemInfo.SpellId[0]).Name == "Refreshment")).
                                                                OrderByDescending(x => x.ItemInfo.RequiredLevel).
                                                                FirstOrDefault();
                                                if (bestFood != null && bestFood.IsValid)
                                                {
                                                    LevelbotSettings.Instance.FoodName = bestFood.Entry.ToString();
                                                    Log("Changed food to \"{0}\"", bestFood.Name);
                                                }
                                                else
                                                    Log("You don't have any foods in your bags");
                                            }

                                            Styx.Logic.Common.Rest.Feed();
                                            Thread.Sleep(100);

                                            if (Me.HasAura("Food") || Me.HasAura("Drink")) result = true;

                                            return result ? RunStatus.Success : RunStatus.Failure;
                                        }))));
            }
        }

        #region Composites

        #region CheckAndClearDeadTarget
        private static Stopwatch clearTimer = new Stopwatch();
        private Composite CheckAndClearDeadTarget
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => CT != null &&
                                                   CT.IsValid &&
                                                   CT.Dead &&
                                                   (BotPoi.Current.Type != PoiType.Loot ||
                                                   BotPoi.Current.Type != PoiType.Skin),
                                new Action(delegate
                                {
                                    if (!clearTimer.IsRunning)
                                        clearTimer.Start();

                                    if (clearTimer.ElapsedMilliseconds < 2000)
                                        return RunStatus.Failure;

                                    Me.ClearTarget();
                                    Thread.Sleep(100);
                                    clearTimer.Reset();
                                    return RunStatus.Success;
                                })));
            }
        }

        #endregion

        #region CheckAndTargetTotems

        private static WoWUnit totemTarget;
        private Composite CheckAndTargetTotems
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(delegate
                            {
                                totemTarget = ObjectManager.GetObjectsOfType<WoWUnit>().FirstOrDefault(unit =>
                                    unit != null &&
                                    unit.IsValid &&
                                    unit.Attackable &&
                                    unit.Aggro &&
                                    unit.CreatureType == WoWCreatureType.Totem &&
                                    unit.Distance < 30);

                                return totemTarget == null || !totemTarget.IsValid ? false : CT == null || !CT.IsValid ? true : false;
                            },
                                new Action(delegate
                                {
                                    Log("Targeting agro totem");
                                    totemTarget.Target();
                                    Thread.Sleep(100);
                                    return RunStatus.Success;
                                })));
            }
        }

        #endregion

        #region CheckAndTargetAggroMob

        private Composite CheckAndTargetAggroMob
        {
            get
            {
                return
                    new PrioritySelector(
                        new DecoratorEx(ret => !Me.IsInInstance &&
                                               (CT == null ||
                                               !CT.IsValid) &&
                                               Adds.Count > 0,
                            new Action(delegate
                            {
                                Adds[0].Target();
                                Thread.Sleep(100);
                                return RunStatus.Success;
                            })));
            }
        }

        #endregion

        #region CheckAndAssistPet

        private Composite CheckAndAssistPet
        {
            get
            {
                return new PrioritySelector(
                            new DecoratorEx(ret => Me.GotAlivePet &&
                                                   Me.Pet.CurrentTarget != null &&
                                                   Me.Pet.CurrentTarget.IsValid &&
                                                   (CT == null || !CT.IsValid),
                                new Action(delegate
                                {
                                    Log("Assisting pet");
                                    Me.Pet.CurrentTarget.Target();
                                    Thread.Sleep(100);
                                    return RunStatus.Success;
                                })));
            }
        }

        #endregion

        #endregion
    }
}
