using System.Windows.Forms;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;

namespace Ensemble
{
    public partial class WarriorForm : Form
    {
        public WarriorForm()
        {
            InitializeComponent();
        }

        private void FormConfiguration_FormClosing(object sender, FormClosingEventArgs e)
        {
            Ensemble.Instance.Settings.HealthPotHealth = (double)nudHealthPotHealth.Value;
            Ensemble.Instance.Settings.RestHealth = (double)nudRestHealth.Value;
            Ensemble.Instance.Settings.UseEMfHs = cbUseEMfHs.Checked;
            Ensemble.Instance.Settings.UseWotF = cbUseWotF.Checked;
            Ensemble.Instance.Settings.UseHealthPot = cbUseHealthPot.Checked;
            Ensemble.Instance.Settings.Save();
        }

        private void FormConfiguration_Load(object sender, EventArgs e)
        {
            nudHealthPotHealth.Value = (decimal)Ensemble.Instance.Settings.HealthPotHealth;
            nudRestHealth.Value = (decimal)Ensemble.Instance.Settings.RestHealth;
            cbUseEMfHs.Checked = Ensemble.Instance.Settings.UseEMfHs;
            cbUseWotF.Checked = Ensemble.Instance.Settings.UseWotF;
            cbUseHealthPot.Checked = Ensemble.Instance.Settings.UseHealthPot;
        }
    }
}
