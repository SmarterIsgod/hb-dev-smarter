using Styx.Combat.CombatRoutine;
using Styx.Helpers;
using TreeSharp;

namespace AOEDruid
{
    public partial class AOEDruid : CombatRoutine
    {
        //private readonly List<Target> _potentialTargets = new List<Target>();

        private readonly WaitTimer _targetListTimer = WaitTimer.FiveSeconds;
        private Composite _combatBehavior;
        private int _combatTargets;
        private Composite _pullBehavior;


        private Composite _pullBuffBehavior;
        private Composite _restBehavior;

        public override string Name
        {
            get { return "AOEDruid"; }
        }

        public override WoWClass Class
        {
            get { return WoWClass.Druid; }
        }

        public override Composite PullBuffBehavior
        {
            get
            {
                if (_pullBuffBehavior == null)
                {
                    Log("Creating Pull Buff Behavior...");
                    _pullBuffBehavior = CreatePullBuffBehavior();
                }
                return _pullBuffBehavior;
            }
        }

        public override Composite PullBehavior
        {
            get
            {
                if (_pullBehavior == null)
                {
                    Log("Creating Pull Behavior...");
                    _pullBehavior = CreatePullBehvaior();
                }
                return _pullBehavior;
            }
        }

        public override Composite CombatBehavior
        {
            get
            {
                if (_combatBehavior == null)
                {
                    Log("Creating Combat Behavior...");
                    _combatBehavior = CreateCombatBehavior();
                }
                return _combatBehavior;
            }
        }

        public override Composite RestBehavior
        {
            get
            {
                if (_restBehavior == null)
                {
                    Log("Creating Rest Behavior...");
                    _restBehavior = CreateRestBehavior();
                }
                return _restBehavior;
            }
        }

        public override void Pulse()
        {
            if (_targetListTimer.IsFinished)
            {
                GenerateTargetLists();
                //if (_potentialTargets.Count > 0)
                //{
                //    if (_potentialTargets.First() != Target)
                //        _potentialTargets.First().Target();
                //}
                _targetListTimer.Reset();
            }
        }
    }
}