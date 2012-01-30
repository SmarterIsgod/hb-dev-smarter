using System;
using System.Data.SQLite;

namespace SMMO_Web_Service
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "SmmoWebService" in code, svc and config file together.
    public class SmmoWebService : ISmmoService
    {
        public void UpdateStock(string server, string user, int charStock, int guildStock)
        {
            //Record Stock
            var sqlConnection =
                new SQLiteConnection("data source=\"C:\\Users\\Smarter\\Desktop\\Botting\\Development\\SmarterMMO\\SMMO Web Service\\StockDatabase\"");
            var sqlCommand = new SQLiteCommand(sqlConnection);
            sqlConnection.Open();
            var sqlTransaction = sqlConnection.BeginTransaction();
            try
            {
                sqlCommand.CommandText = "CREATE TABLE IF NOT EXISTS '" + server + "'(UserId VARCHAR(25), CharStock INTEGER, BankStock INTEGER)";
                sqlCommand.ExecuteNonQuery();
                sqlCommand.CommandText = "INSERT INTO " + server + "(UserID, CharStock) VALUES(@userId, @charStock, @guildStock)";
                sqlCommand.Parameters.AddWithValue("@userId", user);
                sqlCommand.Parameters.AddWithValue("@stock", charStock);
                sqlCommand.Parameters.AddWithValue("@guildStock", guildStock);
                sqlCommand.ExecuteNonQuery();
            }
            catch (Exception)
            {       
                sqlTransaction.Rollback();
            }
            finally
            {
                sqlTransaction.Commit();
                sqlCommand.Dispose();
                sqlConnection.Close();
            }
        }
    }
}
