using System;
using System.Collections.Generic;
using Styx;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace NotABot
{

    public class Informant
    {
        public WoWPlayer Player;
        public readonly string Name;

        public double LastDistance
        { 
            get
            {
                return _lastDistance;
            }
        }
        public double Distance
        {
            get
            {
                return Player.Distance;
            }
        }

        public int Threat;
        private double _lastDistance; 

        public Informant(WoWPlayer player)
        {
            _lastDistance = player.Distance;
            Name = player.Name;
        }
        

    }

    public class InformantListManager
    {
        private Dictionary<string, Informant> _informantList = new Dictionary<string, Informant>();

        public Dictionary<string, Informant> Informants
        {
            get { return _informantList; }
        }

        public void Pulse()
        {
            PopulateList();
            UpdateInformants();
        }

        private void PopulateList()
        {
            var localPlayers =
                ObjectManager.GetObjectsOfType<WoWPlayer>().FindAll(
                    o => o.Distance <= 100 && !_informantList.ContainsKey(o.Name));

            foreach (var localPlayer in localPlayers)
            {
                _informantList.Add(localPlayer.Name, new Informant(localPlayer));
            }
        }

        private void UpdateInformants()
        {
            var knownPlayers =
                ObjectManager.GetObjectsOfType<WoWPlayer>().FindAll(
                    o => o.Distance <= 100 && _informantList.ContainsKey(o.Name));

            foreach (var knownPlayer in knownPlayers)
            {
                Informant informant = _informantList[knownPlayer.Name];

                if (informant.LastDistance > informant.Distance)
                {
                    if (informant.Threat > 0)
                        informant.Threat--;
                }
                if (informant.LastDistance < informant.Distance)
                {
                    if (informant.Threat < 1000)
                        informant.Threat++;
                }

            }
        }

        #region Chat Functions
        private static void SendWhisper(string user, string message)
        {
            Lua.DoString(String.Format("SendChatMessage(\"{0}\", \"WHISPER\", nil, \"{1}\");", message,
                                           user));
        }

        private static void SendEmote(string emote)
        {
            SendEmote(ObjectManager.Me, emote);
        }

        private static void SendEmote(WoWPlayer user, string emote)
        {
            user.Target();
            switch (emote)
            {
                case "wave":
                    Lua.DoString("SendChatMessage(\"/wave\");");
                    break;

            }
        }
        #endregion

    }


    public class NotABot : HBPlugin
    {
        private DateTime _lastPulse;
        private InformantListManager _ilm;

        public override void Initialize()
        {
            _lastPulse = DateTime.Now;
            _ilm = new InformantListManager();
            FormDebug debug = new FormDebug(_ilm);
            debug.Show();
        }

        public override void Pulse()
        {
            if (DateTime.Now.Subtract(_lastPulse).Seconds > 1 && StyxWoW.IsInGame && StyxWoW.IsInWorld)
            {
                _ilm.Pulse();
                _lastPulse = DateTime.Now;
            }
        }

        public override string Name { get { return "Not A Bot"; } }

        public override string Author { get { return "Smarter"; } }

        public override Version Version { get { return new Version(0, 0, 1, 0); } }
    }
}








