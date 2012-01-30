using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace NotABot
{
    public partial class FormDebug : Form
    {
        private InformantListManager _ilm;

        public FormDebug(InformantListManager informantListManager)
        {
            InitializeComponent();
            _ilm = informantListManager;
            listBox1.Text = "NAME		THREAT		DISTANCE\n";
        }

        private void AddUser(string user, int threat, double distance)
        {
            var old = listBox1.Text;
            listBox1.Text = old + user + "		" + threat + "		" + distance + "\n";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Count: " + _ilm.Informants.Count);
            listBox1.Text = "NAME		THREAT		DISTANCE\n";
            foreach (var informants in _ilm.Informants.Values)
            {
                AddUser(informants.Name, informants.Threat, informants.Distance);
            }
        }
    }
}
