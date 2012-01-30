using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;
using System.Net;
using System.Windows.Forms;
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
        #region Variables

        private static string MyType;
        private static bool wasCasting;
        private static string CurrentSpec;
        public delegate bool CastRequirements(WoWUnit unit);
        private static TalentManager _talentManager = new TalentManager();
        public EnsembleSettings Settings { get; set; }
        public static Ensemble Instance { get; set; }
        private static LocalPlayer Me { get { return ObjectManager.Me; } }
        private static WoWUnit CT { get { return Me.CurrentTarget; } }
        #endregion

        #region Overrides

        private static readonly Version pVersion = new Version(1, 1, 0);
        public override sealed string Name { get { return string.Format("Ensemble - The Ultimate All-In-One CC v{0} by raphus", pVersion); } }
        public override WoWClass Class
        {   
            get 
            {
                if (Me.Class == WoWClass.Druid ||
                            Me.Class == WoWClass.Priest ||
                            Me.Class == WoWClass.Paladin ||
                            Me.Class == WoWClass.Warrior/*||
                Me.Class == WoWClass.Shaman*/)
                    return Me.Class;
                else
                    return WoWClass.None;
            }
        }
        public override bool WantButton { get { return true; } }
        public override void OnButtonPress()
        {
            switch (Me.Class)
            {
                case WoWClass.DeathKnight:
                    new DeathKnightForm().ShowDialog();
                    break;

                case WoWClass.Druid:
                    new DruidForm().ShowDialog();
                    break;

                case WoWClass.Hunter:
                    new HunterForm().ShowDialog();
                    break;

                case WoWClass.Mage:
                    new MageForm().ShowDialog();
                    break;

                case WoWClass.Paladin:
                    new PaladinForm().ShowDialog();
                    break;

                case WoWClass.Priest:
                    new PriestForm().ShowDialog();
                    break;

                case WoWClass.Rogue:
                    new RogueForm().ShowDialog();
                    break;

                case WoWClass.Shaman:
                    new ShamanForm().ShowDialog();
                    break;

                case WoWClass.Warlock:
                    new WarlockForm().ShowDialog();
                    break;

                case WoWClass.Warrior:
                    new WarriorForm().ShowDialog();
                    break;
            }
        }

        #endregion

        #region Init

        public Ensemble()
        {
            Instance = this;
            Settings = new EnsembleSettings();
        }

        public override void Initialize()
        {
            Lua.Events.AttachEvent("ACTIVE_TALENT_GROUP_CHANGED", HandleTalentChange);
            Lua.Events.AttachEvent("COMBAT_LOG_EVENT_UNFILTERED", HandleCombatLogEvent);
            //Lua.Events.AttachEvent("UNIT_SPELLCAST_SUCCEEDED", HandleSpellSucceededEvent);
            //Lua.Events.AttachEvent("UNIT_SPELLCAST_CHANNEL_STOP", HandleSpellSucceededEvent);

            BotEvents.OnBotStopped += new BotEvents.OnBotStopDelegate(onBotStop);
            Log("Ensemble has been loaded successfully");

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

            Log("Your current spec is {0}", CurrentSpec);

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

        #endregion
        private void onBotStop(EventArgs e)
        {
            updateTimer.Reset();
        }

        #region Pull Buff Behavior

        private Composite _pullBuffBehavior;
        public override Composite PullBuffBehavior
        {
            get { if (_pullBuffBehavior == null) { _pullBuffBehavior = CreatePullBuffBehavior; } return _pullBuffBehavior; }
        }

        #endregion

        #region Pull Behavior

        private Composite _pullBehavior;
        public override Composite PullBehavior
        {
            get { if (_pullBehavior == null) { _pullBehavior = CreatePullBehavior; } return _pullBehavior; }
        }

        #endregion

        #region Combat Behavior

        private Composite _combatBehavior;
        public override Composite CombatBehavior
        {
            get { if (_combatBehavior == null) { _combatBehavior = CreateCombatBehavior; } return _combatBehavior; }
        }

        #endregion

        #region Combat Buff Behavior

        private Composite _combatBuffBehavior;
        public override Composite CombatBuffBehavior
        {
            get { if (_combatBuffBehavior == null) { _combatBuffBehavior = CreateCombatBuffBehavior; } return _combatBuffBehavior; }
        }

        #endregion

        #region Heal Behavior

        private Composite _healBehavior;
        public override Composite HealBehavior
        {
            get { if (_healBehavior == null) { _healBehavior = CreateHealBehavior; } return _healBehavior; }
        }   

        #endregion

        #region Rest Behavior

        private Composite _restBehavior;
        public override Composite RestBehavior
        {
            get { if (_restBehavior == null) { _restBehavior = CreateRestBehavior; } return _restBehavior; }
        }

        #endregion

        #region Pre Combat Buff Behavior

        private Composite _preCombatBuffBehavior;
        public override Composite PreCombatBuffBehavior
        {
            get { if (_preCombatBuffBehavior == null) { _preCombatBuffBehavior = CreatePreCombatBuffsBehavior; } return _preCombatBuffBehavior; }
        }

        #endregion

        #region Pulse

        private Stopwatch updateTimer = new Stopwatch();
        public override void Pulse()
        {
            if (!updateTimer.IsRunning)
            {
                updateTimer.Start();
                Update();
            }

            if (updateTimer.Elapsed.Minutes >= 5)
                updateTimer.Reset();
        }

        #endregion
    }
}
