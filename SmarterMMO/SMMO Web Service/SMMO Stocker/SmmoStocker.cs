using System;
using Styx;
using Styx.Helpers;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;

namespace SMMO_Stocker
{
    public class SmmoStocker : HBPlugin
    {
        private bool _firstPulse = true;
        private int _characterCopper;
        private int _guildCopper;
        private string _realmName;
        private readonly WaitTimer _updateStockTimer = new WaitTimer(new TimeSpan(0,0,30,0));

        public override void Pulse()
        {
            if (_firstPulse)
            {
                Lua.Events.AttachEvent("GUILDBANKFRAME_OPENED", GuildBankFrameOpened);
                Lua.Events.AttachEvent("GUILDBANK_UPDATE_MONEY", GuildBankUpdateMoney);
                _characterCopper = Convert.ToInt32(StyxWoW.Me.Copper);
                _realmName = GetRealmName();
                _firstPulse = false;
            }
            if (!_updateStockTimer.IsFinished) return;
            UpdateStockRegister();
            _updateStockTimer.Reset();
        }

        

        private void UpdateStockRegister()
        {
            var service = new SmmoWebService.SmmoServiceClient();
            service.UpdateStock(_realmName, StyxWoW.Me.Name, _characterCopper, _guildCopper);
            service.Close();
        }

        #region Events
        private void GuildBankUpdateMoney(object sender, LuaEventArgs args)
        {
            _guildCopper = GetGuildCopper();
        }

        private void GuildBankFrameOpened(object sender, LuaEventArgs args)
        {
            _guildCopper = GetGuildCopper();
        }
        #endregion
        #region Helper Functions
        private static int GetGuildCopper()
        {
            return Lua.GetReturnVal<int>("return GetGuildBankMoney();", 0);
        }
        private static string GetRealmName()
        {
            return Lua.GetReturnVal<string>("return GetRealmName();", 0);
        }
        #endregion
        #region Plugin Information
        public override string Name
        {
            get { return "SmarterMMO"; }
        }

        public override string Author
        {
            get { return "SmarterMMO"; }
        }

        public override Version Version
        {
            get { return new Version(0,0,1,0); }
        }
        #endregion

    }
}
