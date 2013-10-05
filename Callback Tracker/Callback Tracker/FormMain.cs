using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Windows.Forms;

namespace Callback_Tracker
{
    public partial class FormMain : Form
    {
        private readonly List<PointCaller> _pointCallers;
        public FormMain()
        {
            InitializeComponent();
            _pointCallers = new List<PointCaller>();
            if (!File.Exists(Application.StartupPath + "\\Database.inf"))
            {
                var stream = File.Create(Application.StartupPath + "\\Database.inf");
                stream.Close();
            }
            else
            {
                var reader = new StreamReader(Application.StartupPath + "\\Database.inf");
                while (!reader.EndOfStream)
                {
                    var line = reader.ReadLine();
                    if (line != null)
                    {
                        var split = line.Split('|');
                        _pointCallers.Add(new PointCaller(split[0], Convert.ToInt32(split[1])));
                    }
                }
                reader.Close();
            }

            cmbPointCallers.Items.Clear();
            foreach (var pointCaller in _pointCallers)
            {
                cmbPointCallers.Items.Add(pointCaller.Name);
            }

        }

        private void ButtonCountUpClick(object sender, EventArgs e)
        {
            _pointCallers[cmbPointCallers.SelectedIndex].Count++;
            RefreshCount();
        }

        private void ButtonCountDownClick(object sender, EventArgs e)
        {
            _pointCallers[cmbPointCallers.SelectedIndex].Count--;
            RefreshCount();
        }

        private void SaveToolStripMenuItemClick(object sender, EventArgs e)
        {
            SaveData();
        }

        private void SaveData()
        {
            var writer = new StreamWriter(Application.StartupPath + "\\Database.inf", false);
            foreach (var pointCaller in _pointCallers)
            {
                writer.WriteLine(pointCaller.Name + "|" + pointCaller.Count);
            }
            writer.Close();
        }

        private void CmbPointCallersSelectedIndexChanged(object sender, EventArgs e)
        {
            RefreshCount();
        }

        private void RefreshCount()
        {
            lblCount.Text = _pointCallers[cmbPointCallers.SelectedIndex].Count.ToString(CultureInfo.InvariantCulture);
        }

        private void ExitToolStripMenuItemClick(object sender, EventArgs e)
        {
            SaveData();
            Application.Exit();
        }

        private void ResetToolStripMenuItemClick(object sender, EventArgs e)
        {
// ReSharper disable LocalizableElement
            var result = MessageBox.Show("Are you sure?", "Confirm", MessageBoxButtons.YesNo);
            if (result != DialogResult.Yes) return;
            foreach (var pointCaller in _pointCallers)
            {
                pointCaller.Count = 0;
            }
            RefreshCount();
// ReSharper restore LocalizableElement
        }

        private void StatisticsToolStripMenuItemClick(object sender, EventArgs e)
        {
// ReSharper disable LocalizableElement
            MessageBox.Show("Statistics have been Output to File");
// ReSharper restore LocalizableElement
            var writer = new StreamWriter(Application.StartupPath + "\\Statistics.txt", false);
            writer.WriteLine("Callback Tracker Statistics for " + DateTime.Now.ToShortDateString());
            writer.WriteLine("----------------------------------------");
            writer.WriteLine();
            foreach (var pointCaller in _pointCallers)
            {
                writer.WriteLine(pointCaller.Name + " has had " + pointCaller.Count + " successful callbacks.");
            }
            writer.Close();
        }

        private void FormMainFormClosing(object sender, FormClosingEventArgs e)
        {
            SaveData();
        }

    }

    public class PointCaller
    {
        public PointCaller(string name, int count)
        {
            Name = name;
            Count = count;
        }

        public readonly string Name;

        public int Count { get; set; }
    }
}
