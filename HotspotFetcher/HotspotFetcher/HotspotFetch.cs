using System;
using Styx.Plugins.PluginClass;

namespace HotspotFetcher
{
    public class HotspotFetch : HBPlugin
    {
        public override void Pulse()
        {
            
        }

        public override string Name { get { return "HotspotFetch"; } }
        public override string Author { get { return "Smarter"; } }
        public override Version Version { get { return new Version(0,0,1,0); } }

        public override bool WantButton
        {
            get
            {
                return true;
            }
        }

        public override void OnButtonPress()
        {
            Form1 frm = new Form1();
            frm.Show();
        }
    }
}
