using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Styx.WoWInternals;

namespace RaFBuddy
{
    public class PartyMember
    {
        public PartyMember()
        {
            //If Party, Gather Individually
            //If Raid, Implement: GetRaidRosterInfo
        }

        
        public int Name
        {
            get
            {

            }
        }

        public Styx.WoWInternals.WoWObjects.WoWUnit Unit
        {
            get
            {
                throw new System.NotImplementedException();
            }
        }

        public bool Leader
        {
            get
            {
                /* Check this Unit for Leader
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

        public UnitRole Role
        {
            get
            {
                /*
                 * Returns information about a unit's role in a LFD party
                 * role = UnitGroupRolesAssigned("unit")
                 * Arguments:
                 * unit - Unit to query (string, unitID)
                 * Returns:
                 * role - Returns the unit's role (string)
                 * DAMAGER
                 * HEALER
                 * NONE
                 * TANK
                 */
            }
        }

        public UnitAssignment Assignment
        {
            get
            {
                /*
                 * isAssigned = GetPartyAssignment("assignment", "unit") or GetPartyAssignment("assignment", "name" [, exactMatch])
                 * 
                 * Arguments:
                 * assignment - A group role assignment (string)
                 * MAINASSIST - Return whether the unit is assigned the main assist role
                 * MAINTANK - Return whether the unit is assigned the main tank role
                 * unit - A unit in the player's party or raid (string, unitID)
                 * name - Name of a unit in the player's party or raid (string)
                 * exactMatch - True to check only units whose name exactly matches the name given; false to allow partial matches (boolean)
                 * 
                 * Returns:
                 * isAssigned - 1 if the unit is assigned the specified role; otherwise nil (1nil)
                 */
            }
        }

        public UnitReadyStatus ReadyStatus
        {
            get
            {
                /*
                 * status = GetReadyCheckStatus("unit")
                 * Arguments:                 * 
                 * unit - A unit in the player's party or raid (string, unitID)
                 * Returns:
                 * status - Ready check status for the unit (string)
                 * "notready" - Unit has responded as not ready
                 * "ready" - Unit has responded as ready
                 * "waiting" - Unit has not yet responded
                 * nil - No ready check is in progress
                 */
            }
        }

        public int GroupId
        {
            get
            {
                /*
                 * If Raid Group
                 * 
                 */
            }
        }
    
        public void Remove()
        {
            /*
             * Check If Party Leader
             * UninviteUnit("name", "reason")
             * name - Name of a character to uninvite (string)
             * reason - Reason for the action, optional and may be left as a nil value (string)
             */
        }

        public void Promote()
        {
            /*
             * 
             * PromoteToLeader("unit") or PromoteToLeader("name" [, exactMatch])
             * Arguments:
             * unit - A unit in the party or raid (string, unitID)
             * name - Name of a party member (string)
             * exactMatch - True to check only units whose name exactly matches the name given; false to allow partial matches (boolean)
             * 
             * PromoteToAssistant - Promotes a raid member to raid assistant
             */
        }

        public void SetAssignment()
        {
           /*
            * SetPartyAssignment("assignment", "unit") or SetPartyAssignment("assignment", "name" [, exactMatch])
            * Arguments:
            * assignment - A group role to assign to the unit (string)
            * MAINASSIST - Assign the main assist role
            * MAINTANK - Assign the main tank role
            * unit - A unit in the player's party or raid (string, unitID)
            * name - Name of a unit in the player's party or raid (string)
            * exactMatch - True to check only units whose name exactly matches the name given; false to allow partial matches (boolean)
            */
        }

        public void Demote()
        {
            /*
             * DemoteAssistant("unit") or DemoteAssistant("name" [, exactMatch])
             * Arguments:
             * unit - A unit in the raid (string, unitID)
             * name - Name of a unit in the raid (string)
             * exactMatch - True to check only units whose name exactly matches the name given; false to allow partial matches (boolean)
             */
        }

        public void SetRaidSubgroup()
        {
            /*Only has effect if the player is the raid leader or a raid assistant
             * SetRaidSubgroup(index, subgroup)
             * Arguments:
             * index - Index of the raid member (between 1 and GetNumRaidMembers()); matches the numeric part of the unit's raid unitID, e.g. 21 for raid21 (number)
             * subgroup - Index of a raid subgroup (between 1 and MAX_RAID_GROUPS) (number)
             * 
             */
        }

        public void SwapRaidSubgroup()
        {
            /* Only has effect if the player is the raid leader or a raid assistant.
             * SwapRaidSubgroup(index1, index2)
             * Arguments:
             * index1 - Index of the first raid member (between 1 and GetNumRaidMembers()); matches the numeric part of the unit's raid unitID, e.g. 21 for raid21 (number)
             * index2 - Index of the other raid member (number)
             */
        }
    }

    public enum UnitRole
    {
        None,
        Damage,
        Healer,
        Tank,
    }

    public enum UnitAssignment
    {
        MainTank,
        MainAssist,
        None,
    }

    public enum UnitReadyStatus
    {
        None,
        NotReady,
        Ready,
        Waiting,
    }
    public enum RaidRank
    {
        Member,
        Assistant,
        Leader
    }

    public class RaidRosterInfo
    {
        public RaidRosterInfo(string unit)
        {
            /*name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index)
             * Arguments:
             * index - Index of the raid member (between 1 and GetNumRaidMembers()); matches the numeric part of the unit's raid unitID, e.g. 21 for raid21 (number)
             */
            
        }

        //name - Name of the raid member (string)
        public string Name;

        //rank - Rank of the member in the raid (number)
        //  0 - Raid member
        //  1 - Raid Assistant
        //  2 - Raid Leader
        public RaidRank Rank;

        //subgroup - Index of the raid subgroup to which the member belongs (between 1 and MAX_RAID_GROUPS) (number)
        public int SubgroupId;

        //level - Character level of the member (number)
        public int Level;

        //class - Localized name of the member's class (string)
        public string Class;

        //fileName - A non-localized token representing the member's class (string)
        
        //zone - Name of the zone in which the member is currently located (string)
        public string Zone;

        //online - 1 if the member is currently online; otherwise nil (1nil)
        public bool Online;

        public bool Alive;
        //isDead - 1 if the member is currently dead; otherwise nil (1nil)

        public UnitAssignment Assignment;
        //role - Group role assigned to the member (string)
        //  MAINASSIST
        //  MAINTANK

        public bool MasterLooter;
        //isML - 1 if the member is the master looter; otherwise nil (1nil)
    }
}
