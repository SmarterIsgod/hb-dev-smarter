using System;
using System.Linq;
using System.Windows.Forms;
using Styx;
using Styx.Logic.Pathing;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace TransportBuddy
{
    public partial class FormMain : Form
    {
        private WoWPoint _getOff;
        private WoWPoint _standOn;
        private WoWGameObject _transport;
        private WoWPoint _transportEnd;
        private uint _transportId;
        private WoWPoint _transportStart;
        private WoWPoint _waitAt;

        public FormMain()
        {
            InitializeComponent();
        }

        private void ButtonWaitAtClick(object sender, EventArgs e)
        {
            _waitAt = ObjectManager.Me.Location;
        }

        private void ButtonOnTransportClick(object sender, EventArgs e)
        {
            _transport =
                ObjectManager.GetObjectsOfType<WoWGameObject>().FindAll(
                    o => o.SubType == WoWGameObjectType.MapObjectTransport).OrderBy(o => o.Distance).FirstOrDefault();
            _transportId = _transport.Entry;
            _transportStart = _transport.Location;
            _standOn = ObjectManager.Me.Location;
        }

        private void ButtonDestinationClick(object sender, EventArgs e)
        {
            _transportEnd = _transport.Location;
        }

        private void ButtonOffTransportClick(object sender, EventArgs e)
        {
            _getOff = ObjectManager.Me.Location;
            textBoxCode.Text = "TransportId=\"" + _transportId + "\"" +
                               "\r\nWaitAtX=\"" + _waitAt.X + "\" WaitAtY=\"" + _waitAt.Y + "\" WaitAtZ=\"" + _waitAt.Z +
                               "\"" +
                               "\r\nTransportStartX=\"" + _transportStart.X + "\" TransportStartY=\"" +
                               _transportStart.Y +
                               "\" TransportStartZ=\"" + _transportStart.Z + "\"" +
                               "\r\nTransportEndX=\"" + _transportEnd.X + "\" TransportEndY=\"" + _transportEnd.Y +
                               "\" TransportEndZ=\"" + _transportEnd.Z + "\"" +
                               "\r\nGetOffX=\"" + _getOff.X + "\" GetOffY=\"" + _getOff.Y + "\" GetOffZ=\"" + _getOff.Z +
                               "\"" +
                               "\r\nStandOnX=\"" + _standOn.X + "\" StandOnY=\"" + _standOn.Y + "\" StandOnZ=\"" +
                               _standOn.Z + "\"";
            MessageBox.Show("UseTransport Code Generated!");
        }

        private void ButtonZoneInfoClick(object sender, EventArgs e)
        {
            textBoxZoneInfo.Clear();
            textBoxZoneInfo.Text = "MapID: " + ObjectManager.Me.MapId + " MapName: " + ObjectManager.Me.MapName +
                                   "\r\nZoneID: " + ObjectManager.Me.ZoneId + " ZoneText: " +
                                   ObjectManager.Me.MinimapZoneText +
                                   "\r\nSubZoneText: " + ObjectManager.Me.SubZoneText + " RealZoneText: " +
                                   ObjectManager.Me.RealZoneText;
        }
    }
}