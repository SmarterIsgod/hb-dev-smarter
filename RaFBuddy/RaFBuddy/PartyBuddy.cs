using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using Styx;
using Styx.Helpers;
using Styx.Logic;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

namespace RaFBuddy
{
    public class PartyBuddy : HBPlugin
    {
        private readonly WaitTimer _createPartyTimer = WaitTimer.ThirtySeconds;
        private readonly LocalPlayer _me = StyxWoW.Me;
        private readonly WaitTimer _partyCheckTimer = WaitTimer.ThirtySeconds;
        private readonly List<string> _partyMembers = new List<string>(4);
        private bool _firstPulse = true;
        private List<string> _followerList;
        private bool _leaderCheck;
        private string _leaderName;
        private MemberType _memberType;

        public override string Name
        {
            get { return "PartyBuddy"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0, 0, 2, 6); }
        }

        public override void Pulse()
        {
            if (_firstPulse)
            {
                // -- CONFIGURATION -----------------//
                _followerList = new List<string> {"player1", "player2", "player3", "player4"};
                _leaderName = "leaderName";
                _memberType = _me.Name == _leaderName ? MemberType.Leader : MemberType.Member;
                _leaderCheck = false; // Check if I am Leader | Set to False if doing Random Dungeons. 

                //EOF CONFIGURATION -----------------//
                Lua.Events.AttachEvent("PARTY_INVITE_REQUEST", HandlePartyInvite);
                Lua.Events.AttachEvent("PARTY_MEMBERS_CHANGED", HandlePartyMembersChanged);
                Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: Attached Events");
                _firstPulse = false;
            }

            if (_partyCheckTimer.IsFinished)
            {
                Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: Party Check Timer Finished");

                using (new FrameLock())
                {
                    if (Lua.GetReturnVal<bool>("return StaticPopup_Visible(\"PARTY_INVITE\");", 0))
                    {
                        Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: Party Invite Popup is Visible, Hiding...");
                        Lua.DoString("StaticPopup_Hide(\"PARTY_INVITE\");");
                        StyxWoW.SleepForLagDuration();
                    }
                }

                CheckForFollowers();
                _partyCheckTimer.Reset();
            }
        }

        private static bool IsPartyLeader()
        {
            Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: IsPartyLeader()?");
            return Lua.GetReturnVal<bool>("return IsPartyLeader();", 0);
        }

        private void CheckForFollowers()
        {
            Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: CheckForFollowers():");
            if (!_me.IsInParty) // If i'm not in a Party
            {
                Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: CheckForFollowers(): I am NOT in a Party");
                if (_memberType == MemberType.Leader) //If i'm not in a Party AND i'm SUPPOSED to be the leader.
                {
                    Logging.WriteDebug(Color.AliceBlue,
                                       "[PartyBuddy]: CheckForFollowers(): I AM supposed to be the Leader");
                    CreateParty();
                    return;
                }
            }

            BuildPartyList();

            if (_me.IsInInstance || Battlegrounds.IsInsideBattleground || _me.IsInRaid) return;

            if (_leaderCheck)
            {
                if (!IsPartyLeader()) //If i'm in a Party, and I am NOT the Leader
                {
                    if (_memberType == MemberType.Leader)
                        //If i'm in a Party, and I am NOT the Leader, and I'm Supposed to be, GTFO!?
                    {
                        Logging.WriteDebug(Color.AliceBlue,
                                           "[PartyBuddy]: CheckForFollowers(): I am NOT the Leader, and i'm supposed to be! - Leaving Party");
                        Lua.DoString("LeaveParty()");
                        StyxWoW.SleepForLagDuration();
                        return;
                    }
                    var isLeaderCorrect =
                        Lua.GetReturnVal<bool>("return UnitIsPartyLeader(\"" + _leaderName + "\");", 0);
                    if (!isLeaderCorrect)
                    {
                        Logging.WriteDebug(Color.AliceBlue,
                                           "[PartyBuddy]: CheckForFollowers(): The Party Leader is Incorrect (WTF?) - Leaving Party");
                        Lua.DoString("LeaveParty()");
                        StyxWoW.SleepForLagDuration();
                    }
                    return;
                }
                Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: CheckForFollowers(): I AM the Party Leader");
            }

            foreach (string user in _followerList.Where(user => !_partyMembers.Contains(user)))
            {
                Logging.WriteDebug(Color.AliceBlue,
                                   "[PartyBuddy]: CheckForFollowers(): Party Does NOT contain " + user +
                                   " attempting to correct");
                if (_partyMembers.Count < 4)
                {
                    Logging.WriteDebug(Color.AliceBlue,
                                       "[PartyBuddy]: CheckForFollowers(): Party has room, attempting to invite " +
                                       user + " to the party");
                    Lua.DoString("InviteUnit(\"" + user + "\");");
                    StyxWoW.SleepForLagDuration();
                }
                if (_partyMembers.Count == 4)
                {
                    Logging.WriteDebug(Color.AliceBlue,
                                       "[PartyBuddy]: CheckForFollowers(): Party is Full, Leaving Party");
                    Lua.DoString("LeaveParty()");
                    StyxWoW.SleepForLagDuration();
                    return;
                }
            }
        }

        private void CreateParty()
        {
            if (_createPartyTimer.IsFinished)
            {
                Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: CreateParty(): Creating Party!");
                foreach (string user in _followerList)
                {
                    Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: CreateParty(): Inviting " + user);
                    Lua.DoString("InviteUnit(\"" + user + "\");");
                    StyxWoW.SleepForLagDuration();
                }
                _createPartyTimer.Reset();
            }
        }

        private void HandlePartyMembersChanged(object sender, LuaEventArgs args)
        {
            Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: PARTY_MEMBERS_CHANGED");
            if (_me.IsInParty)
            {
                Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: PARTY_MEMBERS_CHANGED: I am IN a party.");
                BuildPartyList();
            }
        }

        private void BuildPartyList()
        {
            Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: BuildPartyList()");

            using (new FrameLock())
            {
                _partyMembers.Clear();
                for (int i = 1; i <= Lua.GetReturnVal<int>("return GetNumPartyMembers();", 0); i++)
                {
                    var unitNameRealm = Lua.GetReturnValues("return UnitName(\"party" + i + "\");");
                    Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: BuildPartyList(): Adding " + unitNameRealm[0]);
                    _partyMembers.Add(unitNameRealm[0]);
                }
            }
        }

        private void HandlePartyInvite(object sender, LuaEventArgs args)
        {
            Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: PARTY_INVITE");
            string inviteSender = args.Args[0].ToString();
            Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: PARTY_INVITE: From - " + inviteSender);

            if (!_me.IsInParty && _memberType == MemberType.Member)
            {
                Logging.WriteDebug(Color.AliceBlue,
                                   "[PartyBuddy]: PARTY_INVITE: I am NOT in a party && I am NOT supposed to be a leader");
                if (inviteSender == _leaderName)
                {
                    Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: PARTY_INVITE: Accepting Group Invite");
                    Lua.DoString("AcceptGroup()");
                }
            }
        }
    }

    public enum MemberType
    {
        Leader,
        Member
    }
}