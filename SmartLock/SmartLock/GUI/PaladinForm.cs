using System.Windows.Forms;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;

namespace Ensemble
{
    public partial class PaladinForm : Form
    {
        public PaladinForm()
        {
            InitializeComponent();
        }

        private void FormConfiguration_FormClosing(object sender, FormClosingEventArgs e)
        {
            Ensemble.Instance.Settings.BuffMana = (double)nudBuffMana.Value;
            Ensemble.Instance.Settings.DispelMagic = cbDispelMagic.Checked;
            Ensemble.Instance.Settings.DispelOnlyOOC = cbDispelOnlyOOC.Checked;
            Ensemble.Instance.Settings.HealthPotHealth = (double)nudHealthPotHealth.Value;
            Ensemble.Instance.Settings.ManaPotMana = (double)nudManaPotMana.Value;
            Ensemble.Instance.Settings.RestHealth = (double)nudRestHealth.Value;
            Ensemble.Instance.Settings.RestMana = (double)nudRestMana.Value;
            Ensemble.Instance.Settings.UseEMfHs = cbUseEMfHs.Checked;
            Ensemble.Instance.Settings.UseWotF = cbUseWotF.Checked;
            Ensemble.Instance.Settings.UseHealthPot = cbUseHealthPot.Checked;
            Ensemble.Instance.Settings.UseManaPot = cbUseManaPot.Checked;
            Ensemble.Instance.Settings.Save();
        }

        private void FormConfiguration_Load(object sender, EventArgs e)
        {
            nudBuffMana.Value = (decimal)Ensemble.Instance.Settings.BuffMana;
            cbDispelMagic.Checked = Ensemble.Instance.Settings.DispelMagic;
            cbDispelOnlyOOC.Checked = Ensemble.Instance.Settings.DispelOnlyOOC;
            nudHealthPotHealth.Value = (decimal)Ensemble.Instance.Settings.HealthPotHealth;
            nudManaPotMana.Value = (decimal)Ensemble.Instance.Settings.ManaPotMana;
            nudRestHealth.Value = (decimal)Ensemble.Instance.Settings.RestHealth;
            nudRestMana.Value = (decimal)Ensemble.Instance.Settings.RestMana;
            cbUseEMfHs.Checked = Ensemble.Instance.Settings.UseEMfHs;
            cbUseWotF.Checked = Ensemble.Instance.Settings.UseWotF;
            cbUseHealthPot.Checked = Ensemble.Instance.Settings.UseHealthPot;
            cbUseManaPot.Checked = Ensemble.Instance.Settings.UseManaPot;
        }
    }
}
