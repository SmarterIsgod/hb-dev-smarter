using System;
using System.Collections.Generic;
using Styx.Helpers;
using Styx.Logic;
using Styx.Logic.BehaviorTree;
using Styx.Logic.Combat;
using Styx.WoWInternals.WoWObjects;
using TreeSharp;
using Action = TreeSharp.Action;
using Sequence = TreeSharp.Sequence;

namespace Styx.Bot.CustomBots
{
    public class CombatBot : BotBase
    {
        #region Overrides of BotBase

        private readonly Version _version = new Version(0, 0, 3);

        public override string Name
        {
            get { return string.Format("Duel/Combat bot [{0}]", _version); }
        }

        private Composite _root;
        public override Composite Root
        {
            get
            {
                return _root ?? (_root = 
                    
                        new Decorator(ret => StyxWoW.Me.Combat || StyxWoW.Me.GotTarget,

                            new PrioritySelector(
                                
                                #region Heal

                                new PrioritySelector(
                                    // Use the Behavior
                                    new Decorator(ctx => RoutineManager.Current.HealBehavior != null,
                                        new Sequence(
                                            RoutineManager.Current.HealBehavior,
                                            new Action(delegate { return RunStatus.Success; })
                                            )
                                        ),

                                    // Don't use the Behavior
                                    new Decorator(ctx => RoutineManager.Current.NeedHeal,
                                        new Sequence(
                                            new Action(ret => TreeRoot.StatusText = "Healing"),
                                            new Action(ret => RoutineManager.Current.Heal())
                                            ))),

                                #endregion

                                #region Combat Buffs

                                new PrioritySelector(
                                    // Use the Behavior
                                    new Decorator(ctx => RoutineManager.Current.CombatBuffBehavior != null,
                                        new Sequence(
                                            RoutineManager.Current.CombatBuffBehavior,
                                            new Action(delegate { return RunStatus.Success; })
                                            )
                                        ),

                                    // Don't use the Behavior
                                    new Decorator(ctx => RoutineManager.Current.NeedCombatBuffs,
                                        new Sequence(
                                            new Action(ret => TreeRoot.StatusText = "Applying Combat Buffs"),
                                            new Action(ret => RoutineManager.Current.CombatBuff())
                                            ))),

                                #endregion

                                #region Combat

                                new PrioritySelector(
                                    // Use the Behavior
                                    new Decorator(ctx => RoutineManager.Current.CombatBehavior != null,
                                        new PrioritySelector(
                                            RoutineManager.Current.CombatBehavior,
                                            new Action(delegate { return RunStatus.Success; })
                                            )),

                                    // Don't use the Behavior
                                    new Sequence(
                                        new Action(ret => TreeRoot.StatusText = "Combat"),
                                        new Action(ret => RoutineManager.Current.Combat())))

                                #endregion

                                )));
            }
        }

        public override PulseFlags PulseFlags
        {
            get { return PulseFlags.All; }
        }

        public override void Start()
        {
            Targeting.Instance.IncludeTargetsFilter += IncludeTargetsFilter;
            StyxSettings.Instance.LogoutForInactivity = false;
        }

        public override void Stop()
        {
            Targeting.Instance.IncludeTargetsFilter -= IncludeTargetsFilter;
            StyxSettings.Instance.LogoutForInactivity = true;
        }

        private static void IncludeTargetsFilter(List<WoWObject> incomingUnits, HashSet<WoWObject> outgoingUnits)
        {
            if(StyxWoW.Me.GotTarget && StyxWoW.Me.CurrentTarget.Attackable)
            {
                outgoingUnits.Add(StyxWoW.Me.CurrentTarget);
            }
        }

        #endregion
    }
}
