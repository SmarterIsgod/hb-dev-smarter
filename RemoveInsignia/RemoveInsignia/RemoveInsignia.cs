using System;
using System.Linq;
using Styx;
using Styx.Helpers;
using Styx.Logic;
using Styx.Logic.Combat;
using Styx.Logic.Pathing;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace RemoveInsignia
{
    public class RemoveInsignia : HBPlugin
    {
        public override string Name
        {
            get { return "Remove Insignia"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0, 0, 1, 0); }
        }

        private static void Log(string message)
        {
            Logging.WriteDebug("[RI] " + message);
        }

        private readonly WaitTimer _insigniaCheckTimer = WaitTimer.FiveSeconds;
        public override void Pulse()
        {
            if (!StyxWoW.Me.IsAlive || !Battlegrounds.IsInsideBattleground) return;

            if (!_insigniaCheckTimer.IsFinished) return;
            Log("I'm in a Battleground, and the Timer is Finished!");

            var deadPlayers =
                ObjectManager.GetObjectsOfType<WoWPlayer>(false, false).Where(o => o.Dead && !o.IsPet && o.Distance <= 80 && o.IsHostile).
                    OrderBy(o => o.Distance);

            if (deadPlayers.Count() > 0)
            {
                Log("There are " + deadPlayers.Count() + " dead players nearby.");
                var currentPlayer = deadPlayers.FirstOrDefault();

                if (currentPlayer != null && !Blacklist.Contains(currentPlayer))
                {
                    while (!currentPlayer.WithinInteractRange)
                    {
                        Log(currentPlayer.Name + " selected, player not in range.");
                        if (StyxWoW.Me.Combat)
                        {
                            RoutineManager.Current.Combat();
                        }
                        else
                        {
                            Navigator.MoveTo(currentPlayer.Location);
                        }
                    }
                    while (currentPlayer.WithinInteractRange)
                    {
                        Log(currentPlayer.Name + " is within range, removing insignia.");
                        currentPlayer.Interact();
                        Blacklist.Add(currentPlayer, new TimeSpan(0,0,0,30));
                    }
                }
            }
            _insigniaCheckTimer.Reset();
        }
    }
}