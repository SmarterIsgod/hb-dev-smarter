using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SQLite;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmarterMMO_Stock
{
    public partial class _Default : Page
    {
        private const string ConnStr =
            "data source=\"C:\\Users\\Smarter\\Desktop\\Botting\\Development\\SmarterMMO\\SMMO Web Service\\StockDatabase\"";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private void DisplayServerData(ViewType viewType)
        {
            var sqlConnection = new SQLiteConnection(ConnStr);
            var sqlCommand = new SQLiteCommand(sqlConnection);
            SQLiteDataAdapter sqlDataAdapter;
            sqlConnection.Open();

            var serverList = new List<string>();
            var serverData = new List<DataSet>();
            try
            {
                sqlCommand.CommandText = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
                var sqlDataReader = sqlCommand.ExecuteReader();
                while (sqlDataReader.HasRows && sqlDataReader.Read())
                {
                    serverList.Add(sqlDataReader["name"].ToString());
                }
                sqlDataReader.Close();
                PlaceHolder1.Controls.Add(new LiteralControl("<br /> Server List Count: " + serverList.Count));

                foreach (var server in serverList)
                {
                    switch (viewType)
                    {
                        case ViewType.Character:
                            sqlCommand.CommandText = "SELECT * FROM " + server + " ORDER BY charStock DESC";
                            break;
                        case ViewType.Guild:
                            sqlCommand.CommandText = "SELECT * FROM " + server + " ORDER BY guildStock DESC";
                            break;
                        default:
                            sqlCommand.CommandText = "SELECT * FROM " + server + " ORDER BY UserId";
                            break;
                    }
                    sqlDataAdapter = new SQLiteDataAdapter(sqlCommand);
                    var dataSet = new DataSet(server);
                    sqlDataAdapter.Fill(dataSet);
                    serverData.Add(dataSet);
                }
                PlaceHolder1.Controls.Add(new LiteralControl("<br /> Server Data Count: " + serverData.Count + "<br /><br />"));
            }
            finally
            {
                sqlCommand.Dispose();
                sqlConnection.Close();
            }

            foreach (var dataSet in serverData)
            {
                var gridView = new GridView();
                PlaceHolder1.Controls.Add(new LiteralControl("<br /> <b><font size=\"6\" face=\"arial\">" + dataSet.DataSetName + "</font></b>"));
                PlaceHolder1.Controls.Add(gridView);
                PlaceHolder1.Controls.Add(new LiteralControl("<br />"));
                gridView.DataSource = dataSet;
                gridView.DataBind();
                gridView.Width = 250;
                gridView.HorizontalAlign = HorizontalAlign.Center;

            }
        }

        protected void Button1Click(object sender, EventArgs e)
        {
            DisplayServerData(ViewType.Default);
        }

        protected void Button2Click(object sender, EventArgs e)
        {
            DisplayServerData(ViewType.Character);
        }

        protected void Button3Click(object sender, EventArgs e)
        {
            DisplayServerData(ViewType.Guild);
        }
    }

    public enum ViewType
    {
        Guild,
        Character,
        Default
    }
}