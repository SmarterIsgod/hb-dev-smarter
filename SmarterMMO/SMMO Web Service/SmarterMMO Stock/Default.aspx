<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SmarterMMO_Stock._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: center">
    
        <asp:SqlDataSource ID="StockDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:connectionString %>" 
            ProviderName="<%$ ConnectionStrings:connectionString.ProviderName %>" SelectCommand="SELECT name FROM sqlite_master
WHERE type='table'
ORDER BY name;"></asp:SqlDataSource>
    
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="StockDataSource" EnableModelValidation="True" 
            HorizontalAlign="Center" style="text-align: center" Width="300px">
            <Columns>
                <asp:BoundField DataField="name" HeaderText="Server List" 
                    SortExpression="name" />
            </Columns>
        </asp:GridView>
        <asp:Button ID="Button1" runat="server" onclick="Button1Click" 
            Text="Sort By Name" />
        <asp:Button ID="Button2" runat="server" onclick="Button2Click" Text="Sort By Character Balance" />
        <asp:Button ID="Button3" runat="server" onclick="Button3Click" Text="Sort By GB Balance" />
        <br />
        <br />
        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
    
    </div>
    </form>
</body>
</html>
