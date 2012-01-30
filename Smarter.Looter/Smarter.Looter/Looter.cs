using System;
using Styx;
using Styx.Logic.Combat;
using TreeSharp;
using Action=TreeSharp.Action;

namespace Smarter.Looter
{
    public class Looter : BotBase
    {
        public override string Name
        {
            get { return "Looter"; }
        }

        public override Composite Root
        {
            get
            {
                return new Decorator();

            }
        }

        public override PulseFlags PulseFlags
        {
            get { return Styx.PulseFlags.All; }
        }
    }
}
