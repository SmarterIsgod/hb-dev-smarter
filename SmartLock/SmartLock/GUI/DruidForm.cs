using System.Windows.Forms;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;

namespace Ensemble
{
    public partial class DruidForm : Form
    {
        public DruidForm()
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
            Ensemble.Instance.Settings.DruidUseBarkskin = cbDruidUseBarkskin.Checked;
            Ensemble.Instance.Settings.DruidUseInnervate = cbDruidUseInnervate.Checked;
            Ensemble.Instance.Settings.DruidUseTreeOfLife = cbDruidUseTreeOfLife.Checked;
            Ensemble.Instance.Settings.DruidUsePvPTreeOfLife = cbDruidUsePvPTreeOfLife.Checked;
            Ensemble.Instance.Settings.DruidBarkskinHealth = (double)nudDruidBarkskinHealth.Value;
            Ensemble.Instance.Settings.DruidInnervateMana = (double)nudDruidInnervateMana.Value;
            Ensemble.Instance.Settings.DruidTreeOfLifeCount = (double)nudDruidTreeOfLifeCount.Value;
            Ensemble.Instance.Settings.DruidTreeOfLifeHealth = (double)nudDruidTreeOfLifeHealth.Value;
            Ensemble.Instance.Settings.DruidPvPTreeOfLifeCount = (double)nudDruidPvPTreeOfLifeCount.Value;
            Ensemble.Instance.Settings.DruidPvPTreeOfLifeHealth = (double)nudDruidPvPTreeOfLifeHealth.Value;
            Ensemble.Instance.Settings.DruidUseFF = cbDruidUseFF.Checked;
            Ensemble.Instance.Settings.DruidUseHealingTouch = cbDruidUseHealingTouch.Checked;
            Ensemble.Instance.Settings.DruidUseInnervateOnPlayer = cbDruidUseInnervateOnPlayer.Checked;
            Ensemble.Instance.Settings.DruidUseNourish = cbDruidUseNourish.Checked;
            Ensemble.Instance.Settings.DruidUsePvPFF = cbDruidUsePvPFF.Checked;
            Ensemble.Instance.Settings.DruidUsePvPHealingTouch = cbDruidUsePvPHealingTouch.Checked;
            Ensemble.Instance.Settings.DruidUsePvPInnervateOnPlayer = cbDruidUsePvPInnervateOnPlayer.Checked;
            Ensemble.Instance.Settings.DruidUsePvPNourish = cbDruidUsePvPNourish.Checked;
            Ensemble.Instance.Settings.DruidUsePvPRegrowth = cbDruidUsePvPRegrowth.Checked;
            Ensemble.Instance.Settings.DruidUsePvPRejuvenation = cbDruidUsePvPRejuvenation.Checked;
            Ensemble.Instance.Settings.DruidUsePvPSwiftmend = cbDruidUsePvPSwiftmend.Checked;
            Ensemble.Instance.Settings.DruidUsePvPThorns = cbDruidUsePvPThorns.Checked;
            Ensemble.Instance.Settings.DruidUsePvPTranquility = cbDruidUsePvPTranquility.Checked;
            Ensemble.Instance.Settings.DruidUsePvPWildGrowth = cbDruidUsePvPWildGrowth.Checked;
            Ensemble.Instance.Settings.DruidUseRegrowth = cbDruidUseRegrowth.Checked;
            Ensemble.Instance.Settings.DruidUseRejuvenation = cbDruidUseRejuvenation.Checked;
            Ensemble.Instance.Settings.DruidUseSwiftmend = cbDruidUseSwiftmend.Checked;
            Ensemble.Instance.Settings.DruidUseThorns = cbDruidUseThorns.Checked;
            Ensemble.Instance.Settings.DruidUseTranquility = cbDruidUseTranquility.Checked;
            Ensemble.Instance.Settings.DruidUseWildGrowth = cbDruidUseWildGrowth.Checked;
            Ensemble.Instance.Settings.DruidHealingTouchHealth = (double)nudDruidHealingTouchHealth.Value;
            Ensemble.Instance.Settings.DruidNourishHealth = (double)nudDruidNourishHealth.Value;
            Ensemble.Instance.Settings.DruidPvPHealingTouchHealth = (double)nudDruidPvPHealingTouchHealth.Value;
            Ensemble.Instance.Settings.DruidPvPNourishHealth = (double)nudDruidPvPNourishHealth.Value;
            Ensemble.Instance.Settings.DruidPvPRegrowthHealth = (double)nudDruidPvPRegrowthHealth.Value;
            Ensemble.Instance.Settings.DruidPvPRejuvenationHealth = (double)nudDruidPvPRejuvenationHealth.Value;
            Ensemble.Instance.Settings.DruidPvPSwiftmendHealth = (double)nudDruidPvPSwiftmendHealth.Value;
            Ensemble.Instance.Settings.DruidPvPTranquilityCount = (double)nudDruidPvPTranquilityCount.Value;
            Ensemble.Instance.Settings.DruidPvPTranquilityHealth = (double)nudDruidPvPTranquilityHealth.Value;
            Ensemble.Instance.Settings.DruidPvPWildGrowthCount = (double)nudDruidPvPWildGrowthCount.Value;
            Ensemble.Instance.Settings.DruidPvPWildGrowthHealth = (double)nudDruidPvPWildGrowthHealth.Value;
            Ensemble.Instance.Settings.DruidRegrowthHealth = (double)nudDruidRegrowthHealth.Value;
            Ensemble.Instance.Settings.DruidRejuvenationHealth = (double)nudDruidRejuvenationHealth.Value;
            Ensemble.Instance.Settings.DruidSwiftmendHealth = (double)nudDruidSwiftMendHealth.Value;
            Ensemble.Instance.Settings.DruidTranquilityCount = (double)nudDruidTranquilityCount.Value;
            Ensemble.Instance.Settings.DruidTranquilityHealth = (double)nudDruidTranquilityHealth.Value;
            Ensemble.Instance.Settings.DruidWildGrowthCount = (double)nudDruidWildGrowthCount.Value;
            Ensemble.Instance.Settings.DruidWildGrowthHealth = (double)nudDruidWildGrowthHealth.Value;
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
            cbDruidUseBarkskin.Checked = Ensemble.Instance.Settings.DruidUseBarkskin;
            cbDruidUseInnervate.Checked = Ensemble.Instance.Settings.DruidUseInnervate;
            cbDruidUseTreeOfLife.Checked = Ensemble.Instance.Settings.DruidUseTreeOfLife;
            cbDruidUsePvPTreeOfLife.Checked = Ensemble.Instance.Settings.DruidUsePvPTreeOfLife;
            nudDruidBarkskinHealth.Value = (decimal)Ensemble.Instance.Settings.DruidBarkskinHealth;
            nudDruidInnervateMana.Value = (decimal)Ensemble.Instance.Settings.DruidInnervateMana;
            nudDruidTreeOfLifeCount.Value = (decimal)Ensemble.Instance.Settings.DruidTreeOfLifeCount;
            nudDruidTreeOfLifeHealth.Value = (decimal)Ensemble.Instance.Settings.DruidTreeOfLifeHealth;
            nudDruidPvPTreeOfLifeCount.Value = (decimal)Ensemble.Instance.Settings.DruidPvPTreeOfLifeCount;
            nudDruidPvPTreeOfLifeHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPTreeOfLifeHealth;
            cbDruidUseFF.Checked = Ensemble.Instance.Settings.DruidUseFF;
            cbDruidUseHealingTouch.Checked = Ensemble.Instance.Settings.DruidUseHealingTouch;
            cbDruidUseInnervateOnPlayer.Checked = Ensemble.Instance.Settings.DruidUseInnervateOnPlayer;
            cbDruidUseNourish.Checked = Ensemble.Instance.Settings.DruidUseNourish;
            cbDruidUsePvPFF.Checked = Ensemble.Instance.Settings.DruidUsePvPFF;
            cbDruidUsePvPHealingTouch.Checked = Ensemble.Instance.Settings.DruidUsePvPHealingTouch;
            cbDruidUsePvPInnervateOnPlayer.Checked = Ensemble.Instance.Settings.DruidUsePvPInnervateOnPlayer;
            cbDruidUsePvPNourish.Checked = Ensemble.Instance.Settings.DruidUsePvPNourish;
            cbDruidUsePvPRegrowth.Checked = Ensemble.Instance.Settings.DruidUsePvPRegrowth;
            cbDruidUsePvPRejuvenation.Checked = Ensemble.Instance.Settings.DruidUsePvPRejuvenation;
            cbDruidUsePvPSwiftmend.Checked = Ensemble.Instance.Settings.DruidUsePvPSwiftmend;
            cbDruidUsePvPThorns.Checked = Ensemble.Instance.Settings.DruidUsePvPThorns;
            cbDruidUsePvPTranquility.Checked = Ensemble.Instance.Settings.DruidUsePvPTranquility;
            cbDruidUsePvPWildGrowth.Checked = Ensemble.Instance.Settings.DruidUsePvPWildGrowth;
            cbDruidUseRegrowth.Checked = Ensemble.Instance.Settings.DruidUseRegrowth;
            cbDruidUseRejuvenation.Checked = Ensemble.Instance.Settings.DruidUseRejuvenation;
            cbDruidUseSwiftmend.Checked = Ensemble.Instance.Settings.DruidUseSwiftmend;
            cbDruidUseThorns.Checked = Ensemble.Instance.Settings.DruidUseThorns;
            cbDruidUseTranquility.Checked = Ensemble.Instance.Settings.DruidUseTranquility;
            cbDruidUseWildGrowth.Checked = Ensemble.Instance.Settings.DruidUseWildGrowth;
            nudDruidHealingTouchHealth.Value = (decimal)Ensemble.Instance.Settings.DruidHealingTouchHealth;
            nudDruidNourishHealth.Value = (decimal)Ensemble.Instance.Settings.DruidNourishHealth;
            nudDruidPvPHealingTouchHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPHealingTouchHealth;
            nudDruidPvPNourishHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPNourishHealth;
            nudDruidPvPRegrowthHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPRegrowthHealth;
            nudDruidPvPRejuvenationHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPRejuvenationHealth;
            nudDruidPvPSwiftmendHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPSwiftmendHealth;
            nudDruidPvPTranquilityCount.Value = (decimal)Ensemble.Instance.Settings.DruidPvPTranquilityCount;
            nudDruidPvPTranquilityHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPTranquilityHealth;
            nudDruidPvPWildGrowthCount.Value = (decimal)Ensemble.Instance.Settings.DruidPvPWildGrowthCount;
            nudDruidPvPWildGrowthHealth.Value = (decimal)Ensemble.Instance.Settings.DruidPvPWildGrowthHealth;
            nudDruidRegrowthHealth.Value = (decimal)Ensemble.Instance.Settings.DruidRegrowthHealth;
            nudDruidRejuvenationHealth.Value = (decimal)Ensemble.Instance.Settings.DruidRejuvenationHealth;
            nudDruidSwiftMendHealth.Value = (decimal)Ensemble.Instance.Settings.DruidSwiftmendHealth;
            nudDruidTranquilityCount.Value = (decimal)Ensemble.Instance.Settings.DruidTranquilityCount;
            nudDruidTranquilityHealth.Value = (decimal)Ensemble.Instance.Settings.DruidTranquilityHealth;
            nudDruidWildGrowthCount.Value = (decimal)Ensemble.Instance.Settings.DruidWildGrowthCount;
            nudDruidWildGrowthHealth.Value = (decimal)Ensemble.Instance.Settings.DruidWildGrowthHealth;
        }
    }
}
