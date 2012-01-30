﻿using System.Windows.Forms;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Linq;

namespace Ensemble
{
    public partial class PriestForm : Form
    {
        public PriestForm()
        {
            InitializeComponent();
        }

        private void FormConfiguration_FormClosing(object sender, FormClosingEventArgs e)
        {
            Ensemble.Instance.Settings.BuffMana = (double)nudBuffMana.Value;
            Ensemble.Instance.Settings.DiscFlashHealHealth = (double)nudDiscFlashHealHealth.Value;
            Ensemble.Instance.Settings.DiscHealHealth = (double)nudDiscHealHealth.Value;
            Ensemble.Instance.Settings.DiscPainSuppressionHealth = (double)nudDiscPainSuppressionHealth.Value;
            Ensemble.Instance.Settings.DiscPenanceHealth = (double)nudDiscPenanceHealth.Value;
            Ensemble.Instance.Settings.DiscPrayerOfHealingCount = (double)nudDiscPrayerOfHealingCount.Value;
            Ensemble.Instance.Settings.DiscPrayerOfHealingHealth = (double)nudDiscPrayerOfHealingHealth.Value;
            Ensemble.Instance.Settings.DiscPvPFlashHealHealth = (double)nudDiscPvPFlashHealHealth.Value;
            Ensemble.Instance.Settings.DiscPvPHealHealth = (double)nudDiscPvPHealHealth.Value;
            Ensemble.Instance.Settings.DiscPvPPainSuppressionHealth = (double)nudDiscPvPPainSuppressionHealth.Value;
            Ensemble.Instance.Settings.DiscPvPPenanceHealth = (double)nudDiscPvPPenanceHealth.Value;
            Ensemble.Instance.Settings.DiscPvPPrayerOfHealingCount = (double)nudDiscPvPPrayerOfHealingCount.Value;
            Ensemble.Instance.Settings.DiscPvPPrayerOfHealingHealth = (double)nudDiscPvPPrayerOfHealingHealth.Value;
            Ensemble.Instance.Settings.DiscPvPPWSHealth = (double)nudDiscPvPPWSHealth.Value;
            Ensemble.Instance.Settings.DiscPvPRenewHealth = (double)nudDiscPvPRenewHealth.Value;
            Ensemble.Instance.Settings.DiscPWSHealth = (double)nudDiscPWSHealth.Value;
            Ensemble.Instance.Settings.DiscRenewHealth = (double)nudDiscRenewHealth.Value;
            Ensemble.Instance.Settings.DispelMagic = cbDispelMagic.Checked;
            Ensemble.Instance.Settings.DispelOnlyOOC = cbDispelOnlyOOC.Checked;
            Ensemble.Instance.Settings.DotAdds = cbDotAdds.Checked;
            Ensemble.Instance.Settings.GrindingPullDistance = (int)nudGrindingPullDistance.Value;
            Ensemble.Instance.Settings.HealPullDistance = (int)nudHealPullDistance.Value;
            Ensemble.Instance.Settings.HealthPotHealth = (double)nudHealthPotHealth.Value;
            Ensemble.Instance.Settings.HolyFlashHealHealth = (double)nudHolyFlashHealHealth.Value;
            Ensemble.Instance.Settings.HolyHealHealth = (double)nudHolyHealHealth.Value;
            Ensemble.Instance.Settings.HolyPrayerOfHealingCount = (double)nudHolyPrayerOfHealingCount.Value;
            Ensemble.Instance.Settings.HolyPrayerOfHealingHealth = (double)nudHolyPrayerOfHealingHealth.Value;
            Ensemble.Instance.Settings.HolyPvPFlashHealHealth = (double)nudHolyPvPFlashHealHealth.Value;
            Ensemble.Instance.Settings.HolyPvPHealHealth = (double)nudHolyPvPHealHealth.Value;
            Ensemble.Instance.Settings.HolyPvPPrayerOfHealingCount = (double)nudHolyPvPPrayerOfHealingCount.Value;
            Ensemble.Instance.Settings.HolyPvPPrayerOfHealingHealth = (double)nudHolyPvPPrayerOfHealingHealth.Value;
            Ensemble.Instance.Settings.HolyPvPPWSHealth = (double)nudHolyPvPPWSHealth.Value;
            Ensemble.Instance.Settings.HolyPvPRenewHealth = (double)nudHolyPvPRenewHealth.Value;
            Ensemble.Instance.Settings.HolyPWSHealth = (double)nudHolyPWSHealth.Value;
            Ensemble.Instance.Settings.HolyRenewHealth = (double)nudHolyRenewHealth.Value;
            Ensemble.Instance.Settings.ManaPotMana = (double)nudManaPotMana.Value;
            Ensemble.Instance.Settings.PullWithMB = cbPullWithMB.Checked;
            Ensemble.Instance.Settings.PvPPullDistance = (int)nudPvPPullDistance.Value;
            Ensemble.Instance.Settings.RaFDPSMana = (double)nudRaFDPSMana.Value;
            Ensemble.Instance.Settings.RaFFlashHealHealth = (double)nudRaFFlashHealHealth.Value;
            Ensemble.Instance.Settings.RaFHealHealth = (double)nudRaFHealHealth.Value;
            Ensemble.Instance.Settings.RaFPWSHealth = (double)nudRaFPWSHealth.Value;
            Ensemble.Instance.Settings.RaFRenewHealth = (double)nudRaFRenewHealth.Value;
            Ensemble.Instance.Settings.RemoveDisease = cbRemoveDisease.Checked;
            Ensemble.Instance.Settings.RestHealth = (double)nudRestHealth.Value;
            Ensemble.Instance.Settings.RestMana = (double)nudRestMana.Value;
            Ensemble.Instance.Settings.ShadowDispersionMana = (double)nudShadowDispersionMana.Value;
            Ensemble.Instance.Settings.ShadowDotHealth = (double)nudShadowDotHealth.Value;
            Ensemble.Instance.Settings.ShadowDPSHealth = (double)nudShadowDPSHealth.Value;
            Ensemble.Instance.Settings.ShadowDPSMana = (double)nudRaFDPSMana.Value;
            Ensemble.Instance.Settings.ShadowFlashHealHealth = (double)nudShadowFlashHealHealth.Value;
            Ensemble.Instance.Settings.ShadowHealHealth = (double)nudShadowHealHealth.Value;
            Ensemble.Instance.Settings.ShadowMindSearAddCount = (double)nudShadowMindSearAddCount.Value;
            Ensemble.Instance.Settings.ShadowPvPFlashHealHealth = (double)nudShadowPvPFlashHealHealth.Value;
            Ensemble.Instance.Settings.ShadowPvPHealHealth = (double)nudShadowPvPHealHealth.Value;
            Ensemble.Instance.Settings.ShadowPvPPWSHealth = (double)nudShadowPvPPWSHealth.Value;
            Ensemble.Instance.Settings.ShadowPvPRenewHealth = (double)nudShadowPvPRenewHealth.Value;
            Ensemble.Instance.Settings.ShadowPWSHealth = (double)nudShadowPWSHealth.Value;
            Ensemble.Instance.Settings.ShadowRenewHealth = (double)nudShadowRenewHealth.Value;
            Ensemble.Instance.Settings.ShadowShadowfiendHealth = (double)nudShadowShadowfiendHealth.Value;
            Ensemble.Instance.Settings.ShadowShadowfiendMana = (double)nudShadowShadowfiendMana.Value;
            Ensemble.Instance.Settings.ShadowSWDHealth = (double)nudShadowSWDHealth.Value;
            Ensemble.Instance.Settings.UseCombatFearWard = cbUseCombatFearWard.Checked;
            Ensemble.Instance.Settings.UseCombatInnerFire = cbUseCombatInnerFire.Checked;
            Ensemble.Instance.Settings.UseCombatInnerFocus = cbUseCombatInnerFocus.Checked;
            Ensemble.Instance.Settings.UseCombatPWF = cbUseCombatPWF.Checked;
            Ensemble.Instance.Settings.UseCombatShadowform = cbUseCombatShadowform.Checked;
            Ensemble.Instance.Settings.UseCombatShadowProtection = cbUseCombatShadowProtection.Checked;
            Ensemble.Instance.Settings.UseCombatVampiricEmbrace = cbUseCombatVampiricEmbrace.Checked;
            Ensemble.Instance.Settings.UseDiscFlashHeal = cbUseDiscFlashHeal.Checked;
            Ensemble.Instance.Settings.UseDiscHeal = cbUseDiscHeal.Checked;
            Ensemble.Instance.Settings.UseDiscPainSuppression = cbUseDiscPainSuppression.Checked;
            Ensemble.Instance.Settings.UseDiscPenance = cbUseDiscPenance.Checked;
            Ensemble.Instance.Settings.UseDiscPrayerOfHealing = cbUseDiscPrayerOfHealing.Checked;
            Ensemble.Instance.Settings.UseDiscPrayerOfMending = cbUseDiscPrayerOfMending.Checked;
            Ensemble.Instance.Settings.UseDiscPvPFlashHeal = cbUseDiscPvPFlashHeal.Checked;
            Ensemble.Instance.Settings.UseDiscPvPHeal = cbUseDiscPvPHeal.Checked;
            Ensemble.Instance.Settings.UseDiscPvPPainSuppression = cbUseDiscPvPPainSuppression.Checked;
            Ensemble.Instance.Settings.UseDiscPvPPenance = cbUseDiscPvPPenance.Checked;
            Ensemble.Instance.Settings.UseDiscPvPPrayerOfHealing = cbUseDiscPvPPrayerOfHealing.Checked;
            Ensemble.Instance.Settings.UseDiscPvPPrayerOfMending = cbUseDiscPvPPrayerOfMending.Checked;
            Ensemble.Instance.Settings.UseDiscPvPPWS = cbUseDiscPvPPWS.Checked;
            Ensemble.Instance.Settings.UseDiscPvPRenew = cbUseDiscPvPRenew.Checked;
            Ensemble.Instance.Settings.UseDiscPWS = cbUseDiscPWS.Checked;
            Ensemble.Instance.Settings.UseDiscRenew = cbUseDiscRenew.Checked;
            Ensemble.Instance.Settings.UseDispersionWhileResting = cbUseDispersionWhileResting.Checked;
            Ensemble.Instance.Settings.UseEMfHs = cbUseEMfHs.Checked;
            Ensemble.Instance.Settings.UseHealthPot = cbUseHealthPot.Checked;
            Ensemble.Instance.Settings.UseHolyFlashHeal = cbUseHolyFlashHeal.Checked;
            Ensemble.Instance.Settings.UseHolyHeal = cbUseHolyHeal.Checked;
            Ensemble.Instance.Settings.UseHolyPrayerOfHealing = cbUseHolyPrayerOfHealing.Checked;
            Ensemble.Instance.Settings.UseHolyPrayerOfMending = cbUseHolyPrayerOfMending.Checked;
            Ensemble.Instance.Settings.UseHolyPvPFlashHeal = cbUseHolyPvPFlashHeal.Checked;
            Ensemble.Instance.Settings.UseHolyPvPHeal = cbUseHolyPvPHeal.Checked;
            Ensemble.Instance.Settings.UseHolyPvPPrayerOfHealing = cbUseHolyPvPPrayerOfHealing.Checked;
            Ensemble.Instance.Settings.UseHolyPvPPrayerOfMending = cbUseHolyPvPPrayerOfMending.Checked;
            Ensemble.Instance.Settings.UseHolyPvPPWS = cbUseHolyPvPPWS.Checked;
            Ensemble.Instance.Settings.UseHolyPvPRenew = cbUseHolyPvPRenew.Checked;
            Ensemble.Instance.Settings.UseHolyPWS = cbUseHolyPWS.Checked;
            Ensemble.Instance.Settings.UseHolyRenew = cbUseHolyRenew.Checked;
            Ensemble.Instance.Settings.UseManaPot = cbUseManaPot.Checked;
            Ensemble.Instance.Settings.UsePartyPWF = cbUsePartyPWF.Checked;
            Ensemble.Instance.Settings.UsePartyShadowProtection = cbUsePartyShadowProtection.Checked;
            Ensemble.Instance.Settings.UsePreCombatFearWard = cbUsePreCombatFearWard.Checked;
            Ensemble.Instance.Settings.UsePreCombatInnerFire = cbUsePreCombatInnerFire.Checked;
            Ensemble.Instance.Settings.UsePreCombatPWF = cbUsePreCombatPWF.Checked;
            Ensemble.Instance.Settings.UsePreCombatShadowform = cbUsePreCombatShadowform.Checked;
            Ensemble.Instance.Settings.UsePreCombatShadowProtection = cbUsePreCombatShadowProtection.Checked;
            Ensemble.Instance.Settings.UsePreCombatVampiricEmbrace = cbUsePreCombatVampiricEmbrace.Checked;
            Ensemble.Instance.Settings.UseRaFDevouringPlague = cbUseRaFDevouringPlague.Checked;
            Ensemble.Instance.Settings.UseRaFDispersion = cbUseRaFDispersion.Checked;
            Ensemble.Instance.Settings.UseRaFFlashHeal = cbUseRaFFlashHeal.Checked;
            Ensemble.Instance.Settings.UseRaFHeal = cbUseRaFHeal.Checked;
            Ensemble.Instance.Settings.UseRaFHolyFire = cbUseRaFHolyFire.Checked;
            Ensemble.Instance.Settings.UseRaFMindBlast = cbUseRaFMindBlast.Checked;
            Ensemble.Instance.Settings.UseRaFMindFlay = cbUseRaFMindFlay.Checked;
            Ensemble.Instance.Settings.UseRaFMindSear = cbUseRaFMindSear.Checked;
            Ensemble.Instance.Settings.UseRaFPsychicHorror = cbUseRaFPsychicHorror.Checked;
            Ensemble.Instance.Settings.UseRaFPsychicScream = cbUseRaFPsychicScream.Checked;
            Ensemble.Instance.Settings.UseRaFPWS = cbUseRaFPWS.Checked;
            Ensemble.Instance.Settings.UseRaFRenew = cbUseRaFRenew.Checked;
            Ensemble.Instance.Settings.UseRaFShadowfiend = cbUseRaFShadowfiend.Checked;
            Ensemble.Instance.Settings.UseRaFSmite = cbUseRaFSmite.Checked;
            Ensemble.Instance.Settings.UseRaFSWD = cbUseRaFSWD.Checked;
            Ensemble.Instance.Settings.UseRaFSWP = cbUseRaFSWP.Checked;
            Ensemble.Instance.Settings.UseRaFVampiricTouch = cbUseRaFVampiricTouch.Checked;
            Ensemble.Instance.Settings.UseShadowDevouringPlague = cbUseShadowDevouringPlague.Checked;
            Ensemble.Instance.Settings.UseShadowDispersion = cbUseShadowDispersion.Checked;
            Ensemble.Instance.Settings.UseShadowDispersionWhenStunned = cbUseShadowDispersionWhenStunned.Checked;
            Ensemble.Instance.Settings.UseShadowFlashHeal = cbUseShadowFlashHeal.Checked;
            Ensemble.Instance.Settings.UseShadowHeal = cbUseShadowHeal.Checked;
            Ensemble.Instance.Settings.UseShadowHolyFire = cbUseShadowHolyFire.Checked;
            Ensemble.Instance.Settings.UseShadowMindBlast = cbUseShadowMindBlast.Checked;
            Ensemble.Instance.Settings.UseShadowMindFlay = cbUseShadowMindFlay.Checked;
            Ensemble.Instance.Settings.UseShadowMindSear = cbUseShadowMindSear.Checked;
            Ensemble.Instance.Settings.UseShadowPsychicHorror = cbUseShadowPsychicHorror.Checked;
            Ensemble.Instance.Settings.UseShadowPsychicScream = cbUseShadowPsychicScream.Checked;
            Ensemble.Instance.Settings.UseShadowPvPDevouringPlague = cbUseShadowPvPDevouringPlague.Checked;
            Ensemble.Instance.Settings.UseShadowPvPDispersion = cbUseShadowPvPDispersion.Checked;
            Ensemble.Instance.Settings.UseShadowPVPFlashHeal = cbUseShadowPvPFlashHeal.Checked;
            Ensemble.Instance.Settings.UseShadowPVPHeal = cbUseShadowPvPHeal.Checked;
            Ensemble.Instance.Settings.UseShadowPvPHolyFire = cbUseShadowPvPHolyFire.Checked;
            Ensemble.Instance.Settings.UseShadowPvPMindBlast = cbUseShadowPvPMindBlast.Checked;
            Ensemble.Instance.Settings.UseShadowPvPMindFlay = cbUseShadowPvPMindFlay.Checked;
            Ensemble.Instance.Settings.UseShadowPvPPsychicHorror = cbUseShadowPvPPsychicHorror.Checked;
            Ensemble.Instance.Settings.UseShadowPvPPsychicScream = cbUseShadowPvPPsychicScream.Checked;
            Ensemble.Instance.Settings.UseShadowPvPPWS = cbUseShadowPvPPWS.Checked;
            Ensemble.Instance.Settings.UseShadowPVPRenew = cbUseShadowPvPRenew.Checked;
            Ensemble.Instance.Settings.UseShadowPvPShadowfiend = cbUseShadowPvPShadowfiend.Checked;
            Ensemble.Instance.Settings.UseShadowPvPSmite = cbUseShadowPvPSmite.Checked;
            Ensemble.Instance.Settings.UseShadowPvPSWD = cbUseShadowPvPSWD.Checked;
            Ensemble.Instance.Settings.UseShadowPvPSWP = cbUseShadowPvPSWP.Checked;
            Ensemble.Instance.Settings.UseShadowPvPVampiricTouch = cbUseShadowPvPVampiricTouch.Checked;
            Ensemble.Instance.Settings.UseShadowPWS = cbUseShadowPWS.Checked;
            Ensemble.Instance.Settings.UseShadowRenew = cbUseShadowRenew.Checked;
            Ensemble.Instance.Settings.UseShadowShadowfiend = cbUseShadowShadowfiend.Checked;
            Ensemble.Instance.Settings.UseShadowSilence = cbUseShadowSilence.Checked;
            Ensemble.Instance.Settings.UseShadowSmite = cbUseShadowSmite.Checked;
            Ensemble.Instance.Settings.UseShadowSWD = cbUseShadowSWD.Checked;
            Ensemble.Instance.Settings.UseShadowSWP = cbUseShadowSWP.Checked;
            Ensemble.Instance.Settings.UseShadowVampiricTouch = cbUseShadowVampiricTouch.Checked;
            Ensemble.Instance.Settings.UseWand = cbUseWand.Checked;
            Ensemble.Instance.Settings.UseWotF = cbUseWotF.Checked;
            Ensemble.Instance.Settings.UseDiscSmite = cbUseDiscSmite.Checked;
            Ensemble.Instance.Settings.DiscSmiteMana = (double)nudDiscSmiteMana.Value;
            Ensemble.Instance.Settings.UseDiscPvPSmite = cbUseDiscPvPSmite.Checked;
            Ensemble.Instance.Settings.DiscPvPSmiteMana = (double)nudDiscPvPSmiteMana.Value;
            Ensemble.Instance.Settings.DiscGreaterHealHealth = (double)nudDiscGreaterHealHealth.Value;
            Ensemble.Instance.Settings.UseDiscGreaterHeal = cbUseDiscGreaterHeal.Checked;
            Ensemble.Instance.Settings.DiscPvPGreaterHealHealth = (double)nudDiscPvPGreaterHealHealth.Value;
            Ensemble.Instance.Settings.UseDiscPvPGreaterHeal = cbUseDiscPvPGreaterHeal.Checked;
            Ensemble.Instance.Settings.UsePullPWS = cbUsePullPWS.Checked;
            Ensemble.Instance.Settings.Save();
        }

