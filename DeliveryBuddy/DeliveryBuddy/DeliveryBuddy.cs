using System;
using Styx;
using Styx.Helpers;
using System.Drawing;
using TreeSharp;
using Action = TreeSharp.Action;

namespace DeliveryBuddy
{
    public class DeliveryBuddy : BotBase
    {
        public string DeliveryCharacter;
        public int DeliveryAmount;
        public bool ConfigurationComplete;
        private FormConfig _configForm;

        public override string Name
        {
            get { return "DeliveryBuddy"; }
        }

        public override System.Windows.Forms.Form ConfigurationForm
        {
            get
            {
                if (_configForm != null)
                {
                    return _configForm;
                }
                _configForm = new FormConfig(this);
                return _configForm;
            }
        }

        public static void Log(LogType type, string message)
        {
            switch (type)
            {
                case LogType.Error:
                    Logging.Write(Color.OrangeRed, "[DeliveryBuddy] {Error}:" + message);
                    break;
                case LogType.Warning:
                    Logging.Write(Color.Yellow, "[DeliveryBuddy] {Warning}: " + message);
                    break;
                case LogType.Message:
                    Logging.Write(Color.LimeGreen, "[DeliveryBuddy]: " + message);
                    break;
                default:
                    throw new ArgumentOutOfRangeException("type");
            }
        }
        public override Composite Root
        {
            get
            {
                return new PrioritySelector(
                    new Decorator(o => !ConfigurationComplete,
                        new Sequence(
                            new Action(o => Log(LogType.Error, "Configuration Not Complete!")),
                            new Action(o => ConfigurationForm.Show()),
                            new Action(o => Stop()))),
                    new Decorator(o => ConfigurationComplete,
                        new PrioritySelector(
                            )));
            }
        }

        public override PulseFlags PulseFlags
        {
            get { return PulseFlags.All; }
        }


    }

    public enum LogType
    {
        Error,
        Warning,
        Message
    }

}
