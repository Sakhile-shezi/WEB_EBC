
<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="InitialAdminSetup.aspx.cs"
    Inherits="WebApplication1.InitialAdminSetup" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Initial Administrator Setup</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="max-width: 450px; margin: 50px auto; font-family: Arial;">

            <h2>Initial Administrator Setup</h2>

            <asp:Label ID="lblStatus" runat="server"
                ForeColor="Red" />

            <asp:Panel ID="pnlSetup" runat="server">

                <p>Administrator Email:</p>
                <asp:TextBox ID="txtEmail" runat="server"
                    TextMode="Email" Width="100%" />

                <p>Administrator Password:</p>
                <asp:TextBox ID="txtPassword" runat="server"
                    TextMode="Password" Width="100%" />

                <p>Confirm Password:</p>
                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    TextMode="Password" Width="100%" />

                <br /><br />

                <asp:Button ID="btnCreateAdmin" runat="server"
                    Text="Create Administrator"
                    OnClick="btnCreateAdmin_Click" />

            </asp:Panel>

        </div>
    </form>
</body>
</html>