        private void FormConfiguration_Load(object sender, EventArgs e)
        {
            nudBuffMana.Value = (decimal)Ensemble.Instance.Settings.BuffMana;
            nudDiscFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.DiscFlashHealHealth;
            nudDiscHealHealth.Value = (decimal)Ensemble.Instance.Settings.DiscHealHealth;
            nudDiscPainSuppressionHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPainSuppressionHealth;
            nudDiscPenanceHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPenanceHealth;
            nudDiscPrayerOfHealingCount.Value = (decimal)Ensemble.Instance.Settings.DiscPrayerOfHealingCount;
            nudDiscPrayerOfHealingHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPrayerOfHealingHealth;
            nudDiscPvPFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPFlashHealHealth;
            nudDiscPvPHealHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPHealHealth;
            nudDiscPvPPainSuppressionHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPPainSuppressionHealth;
            nudDiscPvPPenanceHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPPenanceHealth;
            nudDiscPvPPrayerOfHealingCount.Value = (decimal)Ensemble.Instance.Settings.DiscPvPPrayerOfHealingCount;
            nudDiscPvPPrayerOfHealingHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPPrayerOfHealingHealth;
            nudDiscPvPPWSHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPPWSHealth; ;
            nudDiscPvPRenewHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPRenewHealth; ;
            nudDiscPWSHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPWSHealth;
            nudDiscRenewHealth.Value = (decimal)Ensemble.Instance.Settings.DiscRenewHealth;
            cbDispelMagic.Checked = Ensemble.Instance.Settings.DispelMagic;
            cbDispelOnlyOOC.Checked = Ensemble.Instance.Settings.DispelOnlyOOC;
            cbDotAdds.Checked = Ensemble.Instance.Settings.DotAdds;
            nudGrindingPullDistance.Value = (decimal)Ensemble.Instance.Settings.GrindingPullDistance;
            nudHealPullDistance.Value = (decimal)Ensemble.Instance.Settings.HealPullDistance;
            nudHealthPotHealth.Value = (decimal)Ensemble.Instance.Settings.HealthPotHealth;
            nudHolyFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.HolyFlashHealHealth;
            nudHolyHealHealth.Value = (decimal)Ensemble.Instance.Settings.HolyHealHealth;
            nudHolyPrayerOfHealingCount.Value = (decimal)Ensemble.Instance.Settings.HolyPrayerOfHealingCount;
            nudHolyPrayerOfHealingHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPrayerOfHealingHealth;
            nudHolyPvPFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPvPFlashHealHealth;
            nudHolyPvPHealHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPvPHealHealth;
            nudHolyPvPPrayerOfHealingCount.Value = (decimal)Ensemble.Instance.Settings.HolyPvPPrayerOfHealingCount;
            nudHolyPvPPrayerOfHealingHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPvPPrayerOfHealingHealth;
            nudHolyPvPPWSHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPvPPWSHealth; ;
            nudHolyPvPRenewHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPvPRenewHealth; ;
            nudHolyPWSHealth.Value = (decimal)Ensemble.Instance.Settings.HolyPWSHealth;
            nudHolyRenewHealth.Value = (decimal)Ensemble.Instance.Settings.HolyRenewHealth;
            nudManaPotMana.Value = (decimal)Ensemble.Instance.Settings.ManaPotMana;
            cbPullWithMB.Checked = Ensemble.Instance.Settings.PullWithMB;
            nudPvPPullDistance.Value = (decimal)Ensemble.Instance.Settings.PvPPullDistance;
            nudRaFDPSMana.Value = (decimal)Ensemble.Instance.Settings.RaFDPSMana;
            nudRaFFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.RaFFlashHealHealth;
            nudRaFHealHealth.Value = (decimal)Ensemble.Instance.Settings.RaFHealHealth;
            nudRaFPWSHealth.Value = (decimal)Ensemble.Instance.Settings.RaFPWSHealth;
            nudRaFRenewHealth.Value = (decimal)Ensemble.Instance.Settings.RaFRenewHealth;
            cbRemoveDisease.Checked = Ensemble.Instance.Settings.RemoveDisease;
            nudRestHealth.Value = (decimal)Ensemble.Instance.Settings.RestHealth;
            nudRestMana.Value = (decimal)Ensemble.Instance.Settings.RestMana;
            nudShadowDispersionMana.Value = (decimal)Ensemble.Instance.Settings.ShadowDispersionMana;
            nudShadowDotHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowDotHealth;
            nudShadowDPSHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowDPSHealth;
            nudRaFDPSMana.Value = (decimal)Ensemble.Instance.Settings.ShadowDPSMana;
            nudShadowFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowFlashHealHealth;
            nudShadowHealHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowHealHealth;
            nudShadowMindSearAddCount.Value = (decimal)Ensemble.Instance.Settings.ShadowMindSearAddCount;
            nudShadowPvPFlashHealHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowPvPFlashHealHealth;
            nudShadowPvPHealHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowPvPHealHealth;
            nudShadowPvPPWSHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowPvPPWSHealth;
            nudShadowPvPRenewHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowPvPRenewHealth;
            nudShadowPWSHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowPWSHealth;
            nudShadowRenewHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowRenewHealth;
            nudShadowShadowfiendHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowShadowfiendHealth;
            nudShadowShadowfiendMana.Value = (decimal)Ensemble.Instance.Settings.ShadowShadowfiendMana;
            nudShadowSWDHealth.Value = (decimal)Ensemble.Instance.Settings.ShadowSWDHealth;
            cbUseCombatFearWard.Checked = Ensemble.Instance.Settings.UseCombatFearWard;
            cbUseCombatInnerFire.Checked = Ensemble.Instance.Settings.UseCombatInnerFire;
            cbUseCombatInnerFocus.Checked = Ensemble.Instance.Settings.UseCombatInnerFocus;
            cbUseCombatPWF.Checked = Ensemble.Instance.Settings.UseCombatPWF;
            cbUseCombatShadowform.Checked = Ensemble.Instance.Settings.UseCombatShadowform;
            cbUseCombatShadowProtection.Checked = Ensemble.Instance.Settings.UseCombatShadowProtection;
            cbUseCombatVampiricEmbrace.Checked = Ensemble.Instance.Settings.UseCombatVampiricEmbrace;
            cbUseDiscFlashHeal.Checked = Ensemble.Instance.Settings.UseDiscFlashHeal;
            cbUseDiscHeal.Checked = Ensemble.Instance.Settings.UseDiscHeal;
            cbUseDiscPainSuppression.Checked = Ensemble.Instance.Settings.UseDiscPainSuppression;
            cbUseDiscPenance.Checked = Ensemble.Instance.Settings.UseDiscPenance;
            cbUseDiscPrayerOfHealing.Checked = Ensemble.Instance.Settings.UseDiscPrayerOfHealing;
            cbUseDiscPrayerOfMending.Checked = Ensemble.Instance.Settings.UseDiscPrayerOfMending;
            cbUseDiscPvPFlashHeal.Checked = Ensemble.Instance.Settings.UseDiscPvPFlashHeal;
            cbUseDiscPvPHeal.Checked = Ensemble.Instance.Settings.UseDiscPvPHeal;
            cbUseDiscPvPPainSuppression.Checked = Ensemble.Instance.Settings.UseDiscPvPPainSuppression;
            cbUseDiscPvPPenance.Checked = Ensemble.Instance.Settings.UseDiscPvPPenance;
            cbUseDiscPvPPrayerOfHealing.Checked = Ensemble.Instance.Settings.UseDiscPvPPrayerOfHealing;
            cbUseDiscPvPPrayerOfMending.Checked = Ensemble.Instance.Settings.UseDiscPvPPrayerOfMending;
            cbUseDiscPvPPWS.Checked = Ensemble.Instance.Settings.UseDiscPvPPWS;
            cbUseDiscPvPRenew.Checked = Ensemble.Instance.Settings.UseDiscPvPRenew;
            cbUseDiscPWS.Checked = Ensemble.Instance.Settings.UseDiscPWS;
            cbUseDiscRenew.Checked = Ensemble.Instance.Settings.UseDiscRenew;
            cbUseDispersionWhileResting.Checked = Ensemble.Instance.Settings.UseDispersionWhileResting;
            cbUseEMfHs.Checked = Ensemble.Instance.Settings.UseEMfHs;
            cbUseHealthPot.Checked = Ensemble.Instance.Settings.UseHealthPot;
            cbUseHolyFlashHeal.Checked = Ensemble.Instance.Settings.UseHolyFlashHeal;
            cbUseHolyHeal.Checked = Ensemble.Instance.Settings.UseHolyHeal;
            cbUseHolyPrayerOfHealing.Checked = Ensemble.Instance.Settings.UseHolyPrayerOfHealing;
            cbUseHolyPrayerOfMending.Checked = Ensemble.Instance.Settings.UseHolyPrayerOfMending;
            cbUseHolyPvPFlashHeal.Checked = Ensemble.Instance.Settings.UseHolyPvPFlashHeal;
            cbUseHolyPvPHeal.Checked = Ensemble.Instance.Settings.UseHolyPvPHeal;
            cbUseHolyPvPPrayerOfHealing.Checked = Ensemble.Instance.Settings.UseHolyPvPPrayerOfHealing;
            cbUseHolyPvPPrayerOfMending.Checked = Ensemble.Instance.Settings.UseHolyPvPPrayerOfMending;
            cbUseHolyPvPPWS.Checked = Ensemble.Instance.Settings.UseHolyPvPPWS;
            cbUseHolyPvPRenew.Checked = Ensemble.Instance.Settings.UseHolyPvPRenew;
            cbUseHolyPWS.Checked = Ensemble.Instance.Settings.UseHolyPWS;
            cbUseHolyRenew.Checked = Ensemble.Instance.Settings.UseHolyRenew;
            cbUseManaPot.Checked = Ensemble.Instance.Settings.UseManaPot;
            cbUsePartyPWF.Checked = Ensemble.Instance.Settings.UsePartyPWF;
            cbUsePartyShadowProtection.Checked = Ensemble.Instance.Settings.UsePartyShadowProtection;
            cbUsePreCombatFearWard.Checked = Ensemble.Instance.Settings.UsePreCombatFearWard;
            cbUsePreCombatInnerFire.Checked = Ensemble.Instance.Settings.UsePreCombatInnerFire;
            cbUsePreCombatPWF.Checked = Ensemble.Instance.Settings.UsePreCombatPWF;
            cbUsePreCombatShadowform.Checked = Ensemble.Instance.Settings.UsePreCombatShadowform;
            cbUsePreCombatShadowProtection.Checked = Ensemble.Instance.Settings.UsePreCombatShadowProtection;
            cbUsePreCombatVampiricEmbrace.Checked = Ensemble.Instance.Settings.UsePreCombatVampiricEmbrace;
            cbUseRaFDevouringPlague.Checked = Ensemble.Instance.Settings.UseRaFDevouringPlague;
            cbUseRaFDispersion.Checked = Ensemble.Instance.Settings.UseRaFDispersion;
            cbUseRaFFlashHeal.Checked = Ensemble.Instance.Settings.UseRaFFlashHeal;
            cbUseRaFHeal.Checked = Ensemble.Instance.Settings.UseRaFHeal;
            cbUseRaFHolyFire.Checked = Ensemble.Instance.Settings.UseRaFHolyFire;
            cbUseRaFMindBlast.Checked = Ensemble.Instance.Settings.UseRaFMindBlast;
            cbUseRaFMindFlay.Checked = Ensemble.Instance.Settings.UseRaFMindFlay;
            cbUseRaFMindSear.Checked = Ensemble.Instance.Settings.UseRaFMindSear;
            cbUseRaFPsychicHorror.Checked = Ensemble.Instance.Settings.UseRaFPsychicHorror;
            cbUseRaFPsychicScream.Checked = Ensemble.Instance.Settings.UseRaFPsychicScream;
            cbUseRaFPWS.Checked = Ensemble.Instance.Settings.UseRaFPWS;
            cbUseRaFRenew.Checked = Ensemble.Instance.Settings.UseRaFRenew;
            cbUseRaFShadowfiend.Checked = Ensemble.Instance.Settings.UseRaFShadowfiend;
            cbUseRaFSmite.Checked = Ensemble.Instance.Settings.UseRaFSmite;
            cbUseRaFSWD.Checked = Ensemble.Instance.Settings.UseRaFSWD;
            cbUseRaFSWP.Checked = Ensemble.Instance.Settings.UseRaFSWP;
            cbUseRaFVampiricTouch.Checked = Ensemble.Instance.Settings.UseRaFVampiricTouch;
            cbUseShadowDevouringPlague.Checked = Ensemble.Instance.Settings.UseShadowDevouringPlague;
            cbUseShadowDispersion.Checked = Ensemble.Instance.Settings.UseShadowDispersion;
            cbUseShadowDispersionWhenStunned.Checked = Ensemble.Instance.Settings.UseShadowDispersionWhenStunned;
            cbUseShadowFlashHeal.Checked = Ensemble.Instance.Settings.UseShadowFlashHeal;
            cbUseShadowHeal.Checked = Ensemble.Instance.Settings.UseShadowHeal;
            cbUseShadowHolyFire.Checked = Ensemble.Instance.Settings.UseShadowHolyFire;
            cbUseShadowMindBlast.Checked = Ensemble.Instance.Settings.UseShadowMindBlast;
            cbUseShadowMindFlay.Checked = Ensemble.Instance.Settings.UseShadowMindFlay;
            cbUseShadowMindSear.Checked = Ensemble.Instance.Settings.UseShadowMindSear;
            cbUseShadowPsychicHorror.Checked = Ensemble.Instance.Settings.UseShadowPsychicHorror;
            cbUseShadowPsychicScream.Checked = Ensemble.Instance.Settings.UseShadowPsychicScream;
            cbUseShadowPvPDevouringPlague.Checked = Ensemble.Instance.Settings.UseShadowPvPDevouringPlague;
            cbUseShadowPvPDispersion.Checked = Ensemble.Instance.Settings.UseShadowPvPDispersion;
            cbUseShadowPvPFlashHeal.Checked = Ensemble.Instance.Settings.UseShadowPVPFlashHeal;
            cbUseShadowPvPHeal.Checked = Ensemble.Instance.Settings.UseShadowPVPHeal;
            cbUseShadowPvPHolyFire.Checked = Ensemble.Instance.Settings.UseShadowPvPHolyFire;
            cbUseShadowPvPMindBlast.Checked = Ensemble.Instance.Settings.UseShadowPvPMindBlast;
            cbUseShadowPvPMindFlay.Checked = Ensemble.Instance.Settings.UseShadowPvPMindFlay;
            cbUseShadowPvPPsychicHorror.Checked = Ensemble.Instance.Settings.UseShadowPvPPsychicHorror;
            cbUseShadowPvPPsychicScream.Checked = Ensemble.Instance.Settings.UseShadowPvPPsychicScream;
            cbUseShadowPvPPWS.Checked = Ensemble.Instance.Settings.UseShadowPvPPWS;
            cbUseShadowPvPRenew.Checked = Ensemble.Instance.Settings.UseShadowPVPRenew;
            cbUseShadowPvPShadowfiend.Checked = Ensemble.Instance.Settings.UseShadowPvPShadowfiend;
            cbUseShadowPvPSmite.Checked = Ensemble.Instance.Settings.UseShadowPvPSmite;
            cbUseShadowPvPSWD.Checked = Ensemble.Instance.Settings.UseShadowPvPSWD;
            cbUseShadowPvPSWP.Checked = Ensemble.Instance.Settings.UseShadowPvPSWP;
            cbUseShadowPvPVampiricTouch.Checked = Ensemble.Instance.Settings.UseShadowPvPVampiricTouch;
            cbUseShadowPWS.Checked = Ensemble.Instance.Settings.UseShadowPWS;
            cbUseShadowRenew.Checked = Ensemble.Instance.Settings.UseShadowRenew;
            cbUseShadowShadowfiend.Checked = Ensemble.Instance.Settings.UseShadowShadowfiend;
            cbUseShadowSilence.Checked = Ensemble.Instance.Settings.UseShadowSilence;
            cbUseShadowSmite.Checked = Ensemble.Instance.Settings.UseShadowSmite;
            cbUseShadowSWD.Checked = Ensemble.Instance.Settings.UseShadowSWD;
            cbUseShadowSWP.Checked = Ensemble.Instance.Settings.UseShadowSWP;
            cbUseShadowVampiricTouch.Checked = Ensemble.Instance.Settings.UseShadowVampiricTouch;
            cbUseWand.Checked = Ensemble.Instance.Settings.UseWand;
            cbUseWotF.Checked = Ensemble.Instance.Settings.UseWotF;
            cbUseDiscPvPSmite.Checked = Ensemble.Instance.Settings.UseDiscPvPSmite;
            nudDiscPvPSmiteMana.Value = (decimal)Ensemble.Instance.Settings.DiscPvPSmiteMana;
            cbUseDiscSmite.Checked = Ensemble.Instance.Settings.UseDiscSmite;
            nudDiscSmiteMana.Value = (decimal)Ensemble.Instance.Settings.DiscSmiteMana;
            nudDiscGreaterHealHealth.Value = (decimal)Ensemble.Instance.Settings.DiscGreaterHealHealth;
            cbUseDiscGreaterHeal.Checked = Ensemble.Instance.Settings.UseDiscGreaterHeal;
            nudDiscPvPGreaterHealHealth.Value = (decimal)Ensemble.Instance.Settings.DiscPvPGreaterHealHealth;
            cbUseDiscPvPGreaterHeal.Checked = Ensemble.Instance.Settings.UseDiscPvPGreaterHeal;
            cbUsePullPWS.Checked = Ensemble.Instance.Settings.UsePullPWS;
        }
    }
}
