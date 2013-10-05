using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using Styx.Helpers;
using Styx.WoWInternals;

namespace RaFBuddy
{
    public class Party
    {

        public PartyType Type
        {
            get
            {
                throw new System.NotImplementedException();
            }
        }

        private List<PartyMember> _memberList; 
        public List<PartyMember> Members
        {
            get
            {
                /*
                 * Check for In Party
                 * Check for PartyType
                 * Build list based on PartyType
                 */
                _memberList.Clear();
                for (int i = 1; i <= Lua.GetReturnVal<int>("return GetNumPartyMembers();", 0); i++)
                {
                    var unitNameRealm = Lua.GetReturnValues("return UnitName(\"party" + i + "\");");
                    Logging.WriteDebug(Color.AliceBlue, "[PartyBuddy]: BuildPartyList(): Adding " + unitNameRealm[0]);
                    //_member.Add(unitNameRealm[0]);
                }
            }
        }

        public PartyMember Leader
        {
            get
            {
                /* Find Leader, assign to Member's Object
                 * 
                 * leader = UnitIsPartyLeader("unit") or UnitIsPartyLeader("name")
                 * Arguments:
                 * unit - A unit to query (string, unitID)
                 * name - The name of a unit to query (string)
                 * Returns:
                 * leader - 1 if the unit is the party leader; otherwise nil (1nil)
                 */
            }
        }

        public UnitReadyStatus ReadyStatus
        {
            get
            {
                /*
                 * Check each Party Member, return worst status.
                 * 
                 * status = GetReadyCheckStatus("unit")
                 * Arguments: 
                 * unit - A unit in the player's party or raid (string, unitID)
                 * Returns:
                 * status - Ready check status for the unit (string)
                 * "notready" - Unit has responded as not ready
                 * "ready" - Unit has responded as ready
                 * "waiting" - Unit has not yet responded
                 * nil - No ready check is in progress
                 * 
                 */
            }
        }

        public void Invite(string name)
        {
            Lua.DoString(string.Format("InviteUnit(\"{0}\");", name));
        }

        public void Leave()
        {
            Lua.DoString("LeaveParty();");
        }

        public void Accept()
        {
            Lua.DoString("AcceptGroup();");
        }

        public void Convert(PartyType type)
        {
            /*
             * Check for In Party
             * Check for Party Leader
             * Only Change from Standard to Raid
             *  If PartyType == PartyType.Raid
             *   -> Lua.DoString("ConvertToParty();");
             *  If PartyType == PartyType.Standard
             *   -> Lua.DoString("ConverToRaid();");
             */


        }

        public void DoReadyCheck()
        {
            //check for running readycheck
            Lua.DoString("DoReadyCheck();");
        }

        public void SetRole()
        {
            /*
             * UnitSetRole("unit", "role")
             * Arguments:
             * unit - Unit to modify (string, unitID)
             * role - The unit's role string (string)
             * DAMAGER
             * HEALER
             * NONE
             * TANK
             */
        }

        public void ConfirmReadyCheck()
        {
            /*
             * ConfirmReadyCheck(ready)
             * Arguments:
             * ready - True to report as "ready"; false to report as "not ready" (true)
             */
        }

        public void Decline()
        {
            Lua.DoString("DeclineGroup();");
        }

        public bool InParty
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
            }
        }
    }

    public enum PartyType
    {
        None,
        Standard,
        LFG,
        PvP,
        Raid,
        Guild,
    }
}
