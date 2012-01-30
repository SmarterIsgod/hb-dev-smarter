using System;
using Styx.Plugins.PluginClass;

namespace TransportBuddy
{
    public class TransportBuddy : HBPlugin
    {
        private FormMain _mainForm;

        public override string ButtonText
        {
            get { return "TransportBuddy"; }
        }

        public override string Name
        {
            get { return "TransportBuddy"; }
        }

        public override bool WantButton
        {
            get { return true; }
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
        }

        public override void OnButtonPress()
        {
            if (_mainForm != null)
            {
                _mainForm.Show();
            }
            else
            {
                _mainForm = new FormMain();
                _mainForm.Show();
            }
        }
    }
}