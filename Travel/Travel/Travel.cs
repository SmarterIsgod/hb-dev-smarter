using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using Styx;
using Styx.Helpers;
using Styx.Logic.Pathing;
using Styx.Patchables;
using Styx.WoWInternals;

namespace Travel
{
    public class Travel
    {
        private List<Map> _mapList = new List<Map>();
        public void TesT()
        {
            var location = new WoWPoint(-1303.223, 6580.17, 147.7242);
            GenerateMapList();
            Logging.Write("Attempting to find ZoneID from Location: " + location);
            
            foreach (var map in _mapList)
            {
                /*
                * public float AY; //Upper Left Y 
                * public float BY; //Lower Right Y
                * public float AX; //Upper Left X
                * public float BX; //Lower Right X
                */
                if (location.X <= map.AX && location.X >= map.BX && location.Y <= map.AY && location.Y >= map.BY)
                {
                    Logging.Write(string.Format("Your Location is in Zone: [{0}] {1}", map.Id, map.WorldMapName));
                }
            }
        }
        private void GenerateMapList()
        {
            var worldMapArea = StyxWoW.Db[ClientDb.WorldMapArea];

            for (int i = worldMapArea.MinIndex; i <= worldMapArea.MaxIndex; i++)
            {
                var worldMapAreaFields = worldMapArea.GetRow((uint)i);
                var rowData = worldMapAreaFields.GetStruct<WorldMapAreaRecord>();

                if (rowData.Id != 0)
                {
                    _mapList.Add(new Map((uint)i));
                }
            }
            Logging.Write("Maps Generated: " + _mapList.Count);
        }

        public class Map
        {
            private readonly WoWDb.DbTable _worldMapArea = StyxWoW.Db[ClientDb.WorldMapArea];
            private readonly WoWDb.Row _worldMapAreaFields;
            WorldMapAreaRecord _rowData;

            public Map(uint id)
            {
                _worldMapAreaFields = _worldMapArea.GetRow(id);
                _rowData = _worldMapAreaFields.GetStruct<WorldMapAreaRecord>();
            }

            public int Id { get { return _rowData.MapId; } }
            public float AY { get { return _rowData.AY; } }
            public float BY { get { return _rowData.BY; } }
            public float AX { get { return _rowData.AX; } }
            public float BX { get { return _rowData.BX; } }
            public string WorldMapName { get { return _rowData.WorldMapName; } }
            public override string ToString()
            {
                return _rowData.ToString();
            }
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct WorldMapAreaRecord
        {
            public int Id;
            public int MapId;
            public int AreaTableId;
            public uint WorldMapNamePtr;
            public float AY; //Upper Left Y 
            public float BY; //Lower Right Y
            public float AX; //Upper Left X
            public float BX; //Lower Right X
            public int VirtualMapId;
            public int DungeonMapId;

            public string WorldMapName
            {
                get
                {
                    return ObjectManager.Wow.Read<string>(WorldMapNamePtr);
                }
            }

            public override string ToString()
            {
                return
                    string.Format(
                        "Id: {0}, MapId: {1}, AreaTableId: {2}, WorldMapName: {3}, Ay: {4}, By: {5}, Ax: {6}, Bx: {7}, VirtualMapId: {8}, DungeonMapId: {9}",
                        Id,
                        MapId,
                        AreaTableId,
                        WorldMapName,
                        AY,
                        BY,
                        AX,
                        BX,
                        VirtualMapId,
                        DungeonMapId);
            }
        }
    }

}
