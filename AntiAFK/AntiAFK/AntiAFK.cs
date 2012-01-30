using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Styx.Plugins.PluginClass;

namespace AntiAFK
{
    public class AntiAFK : HBPlugin
    {
        private DateTime lastAfk;
        private bool _firstPulse = true;

        public override void Pulse()
        {
            if (_firstPulse)
            {
                lastAfk = DateTime.Now;
                _firstPulse = false;
            }

            var sinceLast = DateTime.Now.Subtract(lastAfk);
            if (sinceLast.Seconds < 60 && sinceLast.Seconds > 200)
            {
                Styx.Helpers.KeyboardManager.AntiAfk();
                lastAfk = DateTime.Now;
            }
        }

        public override string Name
        {
            get { return "AntiAFK"; }
        }

        public override string Author
        {
            get { return "Goober"; }
        }

        public override Version Version
        {
            get { return new Version(0,6,6,6); }
        }
    }
}
