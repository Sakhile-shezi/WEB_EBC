<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication1.Account.Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <p class="text-danger">
            <asp:Literal runat="server" ID="ErrorMessage" />
        </p>
        <h4>Create a new account</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <div class="row">
            <asp:Label runat="server" AssociatedControlID="Email" CssClass="col-md-2 col-form-label">Email</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Email" CssClass="form-control" TextMode="Email" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                    CssClass="text-danger" ErrorMessage="The email field is required." />
            </div>
        </div>
        <div class="row">
            <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-2 col-form-label">Password</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                    CssClass="text-danger" ErrorMessage="The password field is required." />
            </div>
        </div>
        <div class="row">
            <asp:Label runat="server" AssociatedControlID="ConfirmPassword" CssClass="col-md-2 col-form-label">Confirm password</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" ErrorMessage="The password and confirmation password do not match." />
            </div>
        </div>
        <div class="row">
            <asp:Label runat="server" AssociatedControlID="TBFullName" CssClass="col-md-2 col-form-label" ID="lblFullName">Full Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="TBFullName" CssClass="form-control"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="TBFullName"
                    CssClass="text-danger" ErrorMessage="The full name is required." />
            </div>
        </div>
        <div class="row">
            <asp:Label runat="server" AssociatedControlID="DDLRole" CssClass="col-md-2 col-form-label">Role</asp:Label>
            <div class="col-md-10">
               
                 <asp:DropDownList ID="DDLRole"
                     runat="server"
                          CssClass="form-select"
                          Width="25.5%">

                    <asp:ListItem
                               Text="Doctor (Staff Only)"
                                   Value="Doctor"
                                   Enabled="false" />
                      <asp:ListItem
                                Text="Nurse (Staff Only)"
                                    Value="Nurse"
                                       Enabled="false" />

                       <asp:ListItem
                                   Text="Patient"
                                            Value="Patient"
                                    Selected="True" />

                             </asp:DropDownList>

                <asp:RequiredFieldValidator runat="server" ControlToValidate="DDLRole"
                    CssClass="text-danger" ErrorMessage="Role selection is required." />
            </div>
        </div>
        <div class="row">
            <asp:Label runat="server" AssociatedControlID="TBContactNo" CssClass="col-md-2 col-form-label">Contact Number</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="TBContactNo" CssClass="form-control"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="TBcontactNo"
                    CssClass="text-danger" ErrorMessage="Contact Number is required." />
            </div>
        </div>
        <div class="row">
            <div class="offset-md-2 col-md-10">
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Register" CssClass="btn btn-outline-dark" />
                <asp:SqlDataSource ID="SqlDataSource1RegisterPatientAccount" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>" DeleteCommand="DELETE FROM [Patient] WHERE [PatientID] = @original_PatientID AND [FullName] = @original_FullName AND [DateOfBirth] = @original_DateOfBirth AND (([Username] = @original_Username) OR ([Username] IS NULL AND @original_Username IS NULL)) AND (([Password] = @original_Password) OR ([Password] IS NULL AND @original_Password IS NULL)) AND [PhoneNumber] = @original_PhoneNumber AND [Address] = @original_Address AND [EmailAddress] = @original_EmailAddress AND (([AlternativePhoneNumber] = @original_AlternativePhoneNumber) OR ([AlternativePhoneNumber] IS NULL AND @original_AlternativePhoneNumber IS NULL)) AND (([PatientFileNumber] = @original_PatientFileNumber) OR ([PatientFileNumber] IS NULL AND @original_PatientFileNumber IS NULL)) AND (([IdNumber] = @original_IdNumber) OR ([IdNumber] IS NULL AND @original_IdNumber IS NULL)) AND (([Religion] = @original_Religion) OR ([Religion] IS NULL AND @original_Religion IS NULL)) AND (([Language] = @original_Language) OR ([Language] IS NULL AND @original_Language IS NULL)) AND (([MaritalStatus] = @original_MaritalStatus) OR ([MaritalStatus] IS NULL AND @original_MaritalStatus IS NULL)) AND (([NextOfKinName] = @original_NextOfKinName) OR ([NextOfKinName] IS NULL AND @original_NextOfKinName IS NULL)) AND (([NextOfKinCellNumber] = @original_NextOfKinCellNumber) OR ([NextOfKinCellNumber] IS NULL AND @original_NextOfKinCellNumber IS NULL)) AND (([gender] = @original_gender) OR ([gender] IS NULL AND @original_gender IS NULL)) AND (([UserId] = @original_UserId) OR ([UserId] IS NULL AND @original_UserId IS NULL))" InsertCommand="INSERT INTO [Patient] ([FullName], [DateOfBirth], [Username], [Password], [PhoneNumber], [Address], [EmailAddress], [AlternativePhoneNumber], [PatientFileNumber], [IdNumber], [Religion], [Language], [MaritalStatus], [NextOfKinName], [NextOfKinCellNumber], [gender], [UserId]) VALUES (@FullName, @DateOfBirth, @Username, @Password, @PhoneNumber, @Address, @EmailAddress, @AlternativePhoneNumber, @PatientFileNumber, @IdNumber, @Religion, @Language, @MaritalStatus, @NextOfKinName, @NextOfKinCellNumber, @gender, @UserId)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [Patient]" UpdateCommand="UPDATE [Patient] SET [FullName] = @FullName, [DateOfBirth] = @DateOfBirth, [Username] = @Username, [Password] = @Password, [PhoneNumber] = @PhoneNumber, [Address] = @Address, [EmailAddress] = @EmailAddress, [AlternativePhoneNumber] = @AlternativePhoneNumber, [PatientFileNumber] = @PatientFileNumber, [IdNumber] = @IdNumber, [Religion] = @Religion, [Language] = @Language, [MaritalStatus] = @MaritalStatus, [NextOfKinName] = @NextOfKinName, [NextOfKinCellNumber] = @NextOfKinCellNumber, [gender] = @gender, [UserId] = @UserId WHERE [PatientID] = @original_PatientID AND [FullName] = @original_FullName AND [DateOfBirth] = @original_DateOfBirth AND (([Username] = @original_Username) OR ([Username] IS NULL AND @original_Username IS NULL)) AND (([Password] = @original_Password) OR ([Password] IS NULL AND @original_Password IS NULL)) AND [PhoneNumber] = @original_PhoneNumber AND [Address] = @original_Address AND [EmailAddress] = @original_EmailAddress AND (([AlternativePhoneNumber] = @original_AlternativePhoneNumber) OR ([AlternativePhoneNumber] IS NULL AND @original_AlternativePhoneNumber IS NULL)) AND (([PatientFileNumber] = @original_PatientFileNumber) OR ([PatientFileNumber] IS NULL AND @original_PatientFileNumber IS NULL)) AND (([IdNumber] = @original_IdNumber) OR ([IdNumber] IS NULL AND @original_IdNumber IS NULL)) AND (([Religion] = @original_Religion) OR ([Religion] IS NULL AND @original_Religion IS NULL)) AND (([Language] = @original_Language) OR ([Language] IS NULL AND @original_Language IS NULL)) AND (([MaritalStatus] = @original_MaritalStatus) OR ([MaritalStatus] IS NULL AND @original_MaritalStatus IS NULL)) AND (([NextOfKinName] = @original_NextOfKinName) OR ([NextOfKinName] IS NULL AND @original_NextOfKinName IS NULL)) AND (([NextOfKinCellNumber] = @original_NextOfKinCellNumber) OR ([NextOfKinCellNumber] IS NULL AND @original_NextOfKinCellNumber IS NULL)) AND (([gender] = @original_gender) OR ([gender] IS NULL AND @original_gender IS NULL)) AND (([UserId] = @original_UserId) OR ([UserId] IS NULL AND @original_UserId IS NULL))">
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
                        <asp:Parameter Name="FullName" Type="String" />
                        <asp:Parameter DbType="Date" Name="DateOfBirth" />
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="PhoneNumber" Type="String" />
                        <asp:Parameter Name="Address" Type="String" />
                        <asp:Parameter Name="EmailAddress" Type="String" />
                        <asp:Parameter Name="AlternativePhoneNumber" Type="String" />
                        <asp:Parameter Name="PatientFileNumber" Type="String" />
                        <asp:Parameter Name="IdNumber" Type="String" />
                        <asp:Parameter Name="Religion" Type="String" />
                        <asp:Parameter Name="Language" Type="String" />
                        <asp:Parameter Name="MaritalStatus" Type="String" />
                        <asp:Parameter Name="NextOfKinName" Type="String" />
                        <asp:Parameter Name="NextOfKinCellNumber" Type="String" />
                        <asp:Parameter Name="gender" Type="String" />
                        <asp:Parameter Name="UserId" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="FullName" Type="String" />
                        <asp:Parameter DbType="Date" Name="DateOfBirth" />
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="PhoneNumber" Type="String" />
                        <asp:Parameter Name="Address" Type="String" />
                        <asp:Parameter Name="EmailAddress" Type="String" />
                        <asp:Parameter Name="AlternativePhoneNumber" Type="String" />
                        <asp:Parameter Name="PatientFileNumber" Type="String" />
                        <asp:Parameter Name="IdNumber" Type="String" />
                        <asp:Parameter Name="Religion" Type="String" />
                        <asp:Parameter Name="Language" Type="String" />
                        <asp:Parameter Name="MaritalStatus" Type="String" />
                        <asp:Parameter Name="NextOfKinName" Type="String" />
                        <asp:Parameter Name="NextOfKinCellNumber" Type="String" />
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
                <asp:Button ID="Button1" runat="server" Text="Add Patient Customer" />
            </div>
        </div>
    </main>
</asp:Content>
