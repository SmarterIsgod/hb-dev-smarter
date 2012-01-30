using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using Styx;
using Styx.Logic;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;
using TreeSharp;
using Action = TreeSharp.Action;
using HBRemoting;

namespace RAFQuestor
{
    public class RafQuestor : BotBase
    {
        #region Variables

        private WoWUnit _leader;
        private LocalPlayer _me = StyxWoW.Me;
        #endregion

        #region Configuration
        public override string Name
        {
            get { return "RAFQuestor"; }
        }

        private FormConfig _configForm;
        public override System.Windows.Forms.Form ConfigurationForm
        {
            get { return _configForm ?? (_configForm = new FormConfig(this)); }
        }
        public override bool IsPrimaryType
        {
            get
            {
                return true;
            }
        }
        #endregion

        #region Composite
        private Composite _root;
        public override Composite Root
        {
            get
            {
                return _root ?? (_root =
                    new PrioritySelector(
                        new Decorator(ret => !StyxWoW.Me.Combat,
                            new PrioritySelector()),


                        new Decorator(ret => StyxWoW.Me.Combat,
                            new PrioritySelector())





                            ));
            }
        }

        public override PulseFlags PulseFlags
        {
            get { return PulseFlags.All; }
        }

        public override void Pulse()
        {

        }

        #endregion
       
    }


}
