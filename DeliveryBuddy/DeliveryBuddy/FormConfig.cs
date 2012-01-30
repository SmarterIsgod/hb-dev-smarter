using System;
using System.Windows.Forms;

namespace DeliveryBuddy
{
    public partial class FormConfig : Form
    {
        private readonly DeliveryBuddy _parent;

        public FormConfig(DeliveryBuddy buddy)
        {
            InitializeComponent();
            _parent = buddy;
        }

        private void ButtonSaveClick(object sender, EventArgs e)
        {
            _parent.DeliveryCharacter = textBox1.Text;
            _parent.DeliveryAmount = Convert.ToInt32(textBox2.Text);
            _parent.ConfigurationComplete = true;
            DeliveryBuddy.Log(LogType.Message, "Configuration Complete.");
            Close();
        }
    }
}
