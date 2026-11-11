
<%@ Page Title="Manage Staff" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageStaff.aspx.cs"
    Inherits="WebApplication1.Private.Administrator.ManageStaff" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <h2>Staff Account Management</h2>
        <p>Create login accounts and link them to existing clinic records.</p>

        <hr />

        <asp:Label ID="lblMessage" runat="server"
            EnableViewState="false" />

        <!-- Select staff role -->
        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="ddlRole">
                Staff Role
            </asp:Label>

            <asp:DropDownList ID="ddlRole" runat="server"
                CssClass="form-control"
                AutoPostBack="true"
                CausesValidation="false"
                OnSelectedIndexChanged="ddlRole_SelectedIndexChanged">

                <asp:ListItem Text="Doctor" Value="Doctor" />
                <asp:ListItem Text="Nurse" Value="Nurse" />

            </asp:DropDownList>
        </div>

        <!-- Select existing clinic record -->
        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="ddlClinicRecord">
                Existing Clinic Record
            </asp:Label>

            <asp:DropDownList ID="ddlClinicRecord" runat="server"
                CssClass="form-control"
                DataSourceID="sqlClinicRecords"
                DataTextField="FullName"
                DataValueField="RecordID"
                AppendDataBoundItems="true">

                <asp:ListItem Text="-- Select a clinic record --"
                    Value="" />

            </asp:DropDownList>

            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="ddlClinicRecord"
                InitialValue=""
                ErrorMessage="Please select a clinic record."
                CssClass="text-danger"
                ValidationGroup="StaffRegistration" />
        </div>

        <!-- Email -->
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

        <!-- Password -->
        <div class="mb-3">
            <asp:Label runat="server"
                AssociatedControlID="txtPassword">
                Password
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

        <!-- Confirm password -->
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

        <asp:Button ID="btnCreateStaff" runat="server"
            Text="Create Account & Link Record"
            CssClass="btn btn-primary"
            ValidationGroup="StaffRegistration"
            OnClick="btnCreateStaff_Click" />

    </main>

    <!-- SQL Server data source for clinic records -->
    <asp:SqlDataSource ID="sqlClinicRecords" runat="server"
        ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"
        SelectCommand="SELECT DoctorID AS RecordID, FullName FROM dbo.Doctor WHERE UserId IS NULL">
    </asp:SqlDataSource>

</asp:Content>

