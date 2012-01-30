using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using Styx;
using Styx.Helpers;
using Styx.Logic;
using Styx.Logic.Inventory;
using Styx.Logic.Pathing;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;
using TreeSharp;
using Action = TreeSharp.Action;
using Spell = Styx.Logic.Combat.SpellManager;

namespace AOEDruid
{
    public partial class AOEDruid
    {
        private static LocalPlayer Me
        {
            get { return StyxWoW.Me; }
        }

        private static WoWUnit Target
        {
            get { return StyxWoW.Me.CurrentTarget; }
        }

        private static void Log(string message)
        {
            Logging.Write(Color.White, "[AOEDruid] " + message);
        }

        private void GenerateTargetLists()
        {
            //if (_potentialTargets == null) return;
            //lock (_potentialTargets)
            //{
            //    _potentialTargets.Clear();
            IEnumerable<WoWUnit> localUnits =
                ObjectManager.GetObjectsOfType<WoWUnit>().Where(o => o.Distance < 80 && o.IsAlive && o.Attackable);

            //foreach (var localUnit in localUnits)
            //{
            //    _potentialTargets.Add(new Target(localUnit.BaseAddress));
            //}

            //foreach (var target in _potentialTargets)
            //{
            //    target.Priority = target.Priority - (200 - target.Distance);

            //    if (target.IsPlayer)
            //        target.Priority = target.Priority--;

            //    target.Priority = target.Priority - (100 - target.HealthPercent);

            //    if (target.Elite)
            //        target.Priority = target.Priority--;

            //}
            //    _potentialTargets.OrderBy(o => o.Priority);
            //}
            _combatTargets = localUnits.Where(o => o.WithinInteractRange && o.IsTargetingMeOrPet).Count();
        }

        #region Nested type: BuffBarksin

        private class BuffBarksin : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Buffing Barkskin.");
                return Spell.Cast("Barkskin") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: BuffMotW

        private class BuffMotW : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Buffing Mark of the Wild");
                return Spell.Buff("Mark of the Wild") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: BuffRejuvenation

        private class BuffRejuvenation : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Buffing Rejuvenation.");
                return Spell.Cast("Rejuvenation") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: BuffSurvivalInstincts

        private class BuffSurvivalInstincts : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Buffing Survival Instincts.");
                return Spell.Buff("Survival Instincts") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CanBerserk

        private class CanBerserk : Decorator
        {
            public CanBerserk(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                return Target.HealthPercent > 80 && Spell.CanCast("Berserk");
            }
        }

        #endregion

        #region Nested type: CanFeralCharge

        private class CanFeralCharge : Decorator
        {
            public CanFeralCharge(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                if (Me.IsMoving) return false;
                if (Target.Distance < 8) return false;
                if (Target.Distance > 25) return false;
                if (!Target.InLineOfSight) return false;

                var canCast = Spell.CanCast("Feral Charge (Cat)");
                if (Target.Distance > 25 && canCast)
                {
                    Log("Moving into Feral Charge Range.");
                    Target.Face();
                    var newPoint = WoWMovement.CalculatePointFrom(Target.Location, 24);
                    if (newPoint.Distance(Target.Location) < 25)
                    {
                        Navigator.MoveTo(WoWMovement.CalculatePointFrom(Target.Location, 24));
                        StyxWoW.SleepForLagDuration();
                    }
                }
                return canCast;
            }
        }

        #endregion

        #region Nested type: CanMangle

        private class CanMangle : Decorator
        {
            public CanMangle(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                if (!Target.WithinInteractRange) return false;
                return (Spell.CanCast("Mangle (Cat)"));
            }
        }

        #endregion

        #region Nested type: CanNavigate

        private class CanNavigate : Decorator
        {
            public CanNavigate(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget)
                {
                    Log("I don't have a target?!");
                    return false;
                }
                return !Navigator.CanNavigateFully(Me.Location, Target.Location, 20);
            }
        }

        #endregion

        #region Nested type: CanRavage

        private class CanRavage : Decorator
        {
            public CanRavage(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                if (!Target.WithinInteractRange) return false;
                var stampede = Me.GetAuraById(81022);
                if (stampede != null) if (!stampede.IsActive) return false;
                return Spell.CanCast(81170);
            }
        }

        #endregion

        #region Nested type: CanSwipe

        private class CanSwipe : Decorator
        {
            public CanSwipe(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                if (!Target.IsWithinMeleeRange) return false;
                return Spell.CanCast("Swipe (Cat)");
            }
        }

        #endregion

        #region Nested type: CanTigerFury

        private class CanTigerFury : Decorator
        {
            public CanTigerFury(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (!Me.GotTarget) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                return Target.HealthPercent > 80 && (Spell.CanCast("Tiger's Fury"));
            }
        }

        #endregion

        #region Nested type: CastBerserk

        private class CastBerserk : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Casting Berserk.");
                if (!Me.IsSafelyFacing(Target)) Target.Face();
                return Spell.Cast("Berserk") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CastCatForm

        private class CastCatForm : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Switching to Cat Form");
                return Spell.Cast("Cat Form") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CastFeralCharge

