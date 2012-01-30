using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.IO;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using Styx;
using Styx.Logic.Pathing;
using Styx.Patchables;
using Styx.WoWInternals;


namespace HotspotFetcher
{
    public static class Wowhead
    {
        public static string FetchNpcLocations(int npcId)
        {
            var myRequest = (HttpWebRequest)WebRequest.Create("http://www.wowhead.com/npc=" + npcId);
            myRequest.Method = "GET";
            myRequest.UserAgent =
                "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13";
            string result;
            using (var myResponse = myRequest.GetResponse())
            {
                var sr = new StreamReader(myResponse.GetResponseStream());
                result = sr.ReadToEnd();
                sr.Close();
                myResponse.Close();
            }
            return result;
        }

        
        public class WowheadParser
        {
            private readonly string _pageData;
            #region Regex Strings

            private const string MapIdRegex = @"g_mapperData = \{\n(?<MapId>\d{2,4}):";
            private const string CoordCountRegex = @"0: { count: (?<CoordCount>\d+?),";
            private const string CoordsRegex = @"\[(?<Coord>\d{2,2}.\d,\d{2,2}.\d|\d{2,2},\d{2,2}.\d|\d{2,2}.\d,\d{2,2})\]";
            #endregion

            public WowheadParser(string pageData)
            {
                _pageData = pageData;
            }

            public int CoordsCount
            {
                get
                {
                    var r = new Regex(CoordCountRegex, RegexOptions.None);
                    var match = r.Match(_pageData);
                    int count = 0;

                    if (match.Success)
                    {
                        return Convert.ToInt32(match.Groups["CoordCount"].Value);
                    }
                    return count;
                }
            }

            private uint MapId
            {
                get
                {
                    var r = new Regex(MapIdRegex, RegexOptions.None);
                    var match = r.Match(_pageData);
                    uint mapid = 0;
                    if (match.Success)
                    {
                        return Convert.ToUInt32(match.Groups["MapId"].Value);
                    }
                    return mapid;
                    
                }
            }
            public IEnumerable<WowheadCoord> WowheadCoords
            {
                get
                {
                    var r = new Regex(CoordsRegex, RegexOptions.None);
                    var matches = r.Matches(_pageData);
                    var coords = new List<WowheadCoord>(matches.Count);

                   
                    if (matches.Count > 0)
                    {
                        coords.AddRange(from Match m in matches
                                        select m.Groups["Coord"].Value.Split(',')
                                        into split select new WowheadCoord(float.Parse(split[0]), float.Parse(split[1]), MapId));
                    }
                    return coords;
                }
            }
        }
        

    }

    public class WowheadCoord
    {
        private readonly float _x;
        private readonly float _y;
        private readonly uint _mapId;
        private readonly uint _rowId;

        public WowheadCoord(float x, float y, uint mapId)
        {
            _x = x;
            _mapId = mapId;
            _y = y;
            _rowId = GetRowFromMapId(MapId);
        }

        public float X
        {
            get
            {
                return _x;
            }
        }

        private uint MapId
        {
            get
            {
                return _mapId;
            }
        }
        public float Y
        {
            get
            {
                return _y;
            }
        }
        private static uint GetRowFromMapId(uint mapId)
        {
            WoWDb.DbTable worldMapArea = StyxWoW.Db[ClientDb.WorldMapArea];
            uint rowid = mapId;
            for (int i = worldMapArea.MinIndex; i <= worldMapArea.MaxIndex; i++)
            {
                var row = worldMapArea.GetRow((uint) i);
                var rowStruct = row.GetStruct<WorldMapAreaRecord>();
                if (mapId == rowStruct.AreaTableId)
                {
                    return (uint) i;
                }
            }
            return rowid;

        }


        public WoWPoint ToLocation()
        {
            var wmc = new WorldMapCoord(_x, _y, _mapId);
            var worldPoint = new WoWPoint();
            var worldMapArea = StyxWoW.Db[ClientDb.WorldMapArea];
            var worldMapAreaFields = worldMapArea.GetRow(_rowId);
            var rowData = worldMapAreaFields.GetStruct<WorldMapAreaRecord>();
            //Logging.Write("You are at {0}, {1} relative", (myLoc.Y - a.Y) / (b.Y - a.Y), (myLoc.X - a.X) / (b.X - a.X));
            
            //worldPoint.X = rowData.AX + (wmc.Y * (rowData.BX - rowData.AX));
            //worldPoint.Y = rowData.AY + (wmc.X * (rowData.BY - rowData.AY));
            float width = rowData.BX < 0 && rowData.AX < 0
                              ? ((0 - rowData.AX) - (0 - rowData.BX))/100
                              : (rowData.BX - rowData.AX)/100;

            float height = rowData.BY < 0 && rowData.AY < 0
                               ? (rowData.BY - rowData.AY)/100
                               : ((0 - rowData.AY) - (0 - rowData.BY))/100;

            worldPoint.X = rowData.AX - (width * wmc.Y);
            worldPoint.Y = rowData.AY - (height * wmc.X);
            //AY = UL
            //BY = LR
            //AX = UL
            //BX = LR
            worldPoint.Z = Navigator.FindHeights(worldPoint.X, worldPoint.Y).Count == 0 ? 0 : Navigator.FindHeights(worldPoint.X, worldPoint.Y).Max();
            
            /*
             * worldPoint.X = ax + (wmc.Y * (bx - ax));
            worldPoint.Y = ay + (wmc.X * (by - ay));
            worldPoint.Z = Navigator.FindMeshHeights(worldPoint.X, worldPoint.Y).Max();
             */
            return worldPoint;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct WorldMapAreaRecord
        {
            public int Id;
            public int MapId;
            public int AreaTableId;
            public uint WorldMapNamePtr;
            public float AY;
            public float BY;
            public float AX;
            public float BX;
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

    struct WorldMapCoord : IEquatable<object>
    {
        public float X { get; set; }
        public float Y { get; set; }
        public uint MapId { get; set; }

        public WorldMapCoord(float x, float y, uint mapid) : this()
        {
            MapId = mapid;
            X = x;
            Y = y;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is WorldMapCoord))
                return false;
            var wmc = (WorldMapCoord)obj;
            return wmc.X == X && wmc.Y == Y && wmc.MapId == MapId;
        }

        public override int GetHashCode()
        {
            return (int)((X * 100F) + (Y * 100f) + (MapId * 100f));
        }

        public static bool operator ==(WorldMapCoord a, WorldMapCoord b)
        {
            return a.X == b.X && a.Y == b.Y && a.MapId == b.MapId;
        }
        public static bool operator !=(WorldMapCoord a, WorldMapCoord b)
        {
            return a.X != b.X || a.Y != b.Y || a.MapId != b.MapId;
        }
    }
}