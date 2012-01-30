using System;
using System.Data;
using System.Text;
using System.Windows.Forms;
using Styx;
using Styx.Logic.Pathing;
using Styx.Patchables;

namespace HotspotFetcher
{
    public partial class Form1 : Form
    {
        DataTable dataTable = new DataTable();
        public Form1()
        {
            InitializeComponent();
            dataTable.Columns.Add("Map Coords", typeof(string));
            dataTable.Columns.Add("World Coords", typeof(string));
            dataGrid.DataSource = dataTable;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                int npcId = 0;
                if (textBox1.Text.Length > 2)
                {
                    npcId = Convert.ToInt32((string) textBox1.Text);
                }
                var parser = new Wowhead.WowheadParser(Wowhead.FetchNpcLocations(npcId));

                foreach (var c in parser.WowheadCoords)
                {
                    dataTable.Rows.Add(string.Format("{0},{1}", c.X, c.Y), c.ToLocation().ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            float x = 0f;
            float y = 0f;
            uint mapid = 0u;
            if (textBox1.Text.Length > 2)
            {
                x = Convert.ToSingle(textBox1.Text.Split(',')[0]);
                y = Convert.ToSingle(textBox1.Text.Split(',')[1]);
                mapid = Convert.ToUInt32(textBox1.Text.Split(',')[2]);
            }
            var coord = new WowheadCoord(x, y, mapid);
            MessageBox.Show(coord.ToLocation().ToString());

        }
    }
}