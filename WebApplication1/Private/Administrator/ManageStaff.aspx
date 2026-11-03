
<%@ Page Title="Manage Staff" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageStaff.aspx.cs"
    Inherits="WebApplication1.Private.Administrator.ManageStaff" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <h2>Staff Account Management</h2>
        <p>Create login accounts for Doctors and Nurses.</p>

        <hr />

        <asp:Label ID="lblMessage" runat="server"
            EnableViewState="false" />

        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="txtEmail">
                Email Address
            </asp:Label>

            <asp:TextBox ID="txtEmail" runat="server"
                CssClass="form-control"
                TextMode="Email" />

            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="Email is required."
                CssClass="text-danger"
                ValidationGroup="StaffRegistration" />
        </div>

        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="txtPassword">
                Temporary Password
            </asp:Label>

            <asp:TextBox ID="txtPassword" runat="server"
                CssClass="form-control"
                TextMode="Password" />

            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="Password is required."
                CssClass="text-danger"
                ValidationGroup="StaffRegistration" />
        </div>

        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="txtConfirmPassword">
                Confirm Password
            </asp:Label>

            <asp:TextBox ID="txtConfirmPassword" runat="server"
                CssClass="form-control"
                TextMode="Password" />

            <asp:CompareValidator runat="server"
                ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtPassword"
                ErrorMessage="Passwords do not match."
                CssClass="text-danger"
                ValidationGroup="StaffRegistration" />
        </div>

        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="ddlRole">
                Staff Role
            </asp:Label>

            <asp:DropDownList ID="ddlRole" runat="server"
                CssClass="form-control">

                <asp:ListItem Text="Doctor" Value="Doctor" />
                <asp:ListItem Text="Nurse" Value="Nurse" />

            </asp:DropDownList>
        </div>

        <asp:Button ID="btnCreateStaff" runat="server"
            Text="Create Staff Account"
            CssClass="btn btn-primary"
            ValidationGroup="StaffRegistration"
            OnClick="btnCreateStaff_Click" />

    </main>

</asp:Content>
