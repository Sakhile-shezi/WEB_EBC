
<%@ Page Title="Complete Patient Profile"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CompleteProfile.aspx.cs"
    Inherits="WebApplication1.Private.Appointments.CompleteProfile" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="container" style="max-width:750px; margin:30px auto;">

        <h2>Complete Your Patient Profile</h2>
        <p>Please enter your details to continue with appointment booking.</p>

        <asp:Label ID="lblMessage" runat="server"
            ForeColor="Red" />

        <div class="form-group">
            <label>Email Address</label>
            <asp:TextBox ID="txtEmail" runat="server"
                CssClass="form-control"
                ReadOnly="true" />
        </div>

        <div class="form-group">
            <label>Full Name</label>
            <asp:TextBox ID="txtFullName" runat="server"
                CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Date of Birth</label>
            <asp:TextBox ID="txtDateOfBirth" runat="server"
                TextMode="Date" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Phone Number</label>
            <asp:TextBox ID="txtPhone" runat="server"
                TextMode="Phone" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Alternative Phone Number</label>
            <asp:TextBox ID="txtAlternativePhone" runat="server"
                TextMode="Phone" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Address</label>
            <asp:TextBox ID="txtAddress" runat="server"
                CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>ID Number</label>
            <asp:TextBox ID="txtIDNumber" runat="server"
                CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Gender</label>
            <asp:DropDownList ID="ddlGender" runat="server"
                CssClass="form-control">
                <asp:ListItem Value="">Select Gender</asp:ListItem>
                <asp:ListItem>Male</asp:ListItem>
                <asp:ListItem>Female</asp:ListItem>
                <asp:ListItem>Other</asp:ListItem>
                <asp:ListItem Text="Prefer not to say" Value="Undisclosed" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label>Language</label>
            <asp:TextBox ID="txtLanguage" runat="server"
                CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Religion (Optional)</label>
            <asp:TextBox ID="txtReligion" runat="server"
                CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Marital Status</label>
            <asp:DropDownList ID="ddlMaritalStatus" runat="server"
                CssClass="form-control">
                <asp:ListItem Value="">Select Status</asp:ListItem>
                <asp:ListItem>Single</asp:ListItem>
                <asp:ListItem>Married</asp:ListItem>
                <asp:ListItem>Divorced</asp:ListItem>
                <asp:ListItem>Widowed</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label>Next of Kin Full Name</label>
            <asp:TextBox ID="txtNextOfKin" runat="server"
                CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Next of Kin Cell Number</label>
            <asp:TextBox ID="txtNextOfKinCell" runat="server"
                TextMode="Phone" CssClass="form-control" />
        </div>

        <br />

        <asp:Button ID="btnSaveProfile" runat="server"
            Text="Save Patient Profile"
            CssClass="btn btn-primary"
            OnClick="btnSaveProfile_Click" />

        <asp:SqlDataSource ID="SqlDataSource1UpdateProfilePatient" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>" DeleteCommand="DELETE FROM [Patient] WHERE [PatientID] = @original_PatientID AND [FullName] = @original_FullName AND [DateOfBirth] = @original_DateOfBirth AND (([Username] = @original_Username) OR ([Username] IS NULL AND @original_Username IS NULL)) AND (([Password] = @original_Password) OR ([Password] IS NULL AND @original_Password IS NULL)) AND [PhoneNumber] = @original_PhoneNumber AND [Address] = @original_Address AND [EmailAddress] = @original_EmailAddress AND (([AlternativePhoneNumber] = @original_AlternativePhoneNumber) OR ([AlternativePhoneNumber] IS NULL AND @original_AlternativePhoneNumber IS NULL)) AND (([PatientFileNumber] = @original_PatientFileNumber) OR ([PatientFileNumber] IS NULL AND @original_PatientFileNumber IS NULL)) AND (([IdNumber] = @original_IdNumber) OR ([IdNumber] IS NULL AND @original_IdNumber IS NULL)) AND (([Religion] = @original_Religion) OR ([Religion] IS NULL AND @original_Religion IS NULL)) AND (([Language] = @original_Language) OR ([Language] IS NULL AND @original_Language IS NULL)) AND (([MaritalStatus] = @original_MaritalStatus) OR ([MaritalStatus] IS NULL AND @original_MaritalStatus IS NULL)) AND (([NextOfKinName] = @original_NextOfKinName) OR ([NextOfKinName] IS NULL AND @original_NextOfKinName IS NULL)) AND (([NextOfKinCellNumber] = @original_NextOfKinCellNumber) OR ([NextOfKinCellNumber] IS NULL AND @original_NextOfKinCellNumber IS NULL)) AND (([gender] = @original_gender) OR ([gender] IS NULL AND @original_gender IS NULL)) AND (([UserId] = @original_UserId) OR ([UserId] IS NULL AND @original_UserId IS NULL))" InsertCommand="INSERT INTO Patient(FullName, DateOfBirth, PhoneNumber, Address, EmailAddress, AlternativePhoneNumber, IdNumber, Religion, Language, MaritalStatus, NextOfKinName, NextOfKinCellNumber, gender, UserId) VALUES (@FullName, @DateOfBirth, @PhoneNumber, @Address, @EmailAddress, @AlternativePhoneNumber, @IdNumber, @Religion, @Language, @MaritalStatus, @NextOfKinName, @NextOfKinCellNumber, @gender, @UserId)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [Patient] WHERE ([EmailAddress] = @EmailAddress)" UpdateCommand="UPDATE Patient SET FullName = @FullName, DateOfBirth = @DateOfBirth, PhoneNumber = @PhoneNumber, Address = @Address, EmailAddress = @EmailAddress, AlternativePhoneNumber = @AlternativePhoneNumber, IdNumber = @IdNumber, Religion = @Religion, Language = @Language, MaritalStatus = @MaritalStatus, NextOfKinName = @NextOfKinName, NextOfKinCellNumber = @NextOfKinCellNumber, gender = @gender WHERE (UserId = @UserId)">
            <DeleteParameters>
                <asp:Parameter Name="original_PatientID" Type="Int32" />
                <asp:Parameter Name="original_FullName" Type="String" />
                <asp:Parameter DbType="Date" Name="original_DateOfBirth" />
                <asp:Parameter Name="original_Username" Type="String" />
                <asp:Parameter Name="original_Password" Type="String" />
                <asp:Parameter Name="original_PhoneNumber" Type="String" />
                <asp:Parameter Name="original_Address" Type="String" />
                <asp:Parameter Name="original_EmailAddress" Type="String" />
                <asp:Parameter Name="original_AlternativePhoneNumber" Type="String" />
                <asp:Parameter Name="original_PatientFileNumber" Type="String" />
                <asp:Parameter Name="original_IdNumber" Type="String" />
                <asp:Parameter Name="original_Religion" Type="String" />
                <asp:Parameter Name="original_Language" Type="String" />
                <asp:Parameter Name="original_MaritalStatus" Type="String" />
                <asp:Parameter Name="original_NextOfKinName" Type="String" />
                <asp:Parameter Name="original_NextOfKinCellNumber" Type="String" />
                <asp:Parameter Name="original_gender" Type="String" />
                <asp:Parameter Name="original_UserId" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:ControlParameter ControlID="txtFullName" Name="FullName" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtDateOfBirth" DbType="Date" Name="DateOfBirth" PropertyName="Text" />
                <asp:ControlParameter ControlID="txtPhone" Name="PhoneNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtAddress" Name="Address" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtEmail" Name="EmailAddress" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtIDNumber" Name="IdNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtReligion" Name="Religion" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtLanguage" Name="Language" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="ddlMaritalStatus" Name="MaritalStatus" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="txtNextOfKin" Name="NextOfKinName" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtNextOfKinCell" Name="NextOfKinCellNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="ddlGender" Name="gender" PropertyName="SelectedValue" Type="String" />
                <asp:Parameter Name="UserId" />
            </InsertParameters>
            <SelectParameters>
                <asp:Parameter Name="EmailAddress" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:ControlParameter ControlID="txtFullName" Name="FullName" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtDateOfBirth" DbType="Date" Name="DateOfBirth" PropertyName="Text" />
                <asp:Parameter Name="Username" Type="String" />
                <asp:Parameter Name="Password" Type="String" />
                <asp:ControlParameter ControlID="txtPhone" Name="PhoneNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtAddress" Name="Address" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtEmail" Name="EmailAddress" PropertyName="Text" Type="String" />
                <asp:Parameter Name="AlternativePhoneNumber" Type="String" />
                <asp:Parameter Name="PatientFileNumber" Type="String" />
                <asp:ControlParameter ControlID="txtIDNumber" Name="IdNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtReligion" Name="Religion" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtLanguage" Name="Language" PropertyName="Text" Type="String" />
                <asp:Parameter Name="MaritalStatus" Type="String" />
                <asp:ControlParameter ControlID="txtNextOfKin" Name="NextOfKinName" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtNextOfKinCell" Name="NextOfKinCellNumber" PropertyName="Text" Type="String" />
                <asp:Parameter Name="gender" Type="String" />
                <asp:Parameter Name="UserId" Type="String" />
                <asp:Parameter Name="original_PatientID" Type="Int32" />
                <asp:Parameter Name="original_FullName" Type="String" />
                <asp:Parameter DbType="Date" Name="original_DateOfBirth" />
                <asp:Parameter Name="original_Username" Type="String" />
                <asp:Parameter Name="original_Password" Type="String" />
                <asp:Parameter Name="original_PhoneNumber" Type="String" />
                <asp:Parameter Name="original_Address" Type="String" />
                <asp:Parameter Name="original_EmailAddress" Type="String" />
                <asp:Parameter Name="original_AlternativePhoneNumber" Type="String" />
                <asp:Parameter Name="original_PatientFileNumber" Type="String" />
                <asp:Parameter Name="original_IdNumber" Type="String" />
                <asp:Parameter Name="original_Religion" Type="String" />
                <asp:Parameter Name="original_Language" Type="String" />
                <asp:Parameter Name="original_MaritalStatus" Type="String" />
                <asp:Parameter Name="original_NextOfKinName" Type="String" />
                <asp:Parameter Name="original_NextOfKinCellNumber" Type="String" />
                <asp:Parameter Name="original_gender" Type="String" />
                <asp:Parameter Name="original_UserId" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
        
