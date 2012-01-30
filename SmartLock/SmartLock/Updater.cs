using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Reflection;
using System.Xml.Linq;
using System.IO;
using System.Security.Cryptography;
using System.Drawing;

using Styx.Combat.CombatRoutine;
using Styx.Helpers;

namespace Ensemble
{
    public partial class Ensemble : CombatRoutine
    {
        private void Update()
        {
            try
            {
                string EnsemblePath = Logging.ApplicationPath + "\\CustomClasses\\Ensemble";
                string EnsembleUrl = "http://www.doganaydos.com/honorbuddy/ensemble/bin";

                WebClient client = new WebClient();
                

                XDocument manifestLatest = XDocument.Load(EnsembleUrl + "/manifest.xml");
                XDocument manifestCurrent = XDocument.Load(EnsemblePath + "\\manifest.xml");
                DateTime latestTime = DateTime.Parse(manifestLatest.Element("Manifest").Element("UpdateTime").Value);
                DateTime currentTime = DateTime.Parse(manifestCurrent.Element("Manifest").Element("UpdateTime").Value);

                if (latestTime <= currentTime)
                    return;

                client.DownloadFile(EnsembleUrl + "/manifest.xml", EnsemblePath + "\\manifest.xml");

                Dictionary<string, string> fileList = new Dictionary<string, string>();
                foreach (XElement fileNode in manifestLatest.Element("Manifest").Descendants("File"))
                {
                    string path = fileNode.Element("Path").Value;
                    string hash = fileNode.Element("Hash").Value;
                    fileList.Add(path, hash);
                }
                int count = 0;
                foreach (KeyValuePair<string, string> file in fileList)
                {
                    string HashCode;
                    if (File.Exists(EnsemblePath + @file.Key))
                    {
                        FileStream stmcheck = File.OpenRead(EnsemblePath + @file.Key);
                        byte[] hash = new MD5CryptoServiceProvider().ComputeHash(stmcheck);
                        HashCode = BitConverter.ToString(hash).Replace("-", "");
                        stmcheck.Close();
                    }
                    else
                        HashCode = "";

                    if (HashCode != file.Value)
                    {
                        count++;
                        if (@file.Key.Contains('\\') && @file.Key.LastIndexOf('\\') != 0)
                        {
                            string directoryName = @file.Key.Remove(@file.Key.LastIndexOf('\\'));
                            Directory.CreateDirectory(EnsemblePath + directoryName);
                        }

                        string url = EnsembleUrl + @file.Key;
                        client.DownloadFile(url.Replace('\\', '/'), EnsemblePath + @file.Key);
                        if (HashCode == "")
                            Log(Color.DarkRed, "Added {0}", file.Key);
                        else
                            Log(Color.DarkRed, "Updated {0}", file.Key);
                    }
                }
                if (count > 0)
                {
                    Log(Color.DarkRed ,"Downloaded {0} new file{1}", count, count == 1 ? "" : "s");
                    Log(Color.DarkRed, "Restart HB to let changes take effect");
                }
            }
            catch (Exception e)
            {
                dLog(e.ToString());
            }
        }
    }
}