        private class CastFeralCharge : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Casting Feral Charge on " + Target.Name + ".");
                if (!Me.IsSafelyFacing(Target)) Target.Face();
                return Spell.Cast("Feral Charge (Cat)") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CastMangle

        private class CastMangle : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Casting Mangle on " + Target.Name + ".");
                if (!Me.IsSafelyFacing(Target)) Target.Face();
                return Spell.Cast("Mangle (Cat)") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CastRavage

        private class CastRavage : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Stampede is Active, Casting Ravage!");
                if (!Me.IsSafelyFacing(Target)) Target.Face();
                return Spell.Cast(81170) ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CastSwipe

        private class CastSwipe : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Casting Swipe.");
                if (!Me.IsSafelyFacing(Target)) Target.Face();
                return Spell.Cast("Swipe (Cat)") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: CastTigerFury

        private class CastTigerFury : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Casting Tiger's Fury.");
                if (!Me.IsSafelyFacing(Target)) Target.Face();
                return Spell.Cast("Tiger's Fury") ? RunStatus.Success : RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: Eat

        private class Eat : Action
        {
            protected override RunStatus Run(object context)
            {
                WoWItem food = Consumable.GetBestFood(true);
                if (food == null) return RunStatus.Failure;

                Log("Eating " + food.Name);
                CharacterSettings.Instance.FoodName = food.Name;
                Styx.Logic.Common.Rest.Feed();
                return RunStatus.Success;
            }
        }

        #endregion

        #region Nested type: MoveTo

        private class MoveTo : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Out of Range, Moving to Target.");
                Target.Face();
                if (Target.IsMoving)
                {
                    Navigator.MoveTo(Target.Location);
                }
                else
                {
                    var newLoc = WoWMovement.CalculatePointFrom(Target.Location, 3);
                    if (newLoc.Distance(Target.Location) < 4)
                    {
                        Navigator.MoveTo(WoWMovement.CalculatePointFrom(Target.Location, 3));
                        StyxWoW.SleepForLagDuration();
                    }
                    else
                    {
                        Navigator.MoveTo(Target.Location);
                    }
                }
                return RunStatus.Failure;
            }
        }

        #endregion

        #region Nested type: Navigate

        private class Navigate : Action
        {
            protected override RunStatus Run(object context)
            {
                Log("Cannot Navigate to Target: " + Target.Name + ". Blacklisting for 15 seconds.");
                Blacklist.Add(Target.Guid, new TimeSpan(0, 0, 0, 15));

                return RunStatus.Success;
            }
        }

        #endregion

        #region Nested type: NeedBarkskin

        private class NeedBarkskin : Decorator
        {
            public NeedBarkskin(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                return Me.HealthPercent < 90 && Spell.CanCast("Barkskin");
            }
        }

        #endregion

        #region Nested type: NeedCatForm

        private class NeedCatForm : Decorator
        {
            public NeedCatForm(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                return Me.Shapeshift != ShapeshiftForm.Cat && Spell.CanCast("Cat Form");
            }
        }

        #endregion

        #region Nested type: NeedEat

        private class NeedEat : Decorator
        {
            public NeedEat(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (Me.IsSwimming || Me.Mounted) return false;

                Styx.Logic.Common.Rest.RestPercentageHealth = 40;

                return (!Me.HasAura("Food") && Me.HealthPercent < 40);
            }
        }

        #endregion

        #region Nested type: NeedMotW

        private class NeedMotW : Decorator
        {
            public NeedMotW(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                return !Me.HasAura("Mark of the Wild") && Spell.CanBuff("Mark of the Wild");
            }
        }

        #endregion

        #region Nested type: NeedMoveTo

        private class NeedMoveTo : Decorator
        {
            public NeedMoveTo(Composite child) : base(child)
            {

            }

            protected override bool CanRun(object context)
            {
                if (Me.Combat) return false;
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;
                if (Me.Stunned) return false;
                if (!Me.GotTarget) return false;

                if (Me.IsMoving && Target.WithinInteractRange)
                {
                    WoWMovement.MoveStop();
                    return false;
                }

                return !Target.WithinInteractRange;
            }
        }

        #endregion

        #region Nested type: NeedRejuvenation

        private class NeedRejuvenation : Decorator
        {
            public NeedRejuvenation(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (Me.HasAura("Rejuvenation")) return false;
                return Me.HealthPercent < 70 && Spell.CanCast("Rejuvenation");
            }
        }

        #endregion

        #region Nested type: NeedSurvivalInstincts

        private class NeedSurvivalInstincts : Decorator
        {
            public NeedSurvivalInstincts(Composite child) : base(child)
            {
            }

            protected override bool CanRun(object context)
            {
                if (Me.Shapeshift != ShapeshiftForm.Cat) return false;

                return Me.HealthPercent < 60 && Spell.CanCast("Survival Instincts");
            }
        }

        #endregion
    }

    public class Target : WoWUnit
    {
        public double Priority;

        /// <summary/>
        /// <param name="baseAddress">pointer for this object. </param>
        public Target(uint baseAddress) : base(baseAddress)
        {
            Priority = int.MaxValue;
        }
    }
}