<asp:SqlDataSource
    ID="SqlDataSourcePatientProfile"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"

    InsertCommand="
        INSERT INTO dbo.Patient
        (
            UserId,
            FullName,
            DateOfBirth,
            PhoneNumber,
            AlternativePhoneNumber,
            Address,
            EmailAddress,
            IdNumber,
            gender,
            Language,
            Religion,
            MaritalStatus,
            NextOfKinName,
            NextOfKinCellNumber
        )
        VALUES
        (
            @UserId,
            @FullName,
            @DateOfBirth,
            @PhoneNumber,
            @AltPhone,
            @Address,
            @Email,
            @IdNumber,
            @Gender,
            @Language,
            @Religion,
            @MaritalStatus,
            @NextOfKin,
            @NextOfKinCell
        )"

    UpdateCommand="
        UPDATE dbo.Patient
        SET
            FullName = @FullName,
            DateOfBirth = @DateOfBirth,
            PhoneNumber = @PhoneNumber,
            AlternativePhoneNumber = @AltPhone,
            Address = @Address,
            EmailAddress = @Email,
            IdNumber = @IdNumber,
            gender = @Gender,
            Language = @Language,
            Religion = @Religion,
            MaritalStatus = @MaritalStatus,
            NextOfKinName = @NextOfKin,
            NextOfKinCellNumber = @NextOfKinCell
        WHERE UserId = @UserId">

    <InsertParameters>
        <asp:Parameter Name="UserId" Type="String" />
        <asp:Parameter Name="FullName" Type="String" />
        <asp:Parameter Name="DateOfBirth" DbType="Date" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
        <asp:Parameter Name="AltPhone" Type="String" />
        <asp:Parameter Name="Address" Type="String" />
        <asp:Parameter Name="Email" Type="String" />
        <asp:Parameter Name="IdNumber" Type="String" />
        <asp:Parameter Name="Gender" Type="String" />
        <asp:Parameter Name="Language" Type="String" />
        <asp:Parameter Name="Religion" Type="String" />
        <asp:Parameter Name="MaritalStatus" Type="String" />
        <asp:Parameter Name="NextOfKin" Type="String" />
        <asp:Parameter Name="NextOfKinCell" Type="String" />
    </InsertParameters>

    <UpdateParameters>
        <asp:Parameter Name="UserId" Type="String" />
        <asp:Parameter Name="FullName" Type="String" />
        <asp:Parameter Name="DateOfBirth" DbType="Date" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
        <asp:Parameter Name="AltPhone" Type="String" />
        <asp:Parameter Name="Address" Type="String" />
        <asp:Parameter Name="Email" Type="String" />
        <asp:Parameter Name="IdNumber" Type="String" />
        <asp:Parameter Name="Gender" Type="String" />
        <asp:Parameter Name="Language" Type="String" />
        <asp:Parameter Name="Religion" Type="String" />
        <asp:Parameter Name="MaritalStatus" Type="String" />
        <asp:Parameter Name="NextOfKin" Type="String" />
        <asp:Parameter Name="NextOfKinCell" Type="String" />
    </UpdateParameters>

</asp:SqlDataSource>

    </div>
</asp:Content>
