using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Styx;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;

namespace SmartUtility
{
    /*- Utility Plugin: 
     * Clear Quest Log
     * Empty Bags (insane)
     * Unlearn all Tradeskills
     * -- FULL VERBOSE OF ACTIONS!
     */
    public abstract class SmartUtility : HBPlugin
    {

        public void ClearQuestLog()
        {
            using (new FrameLock())
            {
                var numQuestLogEntries = Lua.GetReturnValues("return GetNumQuestLogEntries();");
                if (numQuestLogEntries != null)
                {
                    int numQuests = Convert.ToInt32(numQuestLogEntries[1]);
                    for (int i = 1; i <= numQuests; i++)
                    {
                        Lua.DoString("SetAbandonQuest(" + i + ");");
                        StyxWoW.SleepForLagDuration();
                        Lua.DoString("AbandonQuest()");
                        StyxWoW.SleepForLagDuration();
                    }
                }
            }
            /*
             * numEntries, numQuests = GetNumQuestLogEntries()
             * Returns:             * 
             * numEntries - Total number of entries (quests and headers) (number)
             * numQuests - Number of quests only (number)
             * 
             * SetAbandonQuest(questIndex)
             * Arguments:             * 
             * questIndex - Index of a quest in the quest log (between 1 and GetNumQuestLogEntries()) (number)
             * 
             * * Confirms abandoning a quest. Use SetAbandonQuest() first to select the quest to abandon.
             * See also Quest functions.
             * Signature:
             * AbandonQuest()
             */
        }

        public void EmptyBags()
        {
            using (new FrameLock())
            {
                foreach (var woWItem in StyxWoW.Me.BagItems)
                {
                    woWItem.PickUp();
                    StyxWoW.SleepForLagDuration();
                    Lua.DoString("DeleteCursorItem();");
                    StyxWoW.SleepForLagDuration();
                }
            }
            /*DeleteCursorItem():
             * Destroys the item on the cursor. Used in the default UI when accepting the confirmation prompt 
             * that appears when dragging and dropping an item to an empty area of the screen.
             * 
             * PickupContainerItem(container, slot)
             * Arguments:
             * container - Index of one of the player's bags or other containers (number, containerID)
             * slot - Index of an item slot within the container (number, containerSlotID)
             */

        }

        public void UnlearnTradeskills()
        {
            
        }

        public override string Name
        {
            get { return "SmnartUtility"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0,0,1,0); }
        }
    }
}
