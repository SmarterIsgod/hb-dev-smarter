using System;
using System.Collections.Generic;
using Styx;
using Styx.Helpers;
using Styx.Plugins.PluginClass;
using System.Data.SqlClient;
using Styx.WoWInternals;
using System.Linq;
using Styx.WoWInternals.WoWObjects;


namespace GatherMateBuddy
{
    public class GatherMateBuddy : HBPlugin
    {
        private bool _firstPulse = true;
        private List<WoWGameObject> _nodeList = new List<WoWGameObject>();
        private Dictionary<ulong,DateTime> _seenList = new Dictionary<ulong, DateTime>();
        private WaitTimer _refreshTimer = WaitTimer.FiveSeconds;
        private WaitTimer _updateTimer = WaitTimer.TenSeconds;
        private WaitTimer _seenTimer = new WaitTimer(new TimeSpan(0,0,10,0));
        private SqlConnection _sqlConnection;
        private NodeDatabaseDataSet _nodeDataSet = new NodeDatabaseDataSet();
        private SqlDataAdapter _dataAdapter;

        public override void Dispose()
        {
            _sqlConnection.Close();
        }

        public override void Pulse()
        {
            if (_firstPulse)
            {
                _sqlConnection = new SqlConnection(@"Data Source=C:\Users\Smarter\Desktop\Botting\Development\GatherMateBuddy\GatherMateBuddy\NodeDatabase.sdf");
                _dataAdapter = new SqlDataAdapter("Select * from NodeData", _sqlConnection);
                // Other Startup Stuff?
                _firstPulse = false;
            }

            if (_refreshTimer.IsFinished)
            {
                var nearbyNodes =
                    ObjectManager.GetObjectsOfType<WoWGameObject>().Where(o => o.IsHerb || o.IsMineral).OrderBy(
                        o => o.Distance);
                if (nearbyNodes.Count() > 1)
                {
                    lock (_nodeList)
                    {
                        foreach (var node in nearbyNodes.Where(node => !_nodeList.Contains(node) && !_seenList.ContainsKey(node.Guid)))
                        {
                            _nodeList.Add(node);
                        }
                    }
                }
                _refreshTimer.Reset();
            }


            if (_updateTimer.IsFinished)
            {
                var nodeList = _nodeList;
                _nodeDataSet.Clear();
                _dataAdapter.Fill(_nodeDataSet);
                foreach (WoWGameObject o in nodeList)
                {
                    _nodeDataSet.Tables["Node Data"].Rows.Add(new object[] {o.Name, o.Entry, o.X, o.Y, o.Z, 0});
                }
                _dataAdapter.Update(_nodeDataSet);

                _updateTimer.Reset();
            }


            if (_seenTimer.IsFinished)
            {
                var seenList = _seenList;
                foreach (KeyValuePair<ulong, DateTime> pair in
                    from pair in seenList
                    let duration = DateTime.Now.Subtract(pair.Value)
                    where duration.Minutes >= 10
                    select pair)
                {
                    lock (_seenList)
                    {
                        _seenList.Remove(pair.Key);
                    }
                }
                _seenTimer.Reset();
            }

        }

        public override string Name
        {
            get { return "GatherMateBuddy"; }
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
