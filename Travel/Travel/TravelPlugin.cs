using System;
using System.Collections.Generic;
using System.Linq;
using Styx;
using Styx.Helpers;
using Styx.Logic.Pathing;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace Travel
{
    public class TravelPlugin : HBPlugin
    {
        private readonly WaitTimer _infoRefreshTimer = WaitTimer.OneSecond;
        private FormTravel _mainForm;

        public override bool WantButton
        {
            get { return true; }
        }

        public override string Name
        {
            get { return "TravelPlugin"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0, 0, 1, 0); }
        }

        public override void Pulse()
        {
            if (BotManager.Current.Name != "Combat Bot")
            {
                BotManager.Current.Stop();
                Logging.Write("[TravelPlugin] Cannot run Travel Plugin unless in Combat Bot!");
                BotManager.Instance.SetCurrent(BotManager.Instance.Bots["Combat Bot"]);
            }
            if (_infoRefreshTimer.IsFinished && StyxWoW.IsInGame && StyxWoW.IsInWorld && StyxWoW.GameState != GameState.Zoning)
            {
                WoWGameObject portalObject = new Portal(Portal.GetPortalEntry()).ToObject();
                WoWGameObject transportObject = new Transport(Transport.GetTransportEntry()).ToObject();
                if (transportObject.BaseAddress != 0 && _mainForm != null)
                {
                    _mainForm.lblTransportInfo.Text = "Transport: " + transportObject.Name;
                }
                else
                {
                    if (_mainForm != null) _mainForm.lblTransportInfo.Text = "No Transport Found!";
                }

                if (portalObject.BaseAddress != 0 && _mainForm != null)
                {
                    _mainForm.labelPortalInfo.Text = "Portal: " + portalObject.Name;
                }
                else
                {
                    if (_mainForm != null) _mainForm.labelPortalInfo.Text = "No Portals Found!";
                }
                _infoRefreshTimer.Reset();
            }
        }

        public override void OnButtonPress()
        {
            if (_mainForm == null)
            {
                _mainForm = new FormTravel();
                _mainForm.Show();
            }
            else
            {
                _mainForm.Show();
            }
        }

        #region Nested type: Portal

        public class Portal
        {
            private WoWGameObject _gameObject;

            public Portal(uint entry, WoWPoint location, WoWPoint exitLocation)
            {
                Entry = entry;
                Location = location;
                ExitLocation = exitLocation;
            }

            public Portal(uint entry)
            {
                Entry = entry;
            }

            public uint Entry { get; set; }
            public WoWPoint Location { get; set; }
            public WoWPoint ExitLocation { get; set; }

            public static uint GetPortalEntry()
            {
                IEnumerable<WoWGameObject> portalList =
                    ObjectManager.GetObjectsOfType<WoWGameObject>().Where(
                        o => o.SubType == WoWGameObjectType.SpellCaster && o.Distance < 10);
                return portalList.Count() > 0 ? portalList.First().Entry : 0;
            }

            public WoWGameObject ToObject()
            {
                IEnumerable<WoWGameObject> gameObjectList =
                    ObjectManager.GetObjectsOfType<WoWGameObject>().Where(o => o.Entry == Entry);
                var gameObject = new WoWGameObject(0);
                if (gameObjectList.Count() > 0)
                {
                    gameObject = gameObjectList.First();
                }
                if (gameObject != null)
                {
                    _gameObject = gameObject;
                }
                return _gameObject;
            }
        }

        #endregion

        #region Nested type: Transport

        public class Transport
        {
            private WoWGameObject _gameObject;

            public Transport(uint entry, WoWPoint location, WoWPoint exitLocation, WoWPoint waitLocation,
                             WoWPoint endLocation)
            {
                Entry = entry;
                Location = location;
                ExitLocation = exitLocation;
                WaitLocation = waitLocation;
                EndLocation = endLocation;
            }

            public Transport(uint entry)
            {
                Entry = entry;
            }

            public uint Entry { get; set; }
            public WoWPoint Location { get; set; }
            public WoWPoint ExitLocation { get; set; }
            public WoWPoint WaitLocation { get; set; }
            public WoWPoint EndLocation { get; set; }

            public bool IsValid
            {
                get
                {
                    IEnumerable<WoWObject> obj = ObjectManager.GetObjectsOfType<WoWObject>().Where(o => o.Entry == Entry);
                    return obj.Count() > 0;
                }
            }

            public static uint GetTransportEntry()
            {
                IOrderedEnumerable<WoWGameObject> transportList =
                    ObjectManager.GetObjectsOfType<WoWGameObject>().Where(
                        o => o.SubType == WoWGameObjectType.MapObjectTransport
                             && o.Distance <= 35).OrderBy(o => o.Distance);
                return transportList.Count() > 0 ? transportList.First().Entry : 0;
            }

            public WoWGameObject ToObject()
            {
                IEnumerable<WoWGameObject> gameObjectList =
                    ObjectManager.GetObjectsOfType<WoWGameObject>().Where(o => o.Entry == Entry);
                if (gameObjectList.Count() > 0)
                {
                    return gameObjectList.First();
                }
                else
                {
                    _gameObject = new WoWGameObject(0);
                }
                return _gameObject;
            }
        }

        #endregion
    }
}