using System;
using System.Diagnostics;
using System.Windows.Forms;
using Styx;
using Styx.Helpers;
using Styx.Logic.Pathing;
using Styx.WoWInternals.WoWObjects;

namespace Travel
{
    public partial class FormTravel : Form
    {
        public FormTravel()
        {
            InitializeComponent();
            labelPortalInfo.Text = "No Portal Found!";
        }

        private void BtnGrabInfoUsePortalClick(object sender, EventArgs e)
        {
            uint portalEntry = TravelPlugin.Portal.GetPortalEntry();
            if (portalEntry != 0)
            {
                WoWGameObject portalObject = new TravelPlugin.Portal(portalEntry).ToObject();
                uint startZoneId = StyxWoW.Me.ZoneId;
                uint startMapId = StyxWoW.Me.MapId;
                while (!portalObject.WithinInteractRange)
                {
                    Navigator.MoveTo(portalObject.Location);
                }
                portalObject.Interact();
                DateTime startTime = DateTime.Now;
                while (StyxWoW.Me.ZoneId == startZoneId)
                {
                    StyxWoW.SleepForLagDuration();
                }
                TimeSpan loadTime = DateTime.Now - startTime;
                uint endMapId = StyxWoW.Me.MapId;
                uint endZoneId = StyxWoW.Me.ZoneId;
                textOutput.Text = string.Format("Portal Name: {0}\n\n" +
                                                "Entry: {1}\n\n" +
                                                "Location: {2}\n\n" +
                                                "Start MapId: {3}\n\n" +
                                                "Start ZoneId: {4}\n\n" +
                                                "End MapId: {5}\n\n" +
                                                "End ZoneId: {6}\n\n" +
                                                "Load Time: {7}", portalObject.Name, portalEntry, portalObject.Location,
                                                startMapId, startZoneId, endMapId, endZoneId, loadTime.TotalMilliseconds);
                string postData = "[CODE]\nFrom: --EDIT THIS --\nTo: --EDIT THIS-- \n" + textOutput.Text + "[/CODE]";
                Clipboard.SetText(postData);
                Process.Start("http://www.thebuddyforum.com/newreply.php?do=newreply&p=409015&noquote=1");
                MessageBox.Show("Post Data has been copied to your Clipboard, please Post this Data on the Forums.");
            }
            else
            {
                Logging.Write("[TravelPlugin] No portals found! Be sure to be withing [10 Yards]!");
                return;
            }
        }

        private void BtnGrabTransportUseClick(object sender, EventArgs e)
        {
            uint transportEntry = TravelPlugin.Transport.GetTransportEntry();
            if (transportEntry != 0)
            {
                WoWGameObject transportObject = new TravelPlugin.Transport(transportEntry).ToObject();
                uint startZoneId = StyxWoW.Me.ZoneId;
                uint startMapId = StyxWoW.Me.MapId;
                MessageBox.Show("Please stand in the Starting Position, do not Click \"Okay\" until you are there." +
                                "\n\nNOTE: Be sure this is a DIRECT LINE from standing to boarded!");
                WoWPoint charStartLocation = StyxWoW.Me.Location;
                MessageBox.Show("Please step onto the Transport.");
                while (!StyxWoW.Me.IsOnTransport)
                {
                    MessageBox.Show("You are not on a transport!");
                }
                var transportStartLocation = new WoWPoint(transportObject.GetWorldMatrix().M41,
                                                          transportObject.GetWorldMatrix().M42,
                                                          transportObject.GetWorldMatrix().M43);

                MessageBox.Show("Please do not move from this location until the transport has come to a COMPLETE stop.");

                DateTime startTime = DateTime.Now;
                while (StyxWoW.Me.ZoneId == startZoneId)
                {
                    MessageBox.Show("DO NOT MOVE / CLICK OKAY UNTIL THE TRANSPORT HAS COME TO A COMPLETE STOP.");
                }

                TimeSpan loadTime = DateTime.Now - startTime;
                var transportEndLocation = new WoWPoint(transportObject.GetWorldMatrix().M41,
                                                        transportObject.GetWorldMatrix().M42,
                                                        transportObject.GetWorldMatrix().M43);

                MessageBox.Show("Please step off the Transport." +
                                "\n\nNOTE: Be sure this is a DIRECT LINE from boarded to standing!");
                while (StyxWoW.Me.IsOnTransport)
                {
                    StyxWoW.SleepForLagDuration();
                }

                MessageBox.Show("Please assure you are in your preferred location before clicking Okay.");
                WoWPoint charEndLocation = StyxWoW.Me.Location;

                uint endMapId = StyxWoW.Me.MapId;
                uint endZoneId = StyxWoW.Me.ZoneId;
                textOutput.Text = string.Format("Transport Name: {0}\n\n" +
                                                "Entry: {1}\n\n" +
                                                "CharStartLocation: {2}\n\n" +
                                                "TransportStartLocation: {3}\n\n" +
                                                "Start MapId: {4}\n\n" +
                                                "Start ZoneId: {5}\n\n" +
                                                "End MapId: {6}\n\n" +
                                                "End ZoneId: {7}\n\n" +
                                                "CharEndLocation: {8}\n\n" +
                                                "TransportEndLocation: {9}\n\n" +
                                                "Load Time: {10}", transportObject.Name, transportEntry,
                                                charStartLocation, transportStartLocation,
                                                startMapId, startZoneId, endMapId, endZoneId, charEndLocation,
                                                transportEndLocation, loadTime.TotalMilliseconds);
                string postData = "[CODE]\nFrom: --EDIT THIS --\nTo: --EDIT THIS-- \n" + textOutput.Text + "[/CODE]";
                Clipboard.SetText(postData);
                Process.Start("http://www.thebuddyforum.com/newreply.php?do=newreply&p=409015&noquote=1");
                MessageBox.Show("Post Data has been copied to your Clipboard, please Post this Data on the Forums.");
            }
            else
            {
                Logging.Write("[TravelPlugin] No Transports found! Be sure to be withing [35 Yards]!");
                return;
            }
        }
    }
}